using SerialPorts
using Base.Test

@show list_serialports()

@linux_only SerialPorts.in_dialout()
SerialPorts.check_serial_access()
