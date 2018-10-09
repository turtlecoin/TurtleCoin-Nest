// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: rectangleSettings
    y: parent.height // starts off "screen"
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height
    color: "#333333"
    visible: false

    Rectangle {
        id: buttonClose
        width: 33
        height: 33
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        color: "transparent"
        Image {
            id: imageButtonClose
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/close.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonClose
            source:imageButtonClose
            color:"white"
            antialiasing: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedCloseSettings()
            }
        }
    }

    Text {
        id: textSettings
        color: "#ffffff"
        text: "SETTINGS"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.family: "Arial"
        font.pixelSize: 25
    }

    OldControls.CheckBox {
        id: checkBoxUSD
        text: "Display values also in USD"
        checked: false
        anchors.top: parent.top
        anchors.topMargin: 180
        anchors.left: parent.left
        anchors.leftMargin: 100

        style: CheckBoxStyle {
            label: Text {
                color: "#ffffff"
                font.pixelSize: 17
                font.family: "Arial"
                text: control.text
                leftPadding: 15
            }
        }

        onClicked: {
            QmlBridge.choseDisplayFiat(checkBoxUSD.checked);
        }
    }

    Text {
        id: textSettingsUSDDescr
        color: "#ffffff"
        text: "(Exchange rate from cryptocompare.com.)\n(Consider cautiously as current volume and liquidity are extremely low.)"
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: checkBoxUSD.verticalCenter
        anchors.left: checkBoxUSD.right
        anchors.leftMargin: 23
        horizontalAlignment: Text.AlignLeft
        font.family: "Arial"
        font.pixelSize: 14
    }

    Text {
        id: textSettingsRemoteNodeDescr
        color: "#ffffff"
        text: "Custom remote node:"
        anchors.top: checkBoxUSD.bottom
        anchors.topMargin: 80
        anchors.left: checkBoxUSD.left
        anchors.leftMargin: 0
        horizontalAlignment: Text.AlignLeft
        font.family: "Arial"
        font.pixelSize: 17
    }

    Text {
        id: textSettingsRemoteNodeComment
        color: "#ffffff"
        text: "(Select \"Custom\" at the bottom of the remote nodes list.)"
        anchors.top: textSettingsRemoteNodeDescr.bottom
        anchors.topMargin: 10
        anchors.left: textSettingsRemoteNodeDescr.left
        anchors.leftMargin: 0
        horizontalAlignment: Text.AlignLeft
        font.family: "Arial"
        font.pixelSize: 14
    }

    Text {
        id: textSettingsRemoteNodeAddressDescr
        color: "#ffffff"
        text: "address:"
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.left: textSettingsRemoteNodeDescr.right
        anchors.leftMargin: 25
        horizontalAlignment: Text.AlignLeft
        font.family: "Arial"
        font.pixelSize: 16
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: rectangleTextInputSettingsRemoteNodeAddress
        color: "#555555"
        height: 25
        width: 250
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.left: textSettingsRemoteNodeAddressDescr.right
        anchors.leftMargin: 10
        radius: 3

        TextInput {
            id: textInputSettingsRemoteNodeAddress
            anchors.fill: parent
            color: "#cfcfcf"
            text: ""
            rightPadding: 5
            leftPadding: 5
            selectionColor: "#eeeeee"
            selectedTextColor: "#999999"
            selectByMouse: true
            clip: true
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 15
            verticalAlignment: Text.AlignVCenter
        }
    }

    Text {
        id: textSettingsRemoteNodePortDescr
        color: "#ffffff"
        text: "port:"
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.left: rectangleTextInputSettingsRemoteNodeAddress.right
        anchors.leftMargin: 25
        horizontalAlignment: Text.AlignLeft
        font.family: "Arial"
        font.pixelSize: 16
    }

    Rectangle {
        id: rectangleTextInputSettingsRemoteNodePort
        color: "#555555"
        height: 25
        width: 70
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.left: textSettingsRemoteNodePortDescr.right
        anchors.leftMargin: 10
        radius: 3

        TextInput {
            id: textInputSettingsRemoteNodePort
            anchors.fill: parent
            color: "#cfcfcf"
            text: ""
            rightPadding: 5
            leftPadding: 5
            selectionColor: "#eeeeee"
            selectedTextColor: "#999999"
            selectByMouse: true
            clip: true
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 15
            verticalAlignment: Text.AlignVCenter
        }
    }

    Button {
        id: buttonSaveDaemonAddress
        text: "Save"
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.right: buttonResetDaemonAddress.left
        anchors.rightMargin: 20
        height: 30
        enabled: true

        contentItem: Text {
            text: buttonSaveDaemonAddress.text
            font.pixelSize: 15
            font.family: "Arial"
            font.bold: true
            opacity: enabled ? 1.0 : 0.3
            color: buttonSaveDaemonAddress.down ? "#dddddd" : "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 70
            height: buttonSaveDaemonAddress.height
            opacity: enabled ? 1 : 0.3
            radius: 6
            color: buttonSaveDaemonAddress.down ? "#383838" : "#444444"
        }

        onClicked: {
            QmlBridge.saveRemoteDaemonInfo(textInputSettingsRemoteNodeAddress.text, textInputSettingsRemoteNodePort.text);
        }
    }

    Button {
        id: buttonResetDaemonAddress
        text: "Reset to default"
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: textSettingsRemoteNodeDescr.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        height: 30
        enabled: true

        contentItem: Text {
            text: buttonResetDaemonAddress.text
            font.pixelSize: 15
            font.family: "Arial"
            font.bold: true
            opacity: enabled ? 1.0 : 0.3
            color: buttonResetDaemonAddress.down ? "#dddddd" : "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 140
            height: buttonResetDaemonAddress.height
            opacity: enabled ? 1 : 0.3
            radius: 6
            color: buttonResetDaemonAddress.down ? "#383838" : "#444444"
        }

        onClicked: {
            QmlBridge.resetRemoteDaemonInfo();
        }
    }

    function show() {
        settingsScreen.visible = true
        settingsScreen.state = "visible"
    }

    function hide() {
        settingsScreen.state = ""
    }

    states: State {
        name: "visible"
        PropertyChanges { target: settingsScreen; y: 0 }
    }

    transitions: [
        Transition {
            from: ""
            PropertyAnimation {
                properties: "y"
                duration: 200
            }
        },
        Transition {
            from: "visible"
            PropertyAnimation {
                properties: "y"
                duration: 200
            }
            onRunningChanged: {
                if ((state == "") && (!running))
                    settingsScreen.visible = false;
            }
        }
    ]

    Connections {
        target: QmlBridge

        onDisplaySettingsValues: {
            checkBoxUSD.checked = displayFiat
        }

        onDisplaySettingsRemoteDaemonInfo: {
            textInputSettingsRemoteNodeAddress.text = remoteNodeAddress
            textInputSettingsRemoteNodePort.text = remoteNodePort
        }
    }
}