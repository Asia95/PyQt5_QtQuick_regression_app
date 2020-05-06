import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.sandbox.regression.predstd import wls_prediction_std
import PyQt5.QtCore

class RegressionManager(PyQt5.QtCore.QObject):
    coeffChanged = PyQt5.QtCore.pyqtSignal(float)
    filePathChanged = PyQt5.QtCore.pyqtSignal(str)
    summaryChanged = PyQt5.QtCore.pyqtSignal(str)
    dfChanged = PyQt5.QtCore.pyqtSignal(str)

    def __init__(self, parent=None):
        super(RegressionManager, self).__init__(parent)
        self._file_path = ''
        self._coeff = 0.0
        self._data = None
        self._summary = None
        self._model = None
        self._X = None
        self._y = None
        self._columns = None
        self._df = None

    @PyQt5.QtCore.pyqtProperty(float, notify=coeffChanged)
    def coeff(self):
        return self._coeff

    @coeff.setter
    def coeff(self, c):
        if self._coeff != c:
            self._coeff = c
            self.coeffChanged.emit(c)

    @PyQt5.QtCore.pyqtProperty(float, notify=filePathChanged)
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, f):
        if self._file_path != f:
            self._file_path = f
            self.filePathChanged.emit(f)

    @PyQt5.QtCore.pyqtProperty(str, notify=summaryChanged)
    def summary(self):
        return self._summary

    @summary.setter
    def summary(self, s):
        if self._summary != s:
            self._summary = s
            self.summaryChanged.emit(s)

    @PyQt5.QtCore.pyqtProperty(str, notify=dfChanged)
    def df(self):
        return self._df

    @df.setter
    def df(self, c):
        if self._df != c:
            self._df = c
            self.dfChanged.emit(c)

    @PyQt5.QtCore.pyqtSlot('QString')
    def get_df(self, df_csv):
        self._df = pd.DataFrame([x.split(',') for x in df_csv.split('\r\n')[1:]],
                           columns=[x for x in df_csv.split('\r\n')[0].split(',')])
        self._df.set_index('id', inplace=True)
        self._df = self._df[:-1]
        print(self._df.to_string())

    @PyQt5.QtCore.pyqtSlot('QString')
    def load_data(self, fp):
        self.file_path = fp
        self._data = pd.read_csv(self._file_path)
        #self.columns = list(self._data.columns.values)
        self._X = pd.DataFrame(self._data['x'])
        self._X = sm.add_constant(self._X)
        self._y = pd.DataFrame(self._data['y'])
        #model = LinearRegression().fit(X, y)
        self._model = sm.OLS(self._y, self._X).fit()
        results_as_html = self._model.summary().tables[1].as_html()
        self.summary = results_as_html
        #print(self._summary)
        #self.summary = self._model.summary()
        #self.coeff = model.intercept_[0]

    @PyQt5.QtCore.pyqtSlot()
    def predictions_plot(self):
        prstd, iv_l, iv_u = wls_prediction_std(self._model)

        fig, ax = plt.subplots(figsize=(8, 6))

        ax.plot(self._X, self._y, 'o', label="data")
        ax.plot(self._X, self._y, 'b-', label="True")
        ax.plot(self._X, self._model.fittedvalues, 'r--.', label="OLS")
        ax.plot(self._X, iv_u, 'r--')
        ax.plot(self._X, iv_l, 'r--')
        ax.legend(loc='best')
        fig.show()

