#include <functional>
#include <algorithm>

#include "external/cxxopts.hpp"

#include "FTDIInterface.hpp"

#include "CommandParser.hpp"
#include "Commands.hpp"

using namespace DBLS;
using namespace DBLS::Commands;

int main(int argc, char** argv)
{
	std::vector<Command> commands;
	
	commands.emplace_back(Command
	{
		"enumerate",
		cxxopts::Options{ "enumerate", "Enumerate connected devices" },
		CommandEnumerate
	});

	{
		cxxopts::Options opt{ "deviceinfo", "Get info about connected device" };
		opt.add_options()("d,device", "Device name string", cxxopts::value<std::string>());

		commands.emplace_back(Command
		{
			"deviceinfo",
			std::move(opt),
			CommandDeviceInfo
		});
	}

	{
		cxxopts::Options opt{ "read", "Read from device" };
		opt.add_options()
			("device", "Device name string", cxxopts::value<std::string>())
			("size", "Read size, in bytes", cxxopts::value<int>())
			("file", "Output file name", cxxopts::value<std::string>())
			("s", "Set mode to SyncFifo before reading");

		commands.emplace_back(Command
		{
			"read",
			std::move(opt),
			CommandRead
		});
	}

	{
		cxxopts::Options opt{ "setfifomode", "Set FIFO mode in EEPROM (2232h)" };
		opt.add_options()
			("device", "Device name string", cxxopts::value<std::string>())
			("enable", "Enable FIFO mode")
			("disable", "Disable FIFO mode");

		commands.emplace_back(Command
		{
			"setfifomode",
			std::move(opt),
			CommandSetFifoMode
		});
	}

	int argCount = argc - 1;
	char** arguments = argv + 1;

	bool success = false;

	if (argCount > 0)
	{
		auto cmdStr = ExtractToken(arguments[0]);
		if (cmdStr == "help")
		{
			std::cout << GetHelpString(commands) << std::endl;
			success = true;
		}
		else
		{
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
	}
	else
	{
		std::cout << GetHelpString(commands) << std::endl;
	}

	return success ? 0 : 1;
}