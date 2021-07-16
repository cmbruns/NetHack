import ctypes
from ctypes import c_char_p, c_int, POINTER
import os
import sys

# Things to try:
#  windll vs cdll
#  debug vs release
#  MT vs MD

kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
user32 = ctypes.WinDLL("user32", use_last_error=True)
msvcrt = ctypes.WinDLL("msvcrt", use_last_error=True)

# Load the nethack shared library DLL
os.add_dll_directory(os.path.dirname(__file__))
nethack_dll = ctypes.windll.LoadLibrary(
    "NethackDLL.dll"
    # "NethackVRDll.dll"
)
print(nethack_dll)

# Expose the nethack main(...) function
print(nethack_dll.main)
nethack_dll.main.restype = c_int
nethack_dll.main.argtypes = c_int, POINTER(c_char_p)  # argc, argv

# Run the main(...) function
print(sys.argv)
argc = len(sys.argv)
argv = [s.encode() for s in sys.argv]
argv = (c_char_p * argc)(*argv)
print(argv)

# Note I can only see the tty output by setting pycharm "Emulate terminal in output console"
result = nethack_dll.main(argc, argv)
print(result)
