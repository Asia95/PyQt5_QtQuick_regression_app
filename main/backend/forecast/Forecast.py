import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.sandbox.regression.predstd import wls_prediction_std
import PyQt5.QtCore
from PyQt5.QtCore import QAbstractTableModel, Qt


class ForecastManager(PyQt5.QtCore.QObject):
    filePathChanged = PyQt5.QtCore.pyqtSignal(str)
    summaryChanged = PyQt5.QtCore.pyqtSignal(QAbstractTableModel)
    sesonalityMonthChanged = PyQt5.QtCore.pyqtSignal(bool)
    sesonalityYearChanged = PyQt5.QtCore.pyqtSignal(bool)

    MONTHS = ['February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November',
              'December']

    def __init__(self, parent=None):
        super(ForecastManager, self).__init__(parent)
        self._file_path = ''
        self._data = None
        self._summary = None
        self._model = None
        self._X = None
        self._y = None
        self._columns = None
        self._df = None
        self._sesonality_month = False
        self._sesonality_year = False

    @PyQt5.QtCore.pyqtProperty(int, notify=sesonalityMonthChanged)
    def sesonality_month(self):
        return self._sesonality_month

    @sesonality_month.setter
    def sesonality_month(self, c):
        # 2 for checked, 0 for unchecked
        self._sesonality_month = True if c == 2 else False
        self.sesonalityMonthChanged.emit(self._sesonality_year)

    @PyQt5.QtCore.pyqtProperty(int, notify=sesonalityYearChanged)
    def sesonality_year(self):
        return self._sesonality_year

    @sesonality_year.setter
    def sesonality_year(self, c):
        # 2 for checked, 0 for unchecked
        self._sesonality_year = True if c == 2 else False
        self.sesonalityYearChanged.emit(self._sesonality_year)

    @PyQt5.QtCore.pyqtProperty(float, notify=filePathChanged)
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, f):
        if self._file_path != f:
            self._file_path = f
            self.filePathChanged.emit(f)

    @PyQt5.QtCore.pyqtProperty(QAbstractTableModel, notify=summaryChanged)
    def summary(self):
        return self._summary

    @summary.setter
    def summary(self, s):
        self._summary = s
        self.summaryChanged.emit(s)

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

    def add_monthly_sesonality(self, data_for_regression):
        for i, m in enumerate(self.MONTHS, start=2):
            data_for_regression[m] = 0
            data_for_regression.loc[data_for_regression.index.month == i, m] = 1
        return data_for_regression

    def add_yearly_sesonality(self, data_for_regression):
        start_year = data_for_regression.index.min().year
        end_year = data_for_regression.index.max().year
        years = []
        for y in range(start_year, end_year+1):
            data_for_regression[y] = 0
            data_for_regression.loc[data_for_regression.index.year == y, y] = 1
            years.append(y)
        return years, data_for_regression

    @PyQt5.QtCore.pyqtSlot()
    def run_regression(self):
        dependent_variables = self._df[self._df['role'] == 'Dependent']
        independent_variables = self._df[self._df['role'] == 'Independent']

        msg = self.check_regression_settings(dependent_variables, independent_variables)

        if not msg:
            data_for_regression = self._data.copy()
            data_for_regression = data_for_regression.dropna()
            log_var = []
            sqr_var = []
            independent_variables_columns = []

            if self._sesonality_month:
                data_for_regression = self.add_monthly_sesonality(data_for_regression)
                independent_variables_columns.extend(self.MONTHS)
            if self._sesonality_year:
                years, data_for_regression = self.add_yearly_sesonality(data_for_regression)
                independent_variables_columns.extend(years)

            for i, row in independent_variables[~independent_variables.interchange.eq('')].iterrows():
                data_for_regression[row.Variables+'*'+row.interchange] = \
                    data_for_regression[row.Variables]*data_for_regression[row.interchange]

            if not independent_variables[independent_variables.logarithm].empty:
                log_var = independent_variables[independent_variables.logarithm]['Variables'].values
                for c in log_var:
                    data_for_regression = data_for_regression[data_for_regression[c] > 0]
                data_for_regression[log_var] = np.log(data_for_regression[log_var])

            if not independent_variables[independent_variables.sqr].empty:
                sqr_var = independent_variables[independent_variables.sqr]['Variables'].values
                data_for_regression[sqr_var] = np.square(data_for_regression[sqr_var])

            independent_variables_columns.extend(independent_variables['Variables'].tolist())
            self._X = data_for_regression[independent_variables_columns]
            print(self._X.head(10))
            for x in log_var:
                self._X.rename(columns={x: f'log({x})'}, inplace=True)
            for x in sqr_var:
                self._X.rename(columns={x: f'square({x})'}, inplace=True)
            self._X = sm.add_constant(self._X)
            self._y = data_for_regression[dependent_variables['Variables'].values[0]]

            self._model = sm.OLS(self._y, self._X).fit()
            #self.summary = self._model.summary().tables[1].as_text()
            self.summary = pandasModel(self._model.summary2().tables[1].round(4))
            data_for_regression = None

    @PyQt5.QtCore.pyqtSlot('QString')
    def load_data(self, fp):
        self.file_path = fp
        self._data = pd.read_excel(self._file_path, index_col=0)

class pandasModel(QAbstractTableModel):

    def __init__(self, data):
        QAbstractTableModel.__init__(self)
        self.beginResetModel()
        self._data = data
        self.endResetModel()

    def setDataFrame(self, dataframe):
        self.beginResetModel()
        self._data = dataframe.copy()
        self.endResetModel()

    def dataFrame(self):
        return self._data

    dataFrame = PyQt5.QtCore.pyqtProperty(pd.DataFrame, fget=dataFrame, fset=setDataFrame)

    def rowCount(self, parent=None):
        return self._data.shape[0]

    def columnCount(self, parnet=None):
        return self._data.shape[1]

    def data(self, index, role=Qt.DisplayRole):
        if index.isValid():
            if role == Qt.DisplayRole:
                return str(self._data.iloc[index.row(), index.column()])
        return None

    @PyQt5.QtCore.pyqtSlot(int, Qt.Orientation, result=str)
    def headerData(self, col, orientation, role: int = Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                return self._data.columns[col]
            else:
                if len(self._data.index) > col:
                    return str(self._data.index[col])
        return None
