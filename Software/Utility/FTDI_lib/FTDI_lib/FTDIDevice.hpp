#pragma once

#include "external/ftd2xx.h"

#include <string>
#include <cstdint>

namespace DBLS
{
	class FTDIDevice
	{
	public:
		struct Info
		{
			FT_DEVICE device;
			DWORD ID;
			std::string serialNumber;
			std::string description;
		};

		struct EEPROMData
		{
			FT_EEPROM_2232H data;
			char manufacturer[64];
			char manufacturerId[64];
			char description[64];
			char serialNumber[64];
		};

		struct Status
		{
			DWORD recvQueueLength;
			DWORD sendQueueLength;
		};

		enum class Direction
		{
			Send,
			Recv,
			Both
		};

		enum class BitMode : uint8_t
		{
			Reset = 0x00,
			AsyncBitbang = 0x01,
			MPSSE = 0x02,
			SyncBitbang = 0x04,
			MCUHost = 0x08,
			FastSerial = 0x10,
			CBUSBitbang = 0x20,
			SyncFifo = 0x40
		};

		enum class Channel
		{
			A,
			B
		};

		FTDIDevice(FT_HANDLE handle);

		~FTDIDevice();

		Channel GetChannel() const;

		Info GetInfo() const;

		Status GetStatus() const;

		BitMode GetBitMode() const;

		void SetBitMode(BitMode mode, uint8_t mask = 0xFF);

		void SetTimeouts(uint32_t readTimeoutMs, uint32_t writeTimeoutMs);

		void ClearQueues(Direction dirToClear);

		void Reset();

		size_t Read(void* buffer, size_t size);

		EEPROMData ReadEEPROM2232H();

		void WriteEEPROM2232H(EEPROMData& data);

		static std::string BitModeToString(BitMode mode);

	private:
		FT_HANDLE m_handle;
		FT_DEVICE m_type;
		Channel m_channel;
	};
}