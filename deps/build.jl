using Compat

@linux_only begin
    lsb = split(readchomp(pipe(`lsb_release -ds`, stderr=DevNull)))
    if "Debian" in lsb || "Ubuntu" in lsb
        println(readall(`sudo apt-get install python-serial`))
    end
end
