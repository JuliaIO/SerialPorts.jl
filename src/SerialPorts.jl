VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module SerialPorts

export SerialPort, serialport, SerialException, setDTR, list_serialports,
       in_dialout, check_serial_access

using Compat, Conda, PyCall

const PySerial = PyCall.PyNULL()

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
    try
        copy!(PySerial, pyimport("serial"))
    catch e
        if PyCall.conda
            info("Installing serial via the Conda package...")
            Conda.add("pyserial")
            copy!(PySerial, pyimport("serial"))
        else
            error("""Failed to pyimport("serial"): SerialPorts will not work until you have a functioning pyserial module.
                  For automated serial installation, try configuring SerialPorts to use the Conda Python distribution within Julia.  Relaunch Julia and run:
                        ENV["PYTHON"]=""
                        Pkg.build("Serial")
                        using PyPlot
                  pyimport exception was: """, e)
        end
    end
end


function Base.call(::Type{SerialPort}, port, baudrate)
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

function Base.write(serialport::SerialPort, data::UInt8)
    serialport.python_ptr[:write](data)
end

function Base.write(serialport::SerialPort, data::ASCIIString)
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

function _valid_darwin_port(x)
    startswith(x, "tty.") || startswith(x, "cu.")
end

"""
List available serialports on the system.
"""
function list_serialports()
    @unix_only begin
        ports = readdir("/dev/")
        f = @osx ? _valid_darwin_port : _valid_linux_port
        filter!(f, ports)
        return [string("/dev/", port) for port in ports]
    end
    @windows_only begin
        PySerial[:tools][:list_ports][:comports]()
    end
end

"""
Check if there are permission issues with accessing serial ports on the current
system.
"""
function check_serial_access()
    @linux_only begin
        current_user = ENV["USER"]
        in_dialout() || warn("""User $current_user is not in the 'dialout' group.
                                They can be added with:
                                'usermod -a -G dialout $current_user'""")
    end
end

"""
On Linux, test if the current user is in the 'dialout' group.
"""
@linux_only function in_dialout()
    "dialout" in split(readall(`groups`))
end

# Submodules

include("Arduino.jl")


end # module
