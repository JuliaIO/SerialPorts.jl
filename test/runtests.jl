using SerialPorts
using Base.Test
using Compat

@show list_serialports()

@static if is_linux()
    SerialPorts.in_dialout()
end
SerialPorts.check_serial_access()
