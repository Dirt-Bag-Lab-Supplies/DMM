#pragma once

#include <string>
#include "external\ftd2xx.h"

namespace DBLS
{
	namespace Utility
	{
		void ThrowIfFailed(FT_STATUS status, std::string msg = "");
	}
}