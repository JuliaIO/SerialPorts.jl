# SerialPorts

[![Build Status](https://travis-ci.org/JuliaIO/SerialPorts.jl.svg?branch=master)](https://travis-ci.org/JuliaIO/SerialPorts.jl)

[![SerialPorts](http://pkg.julialang.org/badges/SerialPorts_0.7.svg)](http://pkg.julialang.org/?pkg=SerialPorts)

SerialPorts.jl lets you work with devices over serial communication with Julia.
It is designed to mimic regular file IO as in the Base Julia library.

This package requires PySerial, which is used through PyCall. Conda is used as
a fallback so cross-platform installation is simple. Overtime, one of
the long term objectives should be to rewrite this in Julia for better portability,
installation, and performance.

## Documentation

A `SerialPort` can be treated like any other IO stream in Julia.

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