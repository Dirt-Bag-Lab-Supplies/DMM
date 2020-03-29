#include "CommandParser.hpp"

namespace DBLS
{
	namespace Commands
	{
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

		std::string GetHelpString(const std::vector<Command>& commands)
		{
			std::string str;
			for (const auto& cmd : commands)
			{
				str += cmd.name + ": " + cmd.cmdOpts.help() + '\n';
			}

			return str;
		}
	}
}