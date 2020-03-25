#include <functional>
#include <algorithm>

#include "external/cxxopts.hpp"

#include "FTDIInterface.hpp"

using namespace DBLS;

std::string ExtractToken(char* cmdToken);

struct Command
{
	using Fn = std::function<bool(const cxxopts::ParseResult& args)>;

	std::string name;
	cxxopts::Options cmdOpts;

	Fn fn;

	Command(std::string&& name, cxxopts::Options&& cmdOpts, Fn&& fn)
		: name{ std::move(name) }
		, cmdOpts{ std::move(cmdOpts) }
		, fn{ std::move(fn) }
	{
	}
};

bool CommandEnumerate(const cxxopts::ParseResult& args)
{
	bool success = true;

	try
	{
		FTDIInterface ftdi;

		auto devices = ftdi.EnumerateDevices();
		std::cout << "Detected " << devices.size() << ((devices.size() == 1) ? " device" : " devices") << std::endl;
		for (const auto& device : devices)
		{
			std::cout << FTDIInterface::ToString(device, 1) << '\n' << std::endl;
		}
	}
	catch (const std::exception& e)
	{
		success = false;

		std::cerr << e.what() << std::endl;
	}

	return success;
}

int main(int argc, char** argv)
{
	std::vector<Command> commands;
	
	cxxopts::Options opts{ "enumerate", "Enumerate connected devices" };
	commands.emplace_back(Command
	{
		"enumerate",
		cxxopts::Options{ "enumerate", "Enumerate connected devices" },
		CommandEnumerate
	});

	int argCount = argc - 1;
	char** arguments = argv + 1;

	bool success = false;

	if (argCount > 0)
	{
		auto cmdStr = ExtractToken(arguments[0]);
		auto cmd = std::find_if(commands.begin(), commands.end(), [&cmdStr](const auto& cmd)
			{
				return cmd.name == cmdStr;
			});

		if (cmd == commands.end())
		{
			std::cerr << "Error: command '" << cmdStr << "' not valid" << std::endl;
		}
		else
		{
			success = cmd->fn(cmd->cmdOpts.parse(argCount, arguments));
			if (!success)
			{
				std::cerr << "Error: command failed" << std::endl;
			}
		}
	}
	else
	{
		std::cerr << "Error: Not enough arguments" << std::endl;
	}

	return success ? 0 : 1;
}

std::string ExtractToken(char* cmdToken)
{
	if (cmdToken[0] == '-')
	{
		//Remove leading dash if present
		++cmdToken;
	}

	std::string str = cmdToken;

	for (auto& c : str)
	{
		c = std::tolower(c);
	}

	return str;
}