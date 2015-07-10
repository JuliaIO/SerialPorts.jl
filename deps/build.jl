using BinDeps
using Compat

@BinDeps.setup

pyser = library_dependency("python-serial")

provides(AptGet, "python-serial", pyser)

@BinDeps.install @compat(Dict(:pyser => :serial))
