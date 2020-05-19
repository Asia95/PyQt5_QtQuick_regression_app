import os
import sys
import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import qml_rc
from main.backend import ForecastModel, ForecastManager, RegressionManager, DataFrameModel, DisplayBridge, \
    run_volsurface, run_aswzscore, run_optionstrategy
from matplotlib_backend_qtquick.backend_qtquickagg import (
    FigureCanvasQtQuickAgg)

def qt_message_handler(mode, context, message):
    if mode == PyQt5.QtCore.QtInfoMsg:
        mode = 'Info'
    elif mode == PyQt5.QtCore.QtWarningMsg:
        mode = 'Warning'
    elif mode == PyQt5.QtCore.QtCriticalMsg:
        mode = 'critical'
    elif mode == PyQt5.QtCore.QtFatalMsg:
        mode = 'fatal'
    else:
        mode = 'Debug'
    print("%s: %s (%s:%d, %s)" % (mode, message, context.file, context.line, context.file))


if __name__ == '__main__':
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Material'

    PyQt5.QtCore.qInstallMessageHandler(qt_message_handler)
    app = PyQt5.QtWidgets.QApplication(sys.argv)
    engine = PyQt5.QtQml.QQmlApplicationEngine()

    PyQt5.QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Backend", 1, 0, "FigureCanvas")

    properties = {
        "reg_table_model": DataFrameModel(),
        "r_manager": RegressionManager(),
        "forecast_table_model": ForecastModel(),
        "f_manager": ForecastManager(),
        "options_volatility_heatmap": DisplayBridge(),
        "options_volatility_surface": DisplayBridge(),
        "options_strategy": DisplayBridge()
    }
    for name in properties:
        engine.rootContext().setContextProperty(name, properties[name])

    # engine.load(PyQt5.QtCore.QUrl('qrc:/main/frontend/main.qml'))
    engine.load('./main/frontend/main.qml')

    win = engine.rootObjects()[0]
    properties["options_volatility_heatmap"].updateWithCanvas(
        win.findChild(PyQt5.QtCore.QObject, "volatility_heatmap_figure"), None, run_aswzscore)
    properties["options_strategy"].updateWithCanvas(
        win.findChild(PyQt5.QtCore.QObject, "options_strategy_figure"), None, run_optionstrategy)
    properties["options_volatility_surface"].updateWithCanvas(
        win.findChild(PyQt5.QtCore.QObject, "volatility_surface_figure"), '3d', run_volsurface)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
