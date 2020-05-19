import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2

import Backend 1.0

import '..'

SplitView {
    property string name: 'Fixed Income Options'
    Rectangle {
        color: "#303030"
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 600
        ColumnLayout {
            anchors.fill: parent
            GroupBox {
                title: 'Volatility Heatmap'
                Layout.fillWidth: true
                Layout.fillHeight: true
                GridLayout {
                    anchors.fill: parent
                    columns: 1
                    FigureCanvas {
                        id: volHeat
                        objectName : "volatility_heatmap_figure"
                        dpi_ratio: Screen.devicePixelRatio
                        anchors.fill: parent
                    }
                }
            }
            GroupBox {
                title: 'Volatility Surface'
                Layout.fillWidth: true
                Layout.fillHeight: true
                GridLayout {
                    anchors.fill: parent
                    columns: 1
                    FigureCanvas {
                        id: volSurf
                        objectName : "volatility_surface_figure"
                        dpi_ratio: Screen.devicePixelRatio
                        anchors.fill: parent
                    }
                }
            }
        }
    }
    Rectangle {
        color: "#303030"
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 1000
        ColumnLayout {
            anchors.fill: parent
            ScrollView {
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                Flickable {
                    contentHeight: 2000
                    width: parent.width
                    ColumnLayout {
                        anchors.fill: parent
                        GroupBox {
                            title: 'Options strategy'
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.rightMargin: 20

                            GridLayout {
                                anchors.fill: parent
                                columns: 1

                                FigureCanvas {
                                    id: optStrategy
                                    objectName : "options_strategy_figure"
                                    dpi_ratio: Screen.devicePixelRatio
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                }
                            }
                        }
                        GroupBox {
                            title: 'kkkkkkkkk'
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.rightMargin: 20

                            GridLayout {
                                anchors.fill: parent
                                columns: 1

                                FigureCanvas {
                                    id: optStrategy2
                                    objectName : "options_strategy_figure2"
                                    dpi_ratio: Screen.devicePixelRatio
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}