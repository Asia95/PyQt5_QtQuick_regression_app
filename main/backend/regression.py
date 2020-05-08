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
        d = {'True': True, 'False': False}
        self._df.logarithm = self._df.logarithm.map(d)
        self._df.sqr = self._df.sqr.map(d)

    def check_regression_settings(self, dependent_variables, independent_variables):
        log_var = []
        sqr_var = []

        if dependent_variables.empty:
            return 'Please specify dependent variable'
        elif len(dependent_variables.index) > 1:
            return 'Only one variable can be dependent'
        if independent_variables.empty:
            return 'Please specify independent variable'

        if not independent_variables[independent_variables.logarithm].empty:
            log_var = independent_variables[independent_variables.logarithm]['Variables'].values

        if not independent_variables[independent_variables.sqr].empty:
            sqr_var = independent_variables[independent_variables.sqr]['Variables'].values

        if any(x in log_var for x in sqr_var):
            return 'Variables cannot have two effects applied'

    @PyQt5.QtCore.pyqtSlot()
    def run_regression(self):
        dependent_variables = self._df[self._df['role'] == 'Dependent']
        independent_variables = self._df[self._df['role'] == 'Independent']

        msg = self.check_regression_settings(dependent_variables, independent_variables)

        if not msg:
            data_for_regression = self._data.copy()
            log_var = []
            sqr_var = []

            if not independent_variables[independent_variables.logarithm].empty:
                log_var = independent_variables[independent_variables.logarithm]['Variables'].values
                for c in log_var:
                    data_for_regression = data_for_regression[data_for_regression[c] > 0]
                data_for_regression[log_var] = np.log(data_for_regression[log_var])

            if not independent_variables[independent_variables.sqr].empty:
                sqr_var = independent_variables[independent_variables.sqr]['Variables'].values
                data_for_regression[sqr_var] = np.square(data_for_regression[sqr_var])

            self._X = data_for_regression[independent_variables['Variables'].values]
            for x in log_var:
                self._X.rename(columns={x: f'log({x})'}, inplace=True)
            for x in sqr_var:
                self._X.rename(columns={x: f'square({x})'}, inplace=True)
            self._X = sm.add_constant(self._X)
            self._y = data_for_regression[dependent_variables['Variables'].values[0]]

            self._model = sm.OLS(self._y, self._X).fit()
            results_as_html = self._model.summary().as_text()
            self.summary = results_as_html
            data_for_regression = None

    @PyQt5.QtCore.pyqtSlot('QString')
    def load_data(self, fp):
        self.file_path = fp
        self._data = pd.read_csv(self._file_path)
        #self.columns = list(self._data.columns.values)
        #self._X = pd.DataFrame(self._data['x'])
        #self._X = sm.add_constant(self._X)
        #self._y = pd.DataFrame(self._data['y'])
        #model = LinearRegression().fit(X, y)
        #self._model = sm.OLS(self._y, self._X).fit()
        #results_as_html = self._model.summary().as_text()
        #results_as_html = results_as_html.replace("<table class=\"simpletable\">", "<table border = '1'>")
        #print(results_as_html)
        #self.summary = results_as_html
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

