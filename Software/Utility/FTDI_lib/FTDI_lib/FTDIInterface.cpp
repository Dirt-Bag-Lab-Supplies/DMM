#include "FTDIInterface.hpp"

#include <sstream>
#include <map>

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
		ThrowIfFailed(FT_CreateDeviceInfoList(&deviceCount), "FT_CreateDeviceInfoList");

		//Create array of device info structs
		std::vector<FT_DEVICE_LIST_INFO_NODE> devices(deviceCount);

		if (deviceCount > 0)
		{
			//Fetch detail about each device
			ThrowIfFailed(FT_GetDeviceInfoList(devices.data(), &deviceCount), "FT_GetDeviceInfoList");
		}

		return devices;
	}

	FTDIDevice FTDIInterface::OpenDeviceFromDescription(std::string desc)
	{
		FT_HANDLE handle;

		//Get the raw characters from the string
		std::vector<char> chars(desc.begin(), desc.end());
		chars.push_back('\0'); //Null terminate

		ThrowIfFailed(FT_OpenEx(chars.data(), FT_OPEN_BY_DESCRIPTION, &handle),
			"FT_OpenEx");

		return FTDIDevice(handle);
	}

	FTDIDevice FTDIInterface::OpenDeviceFromSerialNumber(std::string serial)
	{
		FT_HANDLE handle;

		//Get the raw characters from the string
		std::vector<char> chars(serial.begin(), serial.end());
		chars.push_back('\0'); //Null terminate

		ThrowIfFailed(FT_OpenEx(chars.data(), FT_OPEN_BY_SERIAL_NUMBER, &handle),
			"FT_OpenEX");

		return FTDIDevice(handle);
	}

	std::string FTDIInterface::DeviceToString(FT_DEVICE device)
	{
		static const std::map<FT_DEVICE, std::string> deviceMap
		{
			{FT_DEVICE_232H, "FT232H"},
			{FT_DEVICE_4232H, "FT4232H"},
			{FT_DEVICE_2232H, "FT2232H"},
			{FT_DEVICE_232R, "FT232R"},
			{FT_DEVICE_2232C, "FT2232C"},
			{FT_DEVICE_BM, "FTU232BM"},
			{FT_DEVICE_AM, "FT8U232AM"}
		};

		auto found = deviceMap.find(device);
		if (found == deviceMap.end())
		{
			return "UNKNOWN";
		}
		else
		{
			return found->second;
		}
	}

	std::string FTDIInterface::IDToString(DWORD id)
	{
		std::stringstream sstr;
		sstr << "VID_" << std::hex << (id >> 16) << "&PID_" << (id & 0xFFFF);

		return sstr.str();
	}

	std::string FTDIInterface::ToString(FT_DEVICE_LIST_INFO_NODE deviceInfo, int tabCount)
	{
		auto indent = std::string(tabCount, '\t');

		std::stringstream sstr;
		sstr <<
			indent << "Serial Number: " << deviceInfo.SerialNumber << '\n' <<
			indent << "Description: " << deviceInfo.Description << '\n' <<
			indent << "Device ID: " << IDToString(deviceInfo.ID) << '\n' <<
			indent << "Device Type: " << DeviceToString(deviceInfo.Type) << '\n' <<
			indent << "Device Location ID: " << std::hex << deviceInfo.LocId << '\n' <<
			indent << "USB Bandwidth: " << ((deviceInfo.Flags & 0x02) ? "HighSpeed" : "FullSpeed") << '\n' <<
			indent << "Device Status: " << ((deviceInfo.Flags & 0x01) ? "Open" : "Not open");

		return sstr.str();
	}
}