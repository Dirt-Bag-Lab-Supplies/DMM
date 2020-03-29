#pragma once

#include <string>
#include <functional>

#include "external\cxxopts.hpp"

namespace DBLS
{
	namespace Commands
	{
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

		std::string ExtractToken(char* cmdToken);

		std::string GetHelpString(const std::vector<Command>& commands);
	}
}