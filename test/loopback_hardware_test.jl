using SerialPorts

@show list_serialports()

s = SerialPort("COM4",9600)
@show isopen(s)
open(s)

txt = """Hello World.
         The world is a big place.
         Yet it is sometimes small."""

@show isreadable(s)
@show iswritable(s)
@show write(s,8)
sleep(1)
@show bytesavailable(s) == 1
@show read(s,1) == "\b"
@show write(s, "Hello World")
sleep(1)
@show readavailable(s)
@show write(s, "Hello World")
sleep(1)
@show flush(s)
@show write(s, txt)
sleep(1)
@show readavailable(s)
@show write(s, Vector{UInt8}("Hello\n")) #22
@show readavailable(s)

close(s)
