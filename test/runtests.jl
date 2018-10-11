using SerialPorts
using Test

@show list_serialports()

SerialPorts.in_dialout()

SerialPorts.check_serial_access()
