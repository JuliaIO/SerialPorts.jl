using BinDeps
using Compat

@BinDeps.setup

pyser = library_dependency("python-serial")

provides(AptGet, @compat Dict(
    "python-serial" => pyser,
))
