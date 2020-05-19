from PyQt5 import QtCore, QtGui, QtQml
import numpy as np
import pandas as pd

class ForecastModel(QtCore.QAbstractTableModel):
    DtypeRole = QtCore.Qt.UserRole + 1000
    ValueRole = QtCore.Qt.UserRole + 1001

    def __init__(self, df=pd.DataFrame(), parent=None):
        super(ForecastModel, self).__init__(parent)
        self._dataframe = pd.DataFrame({'': ['']})

    def setDataFrame(self, dataframe):
        self.beginResetModel()
        self._dataframe = dataframe.copy()
        self.endResetModel()

    def dataFrame(self):
        return self._dataframe

    dataFrame = QtCore.pyqtProperty(pd.DataFrame, fget=dataFrame, fset=setDataFrame)

    @QtCore.pyqtSlot(int, QtCore.Qt.Orientation, result=str)
    def headerData(self, section: int, orientation: QtCore.Qt.Orientation, role: int = QtCore.Qt.DisplayRole):
        if role == QtCore.Qt.DisplayRole:
            df_first_column = self._dataframe.iloc[:, [0]]
            if orientation == QtCore.Qt.Horizontal:
                return df_first_column.columns[section]
            else:
                return str(self._dataframe.index[section])
        return QtCore.QVariant()

    @QtCore.pyqtSlot(int)
    def logarithm_check(self, section: int, role: int = QtCore.Qt.DisplayRole):
        if role == QtCore.Qt.DisplayRole:
            self.beginResetModel()
            self._dataframe.at[section, 'logarithm'] = ~self._dataframe.at[section, 'logarithm']
            self.endResetModel()

    @QtCore.pyqtSlot(int)
    def sqr_check(self, section: int, role: int = QtCore.Qt.DisplayRole):
        if role == QtCore.Qt.DisplayRole:
            self.beginResetModel()
            self._dataframe.at[section, 'sqr'] = ~self._dataframe.at[section, 'sqr']
            self.endResetModel()

    @QtCore.pyqtSlot(int, str)
    def variable_check(self, section: int, value: str, role: int = QtCore.Qt.DisplayRole):
        self.beginResetModel()
        self._dataframe.at[section, 'role'] = value
        self.endResetModel()

    @QtCore.pyqtSlot(int, str)
    def variable_interchange_check(self, section: int, value: str, role: int = QtCore.Qt.DisplayRole):
        self.beginResetModel()
        self._dataframe.at[section, 'interchange'] = value
        self.endResetModel()

    @QtCore.pyqtSlot(str)
    def load_data(self, fp):
        df = pd.read_excel(fp, index_col=0)
        df = pd.DataFrame(data=df.columns.values, columns=['Variables'])
        df['logarithm'] = False
        df['sqr'] = False
        df['role'] = 'Independent'
        df.at[0, 'role'] = 'Dependent'
        df['interchange'] = ''
        self.setDataFrame(df)

    @QtCore.pyqtSlot(result=list)
    def get_variables(self):
        if 'Variables' in self._dataframe.columns:
            variables = ['']
            variables.extend(self._dataframe['Variables'].tolist())
            return variables
        return []

    @QtCore.pyqtSlot(result=str)
    def get_data(self):
        return self._dataframe.to_csv(index_label='id')

    def rowCount(self, parent=QtCore.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._dataframe.index)

    def columnCount(self, parent=QtCore.QModelIndex()):
        if parent.isValid():
            return 0
        df_first_column = self._dataframe.iloc[:, [0]]
        return df_first_column.columns.size

    def data(self, index, role=QtCore.Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < self.rowCount() and 0 <= index.column() < self.columnCount()):
            return QtCore.QVariant()
        row = self._dataframe.index[index.row()]
        col = self._dataframe.columns[index.column()]
        dt = self._dataframe[col].dtype

        val = self._dataframe.iloc[row][col]
        if role == QtCore.Qt.DisplayRole:
            return str(val)
        elif role == ForecastModel.ValueRole:
            return val
        if role == ForecastModel.DtypeRole:
            return dt
        return QtCore.QVariant()

    def roleNames(self):
        roles = {
            QtCore.Qt.DisplayRole: b'display',
            ForecastModel.DtypeRole: b'dtype',
            ForecastModel.ValueRole: b'value'
        }
        return roles
