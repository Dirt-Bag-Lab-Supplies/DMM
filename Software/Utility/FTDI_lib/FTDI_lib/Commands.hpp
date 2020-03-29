#pragma once

#include "external\cxxopts.hpp"

namespace DBLS
{
	namespace Commands
	{
		bool CommandEnumerate(const cxxopts::ParseResult& args);

		bool CommandDeviceInfo(const cxxopts::ParseResult& args);

		bool CommandRead(const cxxopts::ParseResult& args);

		bool CommandSetFifoMode(const cxxopts::ParseResult& args);
	}
}