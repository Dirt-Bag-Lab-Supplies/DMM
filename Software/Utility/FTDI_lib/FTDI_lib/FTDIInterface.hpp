#pragma once

#include <vector>
#include "external/ftd2xx.h"

namespace DBLS
{
	class FTDIInterface
	{
	public:
		FTDIInterface();

		std::vector<FT_DEVICE_LIST_INFO_NODE> EnumerateDevices() const;

		static std::string ToString(FT_DEVICE_LIST_INFO_NODE deviceInfo, int tabCount = 0);
	};
}