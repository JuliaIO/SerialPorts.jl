# SerialPorts

[![Build Status](https://travis-ci.org/JuliaIO/SerialPorts.jl.svg?branch=master)](https://travis-ci.org/JuliaIO/SerialPorts.jl)

SerialPorts.jl lets you work with devices over serial communication with Julia.
It is designed to mimic regular file IO as in the Base Julia library.

This package requires PySerial, which is used through PyCall. Conda is used as
a fallback so cross-platform installation is simple.

Check out [LibSerialPort.jl](https://github.com/JuliaIO/LibSerialPort.jl) if you want to avoid the Python dependency.

## Quick Start

A `SerialPort` has a minimal API similar to `IOStream` in Julia.

A brief example:

```
using SerialPorts
s = SerialPort("/dev/ttyACM1", 250000)
write(s, "Hello World!\n")
close(s)
```

`open`, `close`, `read`, `write`, `bytesavailable`, `readavailable`, are all
defined for `SerialPort`.

In order to see the attached serial devices, use `list_serialports()`.

The `Arduino` submodule provides functionality for manipulating Arduinos over
serial. `SerialPorts.Arduino.reset(s::SerialPort)` will reset an Arduino.

## License
Available under the [MIT License](https://en.wikipedia.org/wiki/MIT_License). See: [LICENSE.md](./LICENSE.md).
