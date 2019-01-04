using Base.Sys
using PyCall

pip_success=true

try
    pip = run(`pip -V`)
    pip.exitcode == 0 && run(`pip install pyserial`)
catch err
    pip_success = false
end

pip_success && exit(0) # pip shell out worked, else install in deps

PACKAGES = ["pyserial"]

# Import pip
try
    @pyimport pip
catch
    # If it is not found, install it
    get_pip = joinpath(dirname(@__FILE__), "get-pip.py")
    download("https://bootstrap.pypa.io/get-pip.py", get_pip)
    run(`$(PyCall.python) $get_pip --user`)
end

@pyimport pip
args = UTF8String[]
if haskey(ENV, "http_proxy")
    push!(args, "--proxy")
    push!(args, ENV["http_proxy"])
end
push!(args, "install")
push!(args, "--user")
append!(args, PACKAGES)

pip.main(args)

