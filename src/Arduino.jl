module Arduino

using SerialPorts

"""
    SerialPorts.Arduino.reset

Reset an Arduino board.
"""
function Base.reset(s::SerialPort)
    setDTR(s, false)
    sleep(1)
    setDTR(s, true)
    sleep(1)
    nothing
end

end #module
