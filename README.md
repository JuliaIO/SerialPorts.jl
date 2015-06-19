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
using SerialPorts
s = serialport("/dev/ttyACM1", 250000)
write(s, "G1 X1000 F10000\n")
# if this is connected to a 3D printer it's not my fault if it breaks.
```

on Julia 0.4 the preferred constructor is `SerialPort("/dev/ttyACM1", 250000)`.


## License
Available under the [CC0 1.0 Universal Public Domain Dedication](http://en.wikipedia.org/wiki/Creative_Commons_license#Zero_.2F_Public_domain). See: [LICENSE.md](./LICENSE.md).

