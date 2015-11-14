#! /usr/bin/env julia

using SerialPorts

function terminal(args)

    # arg parsing
    if length(args) < 4
        println("usage: listener.jl --port <port> --baud <baud>")
        exit(0)
    else
        p_i = findfirst(args, "--port")
        port = args[p_i+1]
        b_i = findfirst(args, "--baud")
        baud = parse(Int,args[b_i+1])
    end

    ser = SerialPort(port, baud)

    # setup handler at exit to close the serial port
    atexit_handler() = (println("exiting..."); close(ser))
    atexit(atexit_handler)

    println("Listening to $port @ $(baud)baud...")
    while true
        print(readavailable(ser))
    end
end

terminal(ARGS)
