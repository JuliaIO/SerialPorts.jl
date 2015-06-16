# SerialPorts

[![Build Status](https://travis-ci.org/sjkelly/SerialPorts.jl.svg?branch=master)](https://travis-ci.org/sjkelly/SerialPorts.jl)
[![Coverage Status](https://img.shields.io/coveralls/sjkelly/SerialPorts.jl.svg)](https://coveralls.io/r/sjkelly/SerialPorts.jl?branch=master)

SerialPorts.jl lets you work with devices over serial communication with Julia.
It is designed to mimic regular file IO as in the Base Julia library.

This package requires PySerial, which is used through PyCall. Overtime, one of
the long term objectives should be to rewrite this in Julia for better portability,
installation, and performance.

## Documentation

Roughly:

```
using Serial Ports
s = serialport("/dev/ttyACM1", 250000)
write(s, "G1 X1000 F10000\n")
# if this is connected to a 3D printer it's not my fault if it breaks.
```

on Julia 0.4 the preferred constructor is `SerialPort("/dev/ttyACM1", 250000)`.


julia> using SerialPorts

julia> s = SerialPorts.SerialPort("/dev/ttyACM1", 250000)
ERROR: `SerialPort` has no method matching SerialPort(::ASCIIString, ::Int64)

julia> s = SerialPorts.serialport("/dev/ttyACM1", 250000)
SerialPort("/dev/ttyACM1",250000,1,1,1,1,1,1,1,1,1,PyObject Serial<id=0x7f5033a91710, open=True>(port='/dev/ttyACM1', baudrate=250000, bytesize=8, parity='N', stopbits=1, timeout=None, xonxoff=False, rtscts=False, dsrdtr=False))

julia> write(s, "G1 X1000 F10000\n")


## License
Available under the [CC0 1.0 Universal Public Domain Dedication](http://en.wikipedia.org/wiki/Creative_Commons_license#Zero_.2F_Public_domain). See: [LICENSE.md](./LICENSE.md).

