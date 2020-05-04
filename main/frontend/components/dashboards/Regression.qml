import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtCharts 2.3
import QtQuick 2.2
import QtQuick.Dialogs 1.0

import '..'

Page {
    name: 'Regression'
    ColumnLayout {
        GroupBox {
            id: groupBox
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    text: 'Insert data'
                    Layout.alignment: Qt.AlignHCenter
                }
                Button {
                    text: "Ok"
                    onClicked: fileDialog.open()
                }
                Label {
                    id: fileLabel
                    text: r_manager.coeff
                    Layout.alignment: Qt.AlignHCenter
                }
                FileDialog {
                    id: fileDialog
                    title: "Please choose a file"
                    folder: shortcuts.home
                    onAccepted: () => {
                        r_manager.load_data(fileDialog.fileUrl)
                        fileDialog.close()
                    }
                    onRejected: {
                        console.log("Canceled")
                        fileDialog.close()
                    }
                    Component.onCompleted: visible = false
                }
            }
        }
        GroupBox {
            id: groupBox2
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    id: regLabel
                    text: 'Insert data'
                    Layout.alignment: Qt.AlignHCenter
                }
                RoundButton {
                    id: startButton2
                    icon.source: '../../../assets/images/baseline-play_arrow-24px.svg'
                    radius: 0
                    ToolTip.visible: hovered
                    ToolTip.text: 'Start Training'
                    onClicked: () => {
                        r_manager.predictions_plot()
                    }
                }
                Label {
                    text: r_manager.coeff
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}