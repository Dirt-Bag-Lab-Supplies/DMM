#include "Commands.hpp"

#include "FTDIInterface.hpp"
#include "FTDIDevice.hpp"

#include <thread>
#include <chrono>
#include <fstream>

namespace DBLS
{
	namespace Commands
	{
		bool CommandEnumerate(const cxxopts::ParseResult& args)
		{
			bool success = true;

			try
			{
				FTDIInterface ftdi;

				auto devices = ftdi.EnumerateDevices();
				std::cout << "Detected " << devices.size() << ((devices.size() == 1) ? " device" : " devices") << std::endl;
				for (const auto& device : devices)
				{
					std::cout << FTDIInterface::ToString(device, 1) << '\n' << std::endl;
				}
			}
			catch (const std::exception& e)
			{
				success = false;

				std::cerr << e.what() << std::endl;
			}

			return success;
		}

		bool CommandDeviceInfo(const cxxopts::ParseResult& args)
		{
			bool success = false;

			try
			{
				auto deviceName = args["device"].as<std::string>();

				FTDIInterface ftdi;
				auto device = ftdi.OpenDeviceFromSerialNumber(deviceName);

				auto info = device.GetInfo();
				auto channel = device.GetChannel();
				std::cout
					<< "Device Type: " << FTDIInterface::DeviceToString(info.device) << '\n'
					<< "Serial Number: " << info.serialNumber << '\n'
					<< "Description: " << info.description << '\n'
					<< "Channel: " << (channel == FTDIDevice::Channel::A ? "A" : "B")
					<< std::endl;

				auto status = device.GetStatus();
				std::cout
					<< "Current Receive Queue Length: " << status.recvQueueLength << '\n'
					<< "Current Send Queue Length: " << status.sendQueueLength << std::endl;
				
				auto bitMode = device.GetBitMode();
				std::cout
					<< "Bit mode: " << FTDIDevice::BitModeToString(bitMode) << std::endl;

				auto eeprom = device.ReadEEPROM2232H();
				if (channel == FTDIDevice::Channel::A)
				{
					std::cout
						<< "FIFO Mode: " << (eeprom.data.AIsFifo ? "Enabled" : "Disabled") << '\n'
						<< "FIFO CPU Mode: " << (eeprom.data.AIsFifoTar ? "Enabled" : "Disabled") << '\n'
						<< "Fast Serial Mode: " << (eeprom.data.AIsFastSer ? "Enabled" : "Disabled")
						<< std::endl;
				}
				else
				{
					std::cout
						<< "FIFO Mode: " << (eeprom.data.BIsFifo ? "Enabled" : "Disabled") << '\n'
						<< "FIFO CPU Mode: " << (eeprom.data.BIsFifoTar ? "Enabled" : "Disabled") << '\n'
						<< "Fast Serial Mode: " << (eeprom.data.BIsFastSer ? "Enabled" : "Disabled")
						<< std::endl;
				}

				success = true;
			}
			catch (const std::exception& e)
			{
				std::cerr << "[CommandDeviceInfo] Exception: " << e.what() << std::endl;
			}

			return success;
		}

		bool CommandRead(const cxxopts::ParseResult& args)
		{
			bool success = false;

			try
			{
				auto deviceName = args["device"].as<std::string>();

				FTDIInterface ftdi;
				auto device = ftdi.OpenDeviceFromSerialNumber(deviceName);

				auto info = device.GetInfo();
				std::cout
					<< "Device Type: " << FTDIInterface::DeviceToString(info.device) << '\n'
					<< "Serial Number: " << info.serialNumber << '\n'
					<< "Description: " << info.description << '\n' << std::endl;

				if (args.count("s"))
				{
					std::cout << "Flag set for SyncFifo mode" << std::endl;

					std::cout << "Resetting FTDI device mode" << std::endl;
					device.SetBitMode(FTDIDevice::BitMode::Reset);
					std::this_thread::sleep_for(std::chrono::milliseconds(10));

					std::cout << "Setting FTDI device mode to SyncFifo" << std::endl;
					device.SetBitMode(FTDIDevice::BitMode::SyncFifo);
				}

				std::cout << "Setting device timeouts" << std::endl;
				device.SetTimeouts(1000, 1000);

				std::vector<char> buffer(1024);
				size_t totalBytesRead = 0;
				size_t bytesToRead = args["size"].as<int>();

				std::fstream file{ args["file"].as<std::string>(),
					std::ios_base::out | std::ios_base::binary };

				while (bytesToRead > 0)
				{
					auto chunkSize = min(bytesToRead, buffer.size());

					std::cout << "Reading " << chunkSize << " bytes from device" << std::endl;
					auto actualBytesRead = device.Read(reinterpret_cast<void*>(buffer.data()), chunkSize);
					file.write(buffer.data(), actualBytesRead);
					std::cout << "Read " << actualBytesRead << " bytes" << std::endl;
					
					bytesToRead -= actualBytesRead;
					std::cout << bytesToRead << " bytes remaining\n" << std::endl;
				}

				success = true;
			}
			catch (const std::exception& e)
			{
				std::cerr << "[CommandDeviceInfo] Exception: " << e.what() << std::endl;
			}

			return success;
		}

		bool CommandSetFifoMode(const cxxopts::ParseResult& args)
		{
			bool success = false;

			try
			{
				auto deviceName = args["device"].as<std::string>();

				FTDIInterface ftdi;
				auto device = ftdi.OpenDeviceFromSerialNumber(deviceName);

				bool enable = false;
				if (args.count("enable"))
				{
					enable = true;
				}
				else if (args.count("disable"))
				{
					enable = false;
				}
				else
				{
					throw std::runtime_error("SetFifoMode: --enable or --disable must be set");
				}

				std::cout << (enable
					? "Enabling FIFO mode in EEPROM"
					: "Disabling FIFO mode in EEPROM")
					<< std::endl;

				auto eeprom = device.ReadEEPROM2232H();

				auto channel = device.GetChannel();
				if (channel == FTDIDevice::Channel::A)
				{
					bool currentState = eeprom.data.AIsFifo;
					if (currentState == enable)
					{
						std::cout << "FIFO mode already "
							<< (enable ? "enabled" : "disabled")
							<< ", not writing EEPROM";
					}
					else
					{
						eeprom.data.AIsFifo = (enable ? 0x01 : 0);
						device.WriteEEPROM2232H(eeprom);
					}
				}
				else
				{
					bool currentState = eeprom.data.BIsFifo;
					if (currentState == enable)
					{
						std::cout << "FIFO mode already "
							<< (enable ? "enabled" : "disabled")
							<< ", not writing EEPROM";
					}
					else
					{
						eeprom.data.BIsFifo = (enable ? 0x01 : 0);
						device.WriteEEPROM2232H(eeprom);
					}
				}

				success = true;
			}
			catch (const std::exception& e)
			{
				std::cerr << "[CommandDeviceInfo] Exception: " << e.what() << std::endl;
			}

			return success;
		}
	}
}