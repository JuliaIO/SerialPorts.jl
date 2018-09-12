using SerialPorts
using Test
using Compat

@show list_serialports()

SerialPorts.in_dialout()

SerialPorts.check_serial_access()
