module Arduino

using SerialPorts

"""
Do the magic to reset and Arduino board.
"""
function reset(s::SerialPorts)
    setDTR(s, false)
    sleep(1)
    setDTR(s, true)
    nothing
end

end #module

