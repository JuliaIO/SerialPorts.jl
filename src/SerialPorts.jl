module SerialPorts

using PyCall

@pyimport serial

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

function Base.call(::Type{SerialPort}, port, baudrate)
    py_ptr = serial.Serial(port, baudrate)
    SerialPort(port, baudrate, 1, 1, 1, 1, 1, 1, 1, 1, 1, py_ptr)
end

function Base.open(serialport::SerialPort)
    serialport.python_ptr[:open]()
    return serialport
end

function Base.write(serialport::SerialPort, str)
    serialport.python_ptr[:write](str)
end

end # module
