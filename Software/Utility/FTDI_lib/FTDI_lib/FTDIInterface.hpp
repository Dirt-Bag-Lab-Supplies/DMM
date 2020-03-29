#pragma once

#include <vector>

#include "external/ftd2xx.h"

#include "FTDIDevice.hpp"

namespace DBLS
{
	class FTDIInterface
	{
	public:
		FTDIInterface();

		std::vector<FT_DEVICE_LIST_INFO_NODE> EnumerateDevices() const;

		FTDIDevice OpenDeviceFromDescription(std::string desc);

		FTDIDevice OpenDeviceFromSerialNumber(std::string serial);

		static std::string DeviceToString(FT_DEVICE device);

		static std::string IDToString(DWORD id);

		static std::string ToString(FT_DEVICE_LIST_INFO_NODE deviceInfo, int tabCount = 0);
	};
}