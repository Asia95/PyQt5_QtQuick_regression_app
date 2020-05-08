import os
import sys
import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import qml_rc
from main.backend import RegressionManager, DataFrameModel


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

    # backend = {
    #     'regressionBridge': RegressionBridge()
    # }
    # for name in backend:
    #     engine.rootContext().setContextProperty(name, backend[name])

    df = pd.DataFrame()
    model = DataFrameModel(df)
    engine.rootContext().setContextProperty("table_model", model)
    manager = RegressionManager()
    engine.rootContext().setContextProperty("r_manager", manager)
    # engine.load(PyQt5.QtCore.QUrl('qrc:/main/frontend/main.qml'))
    engine.load('./main/frontend/main.qml')

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
