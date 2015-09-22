using BinDeps
@BinDeps.setup
pyserial = library_dependency("pyserial", aliases = ["serial","pyserial"])

using Conda
Conda.add("pyserial")
provides(Conda.Manager, "pyserial", pyserial)
