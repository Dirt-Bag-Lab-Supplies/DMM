#include "FTDIInterface.hpp"

#include <sstream>
#include "Utility.hpp"

namespace DBLS
{
	using namespace Utility;

	FTDIInterface::FTDIInterface()
	{
	}

	std::vector<FT_DEVICE_LIST_INFO_NODE> FTDIInterface::EnumerateDevices() const
	{
		//Query driver for number of devices
		DWORD deviceCount;
		ThrowIfFailed(FT_CreateDeviceInfoList(&deviceCount));

		//Create array of device info structs
		std::vector<FT_DEVICE_LIST_INFO_NODE> devices(deviceCount);

		if (deviceCount > 0)
		{
			//Fetch detail about each device
			ThrowIfFailed(FT_GetDeviceInfoList(devices.data(), &deviceCount));
		}

		return devices;
	}

	std::string FTDIInterface::ToString(FT_DEVICE_LIST_INFO_NODE deviceInfo, int tabCount)
	{
		/*
		 Flags (DWORD)
		 FT_FLAGS_OPENED = 0x00000001		 FT_FLAGS_HIGHSPEED = 0x00000002 (or lowspeed if clear)
		 Type (DWORD)
		 Device type

		 ID (DWORD)
		 Device ID

		 LocId (DWORD)
		 Device location ID
		 
		 SerialNumber (char[16])
		 Null terminated

		 Description (char[64])
		 Null terminated

		 ftHandle (FT_HANDLE)
		*/

		auto indent = std::string(tabCount, '\t');

		std::stringstream sstr;
		sstr <<
			indent << "Serial Number: " << deviceInfo.SerialNumber << '\n' <<
			indent << "Description: " << deviceInfo.Description << '\n' <<
			indent << "Device ID: " << std::hex << deviceInfo.ID << '\n' <<
			indent << "Device Type: " << std::hex << deviceInfo.Type << '\n' <<
			indent << "Device Location ID: " << std::hex << deviceInfo.LocId << '\n' <<
			indent << "USB Bandwidth: " << ((deviceInfo.Flags & 0x02) ? "HighSpeed" : "FullSpeed") << '\n' <<
			indent << "Device Status: " << ((deviceInfo.Flags & 0x01) ? "Open" : "Not open");

		return sstr.str();
	}
}