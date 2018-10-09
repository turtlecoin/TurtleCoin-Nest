// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Item {
    id: itemListTransaction
    visible: true
    property bool newTransaction: false
    Text {
        id: transactionAmount
        color: "#cfcfcf"
        text: transactionAmountValue
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: parent.top
        anchors.topMargin: 5
        font.family: "Arial"
        font.bold: true
        font.pixelSize: 17
    }
    
    Text {
        id: transactionID
        color: "#cfcfcf"
        text: "Tr. ID: " + transactionIDValue
        anchors.top: transactionAmount.bottom
        anchors.topMargin: 8
        anchors.left: transactionAmount.left
        anchors.leftMargin: 0
        verticalAlignment: Text.AlignVCenter
        font.family: "Arial"
        font.pixelSize: 11
    }
    
    Text {
        id: transactionPaymentID
        color: "#cfcfcf"
        text: "Payment ID: " + transactionPaymentIDValue
        anchors.top: transactionID.bottom
        anchors.topMargin: 8
        anchors.left: transactionID.left
        anchors.leftMargin: 0
        verticalAlignment: Text.AlignVCenter
        font.family: "Arial"
        font.pixelSize: 11
    }
    
    Text {
        id: transactionTime
        color: "#cfcfcf"
        text: transactionTimeValue
        anchors.right: transactionConfirmations.left
        anchors.rightMargin: 15
        anchors.verticalCenter: transactionAmount.verticalCenter
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 12
        font.family: "Arial"
    }
    
    Text {
        id: transactionConfirmations
        color: "#cfcfcf"
        text: transactionConfirmationsValue
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: transactionTime.verticalCenter
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 12
        font.family: "Arial"
    }

    Text {
        id: transactionNumber
        color: "#cfcfcf"
        text: transactionNumberValue
        anchors.top: transactionAmount.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 5
        font.family: "Arial"
        font.pixelSize: 11
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: buttonCopyTxID
        width: 17
        height: 17
        anchors.verticalCenter: transactionID.verticalCenter
        anchors.left: transactionID.right
        anchors.leftMargin: 10
        color: "transparent"
        Image {
            id: imageButtonCopyTxID
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/copy.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonCopyTxID
            source:imageButtonCopyTxID
            color:"white"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedButtonCopyTx(transactionIDValue);
                popupText.show("Copied!")
            }
        }
    }

    Rectangle {
        id: buttonExplorerTxID
        width: 17
        height: 17
        anchors.verticalCenter: buttonCopyTxID.verticalCenter
        anchors.left: buttonCopyTxID.right
        anchors.leftMargin: 10
        color: "transparent"
        Image {
            id: imageButtonExplorerTxID
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/search.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonExplorerTxID
            source:imageButtonExplorerTxID
            color:"white"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedButtonExplorer(transactionIDValue)
            }
        }
    }
}
