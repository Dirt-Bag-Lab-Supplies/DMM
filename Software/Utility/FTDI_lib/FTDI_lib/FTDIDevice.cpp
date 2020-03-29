#include "FTDIDevice.hpp"

#include "Utility.hpp"

#include <sstream>
#include <vector>
#include <cctype>

namespace DBLS
{
	using namespace Utility;

	FTDIDevice::FTDIDevice(FT_HANDLE handle)
		: m_handle{ handle }
	{
		auto info = GetInfo();
		m_type = info.device;

		auto len = info.serialNumber.length();
		auto lastChar = info.serialNumber[len - 1];
		switch (lastChar)
		{
		case 'A':
			m_channel = Channel::A;
			break;
		case 'B':
			m_channel = Channel::B;
			break;
		default:
			throw std::runtime_error("FTDIDevice: Cannot parse channel from serial number");
			break;
		}
	}

	FTDIDevice::~FTDIDevice()
	{
		ThrowIfFailed(FT_Close(m_handle), "FTDI_Close");
		m_handle = 0;
	}

	FTDIDevice::Channel FTDIDevice::GetChannel() const
	{
		return m_channel;
	}

	FTDIDevice::Info FTDIDevice::GetInfo() const
	{
		Info info;

		std::vector<char> serialNum(16);
		std::vector<char> desc(64);

		ThrowIfFailed(FT_GetDeviceInfo(
			m_handle,
			&info.device,
			&info.ID,
			serialNum.data(),
			desc.data(),
			nullptr),
			"FT_GetDeviceInfo");

		info.serialNumber = std::string(serialNum.data());
		info.description = std::string(desc.data());

		return info;
	}

	FTDIDevice::Status FTDIDevice::GetStatus() const
	{
		Status status;
		DWORD eventStatus;

		ThrowIfFailed(FT_GetStatus(
			m_handle,
			&status.recvQueueLength,
			&status.sendQueueLength,
			&eventStatus),
			"FT_GetStatus");

		return status;
	}

	FTDIDevice::BitMode FTDIDevice::GetBitMode() const
	{
		uint8_t rawMode = 0;

		ThrowIfFailed(FT_GetBitMode(
			m_handle,
			&rawMode),
			"FT_GetBitMode");

		return static_cast<BitMode>(rawMode);
	}

	void FTDIDevice::SetBitMode(BitMode mode, uint8_t mask)
	{
		ThrowIfFailed(FT_SetBitMode(
			m_handle,
			mask,
			static_cast<uint8_t>(mode)),
			"FT_SetBitMode");
	}

	void FTDIDevice::SetTimeouts(uint32_t readTimeoutMs, uint32_t writeTimeoutMs)
	{
		ThrowIfFailed(FT_SetTimeouts(
			m_handle,
			readTimeoutMs,
			writeTimeoutMs),
			"FT_SetTimeouts");
	}

	void FTDIDevice::ClearQueues(Direction dirToClear)
	{
		DWORD mask = 0;
		switch (dirToClear)
		{
		case Direction::Send:
			mask |= FT_PURGE_TX;
			break;

		case Direction::Recv:
			mask |= FT_PURGE_RX;
			break;

		case Direction::Both:
			mask = FT_PURGE_TX | FT_PURGE_RX;
			break;
		}

		ThrowIfFailed(FT_Purge(m_handle, mask),
			"FT_Purge");
	}

	void FTDIDevice::Reset()
	{
		ThrowIfFailed(FT_ResetDevice(m_handle),
			"FT_ResetDevice");
	}

	size_t FTDIDevice::Read(void* buffer, size_t size)
	{
		DWORD bytesRead;

		ThrowIfFailed(FT_Read(
			m_handle,
			buffer,
			static_cast<DWORD>(size),
			&bytesRead),
			"FT_Read");

		return bytesRead;
	}

	FTDIDevice::EEPROMData FTDIDevice::ReadEEPROM2232H()
	{
		EEPROMData data;

		if (m_type != FT_DEVICE_2232H)
		{
			throw std::runtime_error("ReadEEPROM2232: Device type not supported");
		}

		data.data.common.deviceType = FT_DEVICE_2232H;

		ThrowIfFailed(FT_EEPROM_Read(
			m_handle,
			reinterpret_cast<void*>(&data.data),
			sizeof(data.data),
			data.manufacturer,
			data.manufacturerId,
			data.description,
			data.serialNumber),
			"FT_EEPROM_Read");

		return data;
	}

	void FTDIDevice::WriteEEPROM2232H(FTDIDevice::EEPROMData& data)
	{
		if (m_type != FT_DEVICE_2232H)
		{
			throw std::runtime_error("WriteEEPROM2232: Device type not supported");
		}

		ThrowIfFailed(FT_EEPROM_Program(
			m_handle,
			reinterpret_cast<void*>(&data.data),
			sizeof(data.data),
			data.manufacturer,
			data.manufacturerId,
			data.description,
			data.serialNumber),
			"FT_EEPROM_Program");
	}

	std::string FTDIDevice::BitModeToString(BitMode mode)
	{
		std::string str;

		switch (mode)
		{
		case BitMode::Reset:
			str = "Reset";
			break;
		case BitMode::AsyncBitbang:
			str = "AsyncBitbang";
			break;
		case BitMode::MPSSE:
			str = "MPSSE";
			break;
		case BitMode::SyncBitbang:
			str = "SyncBitbang";
			break;
		case BitMode::MCUHost:
			str = "MCUHost";
			break;
		case BitMode::FastSerial:
			str = "FastSerial";
			break;
		case BitMode::CBUSBitbang:
			str = "CBUSBitbang";
			break;
		case BitMode::SyncFifo:
			str = "SyncFifo";
			break;
		default:
			str = "Unknown";
			break;
		}

		return str;
	}
}