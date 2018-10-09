module SerialPorts

export SerialPort, SerialException, setDTR, list_serialports,
       check_serial_access

using PyCall

const PySerial = PyCall.PyNULL()
const PySerialListPorts = PyCall.PyNULL()

struct SerialException <: Base.Exception end

struct SerialPort <: IO
    port::String
    baudrate::Int
    bytesize::Int
    parity::String
    stopbits::Int
    timeout
    xonxoff::Bool
    rtscts::Bool
    dsrdtr::Bool
    python_ptr::PyObject
end

function __init__()
    copy!(PySerial, pyimport_conda("serial", "pyserial"))
    copy!(PySerialListPorts, pyimport("serial.tools.list_ports"))
end

function SerialPort(port, baudrate::Real)
    py_ptr = PySerial[:Serial](port, baudrate)
    SerialPort(port,
               baudrate,
               py_ptr[:bytesize],
               py_ptr[:parity],
               py_ptr[:stopbits],
               py_ptr[:timeout],
               py_ptr[:xonxoff],
               py_ptr[:rtscts],
               py_ptr[:dsrdtr], py_ptr)
end

function Base.isopen(serialport::SerialPort)
    serialport.python_ptr[:isOpen]()
end

function Base.open(serialport::SerialPort)
    !isopen(serialport) && serialport.python_ptr[:open]()
    return serialport
end

function Base.close(serialport::SerialPort)
    serialport.python_ptr[:close]()
    return serialport
end

function Base.flush(ser::SerialPort)
    ser.python_ptr[:flush]()
end

function Base.isreadable(ser::SerialPort)
    ser.python_ptr[:readable]()
end

function Base.iswritable(ser::SerialPort)
    ser.python_ptr[:writable]()
end

function Base.write(serialport::SerialPort, data::UInt8)
    serialport.python_ptr[:write](Base.CodeUnits(String([data])))
end

function Base.write(serialport::SerialPort, data::String)
    serialport.python_ptr[:write](Base.CodeUnits(data))
end

function Base.read(ser::SerialPort, bytes::Integer)
    ser.python_ptr[:read](bytes)
end

function Base.bytesavailable(ser::SerialPort)
    ser.python_ptr[:inWaiting]()
end

function Base.readavailable(ser::SerialPort)
    read(ser, bytesavailable(ser))
end

function setDTR(ser::SerialPort, val)
    ser.python_ptr[:setDTR](val)
end

function _valid_linux_port(x)
    startswith(x, "ttyS") || startswith(x, "ttyUSB") || startswith(x, "ttyACM")
end

function _valid_darwin_port(x)
    startswith(x, "tty.") || startswith(x, "cu.")
end

"""
    SerialPorts.list_serialports

List available serialports on the system.
"""
function list_serialports()
    @static if Sys.isunix()
        ports = readdir("/dev/")
        f = Sys.isapple() ? _valid_darwin_port : _valid_linux_port
        filter!(f, ports)
        return [string("/dev/", port) for port in ports]
    end
    @static if Sys.iswindows()
        [i[1] for i in collect(PySerialListPorts[:comports]())]
    end
end

"""
Check if there are permission issues with accessing serial ports on the current
system.
"""
function check_serial_access()
    @static if Sys.isunix()
        current_user = ENV["USER"]
        in_dialout() || warn("""User $current_user is not in the 'dialout' group.
                                They can be added with:
                                'usermod -a -G dialout $current_user'""")
    end
end

"""
On Unix, test if the current user is in the 'dialout' group.
"""
function in_dialout()
    @static if Sys.isunix()
        "dialout" in split(readstring(`groups`))
    end
end

# Submodules

include("Arduino.jl")


end # module
