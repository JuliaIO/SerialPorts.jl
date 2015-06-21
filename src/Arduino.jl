module Arduino

using SerialPorts

"""
Do the magic to reset and Arduino board.
"""
function reset(s::SerialPort)
    setDTR(s, false)
    sleep(1)
    setDTR(s, true)
    sleep(1)
    nothing
end

end #module

