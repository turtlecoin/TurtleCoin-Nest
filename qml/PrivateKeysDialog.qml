// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Dialog {
    id: dialogPrivateKeys
    title: "Private Keys"
    standardButtons: StandardButton.Ok
    width: 900

    property var walletFilename: ""
    property var walletPrivateViewKey: ""
    property var walletPrivateSpendKey: ""
    property var walletAddress: ""

    Text {
        id: textDescriptionPrivateKeys
        text: "See below your public address and your 2 private (secret) keys. The 2 private keys can be used to re-generate your wallet.\nCopy them both and keep them in a safe place.\nIf you lose them and lose your password or wallet file, you will not be able to recover your TRTLs.\nIf anybody has access to those keys, he can steal your TRTLs."
        font.family: "Arial"
        font.pixelSize: 13
    }

    Text {
        id: textDescriptionWalletFilename
        text: "Wallet file:"
        anchors.top: textDescriptionPrivateKeys.bottom
        anchors.topMargin: 25
        anchors.left: textDescriptionPrivateKeys.left
        anchors.leftMargin: 0
        font.family: "Arial"
        font.pixelSize: 13
    }

    Text {
        id: textWalletFilename
        text: walletFilename
        anchors.bottom: textDescriptionWalletFilename.bottom
        anchors.bottomMargin: 0
        anchors.left: textDescriptionWalletFilename.right
        anchors.leftMargin: 20
        font.family: "Arial"
        font.pixelSize: 13
    }

    Text {
        id: textDescriptionAddress
        text: "Address"
        anchors.top: textDescriptionWalletFilename.bottom
        anchors.topMargin: 25
        anchors.left: textDescriptionWalletFilename.left
        anchors.leftMargin: 0
        font.family: "Arial"
        font.pixelSize: 13
    }

    TextInput {
        id: textInputAddress
        anchors.top: textDescriptionAddress.bottom
        anchors.topMargin: 10
        anchors.left: textDescriptionAddress.left
        anchors.leftMargin: 0
        readOnly: true
        text: walletAddress
        leftPadding: 5
        padding: 2
        selectionColor: "#333333"
        selectedTextColor: "white"
        selectByMouse: true
        font.family: "Arial"
        font.pixelSize: 13
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: textDescriptionPrivateViewKey
        text: "Private View Key"
        anchors.top: textInputAddress.bottom
        anchors.topMargin: 25
        anchors.left: textInputAddress.left
        anchors.leftMargin: 0
        font.family: "Arial"
        font.pixelSize: 13
    }

    TextInput {
        id: textInputPrivateViewKey
        anchors.top: textDescriptionPrivateViewKey.bottom
        anchors.topMargin: 10
        anchors.left: textDescriptionPrivateViewKey.left
        anchors.leftMargin: 0
        readOnly: true
        text: walletPrivateViewKey
        leftPadding: 5
        padding: 2
        selectionColor: "#333333"
        selectedTextColor: "white"
        selectByMouse: true
        font.family: "Arial"
        font.pixelSize: 13
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: textDescriptionPrivateSpendKey
        text: "Private Spend Key"
        anchors.top: textInputPrivateViewKey.bottom
        anchors.topMargin: 25
        anchors.left: textInputPrivateViewKey.left
        anchors.leftMargin: 0
        font.family: "Arial"
        font.pixelSize: 13
    }

    TextInput {
        id: textInputPrivateSpendKey
        anchors.top: textDescriptionPrivateSpendKey.bottom
        anchors.topMargin: 10
        anchors.left: textDescriptionPrivateSpendKey.left
        anchors.leftMargin: 0
        readOnly: true
        text: walletPrivateSpendKey
        leftPadding: 5
        padding: 2
        selectionColor: "#333333"
        selectedTextColor: "white"
        selectByMouse: true
        font.family: "Arial"
        font.pixelSize: 13
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Button {
        id: buttonCopyKeys
        text: "Copy to clipboard"
        anchors.bottom: textInputPrivateSpendKey.bottom
        anchors.bottomMargin: 40
        anchors.left: textInputPrivateSpendKey.right
        anchors.leftMargin: 80
        height: 30

        contentItem: Text {
            text: buttonCopyKeys.text
            font.pixelSize: 15
            font.family: "Arial"
            font.bold: true
            opacity: enabled ? 1.0 : 0.3
            color: buttonCopyKeys.down ? "#dddddd" : "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 140
            height: 30
            opacity: enabled ? 1 : 0.3
            radius: 6
            color: buttonCopyKeys.down ? "#383838" : "#444444"
        }

        onClicked: {
            QmlBridge.clickedButtonCopyKeys();
        }
    }

    onAccepted: {
        walletFilename = "";
        walletPrivateViewKey = "";
        walletPrivateSpendKey = "";
        walletAddress = "";
    }

    function show(filename, privateViewKey, privateSpendKey, address) {
        walletFilename = filename;
        walletPrivateViewKey = privateViewKey;
        walletPrivateSpendKey = privateSpendKey;
        walletAddress = address;
        dialogPrivateKeys.open();
    }
}