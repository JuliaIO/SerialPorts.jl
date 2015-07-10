module SerialPorts

export SerialPort, serialport, SerialException, setDTR, list_serialports

using PyCall

@pyimport serial as PySerial

type SerialException <: Base.Exception end

immutable SerialPort
    port
    baudrate
    bytesize
    parity
    stopbits
    timeout
    xonxoff
    rtscts
    write_timeout
    dsrdtr
    inter_char_timeout
    python_ptr
end

function serialport(port, baudrate)
    py_ptr = PySerial.Serial(port, baudrate)
    SerialPort(port, baudrate, 1, 1, 1, 1, 1, 1, 1, 1, 1, py_ptr)
end

if VERSION >= v"0.4-"
    function Base.call(::Type{SerialPort}, port, baudrate)
        py_ptr = PySerial.Serial(port, baudrate)
        SerialPort(port, baudrate, 1, 1, 1, 1, 1, 1, 1, 1, 1, py_ptr)
    end
end

function Base.open(serialport::SerialPort)
    serialport.python_ptr[:open]()
    return serialport
end

function Base.close(serialport::SerialPort)
    serialport.python_ptr[:close]()
    return serialport
end

function Base.isreadable(ser::SerialPort)
    ser.python_ptr[:isreadable]()
end

function Base.iswritable(ser::SerialPort)
    ser.python_ptr[:iswritable]()
end

function Base.write(serialport::SerialPort, data)
    serialport.python_ptr[:write](data)
end

function Base.read(ser::SerialPort, bytes::Integer)
    ser.python_ptr[:read](bytes)
end

function Base.nb_available(ser::SerialPort)
    ser.python_ptr[:inWaiting]()
end

function Base.readavailable(ser::SerialPort)
    read(ser, nb_available(ser))
end

function setDTR(ser::SerialPort, val)
    ser.python_ptr[:setDTR](val)
end

function _valid_linux_port(x)
    startswith(x, "ttyS") || startswith(x, "ttyUSB") || startswith(x, "ttyACM")
end

function list_serialports()
    @linux_only begin
        ports = readdir("/dev/")
        filter!(_valid_linux_port, ports)
        return [string("/dev/", port) for port in ports]
    end
    @osx_only begin
        #TODO
    end
    @windows_only begin
        #TODO
    end
end

# Submodules

include("Arduino.jl")


end # module
