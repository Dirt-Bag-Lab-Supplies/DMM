#include "Utility.hpp"

#include <stdexcept>

namespace DBLS
{
	namespace Utility
	{
		void ThrowIfFailed(FT_STATUS status, std::string msg)
		{
			if (status != FT_OK)
			{
				std::string errorStr = "FTDI call failed (status="
					+ std::to_string(status) + ")";
				if (!msg.empty())
				{
					errorStr += ". " + msg;
				}

				throw std::runtime_error(errorStr.c_str());
			}
		}
	}
}