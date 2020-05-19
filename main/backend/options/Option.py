import sys
from matplotlib_backend_qtquick.qt_compat import QtQml, QtCore

class DisplayBridge(QtCore.QObject):
    heightChanged = QtCore.Signal(float)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.figure = None
        self._height = 0.0

    def updateWithCanvas(self, canvas, projection, plot_run):
        self.figure = canvas.figure
        self.axes = self.figure.add_subplot(111, projection=projection)
        self.figure.tight_layout()
        self.axes.grid(True)
        plot_run(self.axes, self.figure)
        canvas.draw_idle()

        # self.figure.canvas.mpl_connect('scroll_event', self.on_scroll)

    def getHeight(self):
        return self._height

    def setHeight(self, height):
        self._height = height
        self.heightChanged.emit(self._height)

    height = QtCore.Property(float, getHeight, setHeight,
                                  notify=heightChanged)

    # def on_scroll(self, event):
    #     self.height = event.ydata
