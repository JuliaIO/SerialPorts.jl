using SerialPorts

function _end_of_command(ser)
    for i in 0:2
        write(stdout, 0xff)
        write(ser, 0xff)
    end
end

function _execute_command(ser, cmd)
    println(cmd)
    write(ser, cmd)
    _end_of_command(ser)
end

function main()
    ser = SerialPort("COM4", 9600)
    _execute_command(ser, "page 0")
    sleep(2)
    _execute_command(ser, "page 1")
    sleep(2)
    _execute_command(ser, "t0.txt=\"Hello\"")
    close(ser)
end


main()
