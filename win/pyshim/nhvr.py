import ctypes
from ctypes import c_char_p, c_int, POINTER
import os
import sys

from PySide6 import QtCore, QtWidgets


class NethackWorker(QtCore.QObject):
    """
    Nethack game process that runs in it's own thread.
    """
    finished = QtCore.Signal()

    def __init__(self, thread: QtCore.QThread):
        super().__init__()
        self.moveToThread(thread)
        thread.started.connect(self.run)
        self.finished.connect(thread.quit)
        self.finished.connect(self.deleteLater)

    def run(self):
        # Load the nethack shared library DLL
        os.add_dll_directory(os.path.dirname(__file__))
        nethack_dll = ctypes.windll.LoadLibrary(
            "NethackDLL.dll"
        )
        print(nethack_dll)

        # Expose the nethack main(...) function
        print(nethack_dll.main)
        nethack_dll.main.restype = c_int
        nethack_dll.main.argtypes = c_int, POINTER(c_char_p)  # argc, argv

        # Prepare argc and argv arguments for the nethack main() function
        argc = len(sys.argv)
        argv = [s.encode() for s in sys.argv]
        argv = (c_char_p * argc)(*argv)

        # Run the main(...) function
        # Note I can only see the tty output by setting pycharm "Emulate terminal in output console"
        result = nethack_dll.main(argc, argv)
        print(result)
        self.finished.emit()


# sketch in Qt event loop
# TODO: shut down nethack gracefully on quit
class NethackVrApp(QtWidgets.QApplication):
    def __init__(self):
        super().__init__(sys.argv)
        self.nethack_thread = QtCore.QThread()
        self.nethack_worker = NethackWorker(self.nethack_thread)

    def run(self):
        self.run_nethack()
        label = QtWidgets.QLabel("Hello World")
        label.show()
        result = self.exec()
        sys.exit(result)

    def run_nethack(self):
        self.nethack_thread.start()


if __name__ == "__main__":
    app = NethackVrApp()
    app.run()
