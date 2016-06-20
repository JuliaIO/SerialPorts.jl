VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module SerialPorts

export SerialPort, SerialException, setDTR, list_serialports,
       check_serial_access

using Compat, PyCall, StringEncodings
VERSION < v"0.4-" && using Docile

const PySerial = PyCall.PyNULL()
const PySerialListPorts = PyCall.PyNULL()


type SerialException <: Base.Exception end

immutable SerialPort <: IO
    port::ASCIIString
    baudrate::Int
    bytesize::Int
    parity::ASCIIString
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

function serialport(port, baudrate)
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

if VERSION >= v"0.4-"
    function Base.call(::Type{SerialPort}, port, baudrate)
        serialport(port, baudrate)
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

function Base.write(serialport::SerialPort, data::@compat UInt8)
    serialport.python_ptr[:write](data)
end

function Base.write(serialport::SerialPort, data::ASCIIString)
    serialport.python_ptr[:write](data)
end

function Base.write(serialport::SerialPort, data::UTF8String)
       bytes = encode(data,"UTF-8")

       if bytes[1] == 87
         if sizeof(bytes) == 3 serialport.python_ptr[:write](bytes)  end
         if sizeof(bytes) == 4
              if bytes[3] == 195  bytes[4] = bytes[4] + 64 end
              three_bytes = [ bytes[1] , bytes[2] , bytes[4] ]
              serialport.python_ptr[:write](three_bytes)
         end
       
       elseif bytes[1] == 77
         if sizeof(bytes) == 3 || sizeof(bytes) == 4  serialport.python_ptr[:write](bytes)  end
         if sizeof(bytes) == 5
              if bytes[4] == 195  bytes[5] = bytes[5] + 64 end
              four_bytes = [ bytes[1] , bytes[2] , bytes[3] , bytes[5] ]
              serialport.python_ptr[:write](four_bytes)
         end
         
       elseif bytes[1] == 83
         if sizeof(bytes) == 4 serialport.python_ptr[:write](bytes)  end
         if sizeof(bytes) == 5
              four_bytes = [ bytes[1] , bytes[2] , bytes[3] , bytes[5] ]
              serialport.python_ptr[:write](four_bytes)
         end
       
       else
         serialport.python_ptr[:write](bytes)
       end

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

function _valid_darwin_port(x)
    startswith(x, "tty.") || startswith(x, "cu.")
end

@doc """
List available serialports on the system.
""" ->
function list_serialports()
    @unix_only begin
        ports = readdir("/dev/")
        f = @osx ? _valid_darwin_port : _valid_linux_port
        filter!(f, ports)
        return [string("/dev/", port) for port in ports]
    end
    @windows_only begin
        [i[1] for i in collect(PySerialListPorts[:comports]())]
    end
end

@doc """
Check if there are permission issues with accessing serial ports on the current
system.
""" ->
function check_serial_access()
    @linux_only begin
        current_user = ENV["USER"]
        in_dialout() || warn("""User $current_user is not in the 'dialout' group.
                                They can be added with:
                                'usermod -a -G dialout $current_user'""")
    end
end

@linux_only @doc """
On Linux, test if the current user is in the 'dialout' group.
""" ->
function in_dialout()
    "dialout" in split(readall(`groups`))
end

# Submodules

include("Arduino.jl")


end # module
