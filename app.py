import os
import sys
import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets
import pandas as pd
from sklearn.linear_model import LinearRegression
import qml_rc
from main.backend import RegressionManager

if __name__ == '__main__':
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Material'

    app = PyQt5.QtWidgets.QApplication(sys.argv)
    engine = PyQt5.QtQml.QQmlApplicationEngine()

    # backend = {
    #     'regressionBridge': RegressionBridge()
    # }
    # for name in backend:
    #     engine.rootContext().setContextProperty(name, backend[name])

    manager = RegressionManager()
    engine.rootContext().setContextProperty("r_manager", manager)
    #engine.load(PyQt5.QtCore.QUrl('qrc:/main/frontend/main.qml'))
    engine.load('./main/frontend/main.qml')

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())