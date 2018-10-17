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
import QtGraphicalEffects 1.0

Rectangle {
    id: rectangleMainWallet
    x: parent.width // starts off "screen"
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    height: parent.height
    color: "#333333"
    visible: false

    Rectangle {
        id: buttonBack
        width: 33
        height: 33
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        color: "transparent"
        Image {
            id: imageButtonBack
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/back.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonBack
            source:imageButtonBack
            color:"white"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedCloseWallet()
            }
        }
    }

    Rectangle {
        id: buttonInfo
        width: 33
        height: 33
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        color: "transparent"
        Image {
            id: imageButtonInfo
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/info.svg"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                infoDialog.show()
            }
        }
    }

    Rectangle {
        id: rectangleTop
        height: 110
        color: "transparent"
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 15
        opacity: 1

        Rectangle {
            id: rectangleLockedBalance
            x: 415
            width: 338
            color: "transparent"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Text {
                id: textLockedUnit
                color: "#cfcfcf"
                text: "TRTL"
                anchors.right: parent.right
                anchors.rightMargin: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                verticalAlignment: Text.AlignBottom
                font.family: "Arial"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: textAvailableUnit
                color: "#cfcfcf"
                text: "TRTL"
                font.family: "Arial"
                font.pixelSize: 15
                anchors.right: textLockedUnit.right
                anchors.rightMargin: 0
                anchors.bottom: textLockedUnit.top
                anchors.bottomMargin: 12
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: textLockedValue
                color: "#cfcfcf"
                text: "0"
                anchors.right: textLockedUnit.left
                anchors.rightMargin: 10
                anchors.bottom: textLockedUnit.bottom
                anchors.bottomMargin: -1
                font.family: "Arial"
                font.pixelSize: 19
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight

                Connections {
                    target: QmlBridge
                    onDisplayLockedBalance: {
                        textLockedValue.text = data
                    }
                }
            }

            Text {
                id: textAvailableValue
                color: "#cfcfcf"
                text: "0"
                anchors.right: textLockedValue.right
                anchors.rightMargin: 0
                anchors.bottom: textAvailableUnit.bottom
                anchors.bottomMargin: -1
                font.family: "Arial"
                font.pixelSize: 19
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight

                Connections {
                    target: QmlBridge
                    onDisplayAvailableBalance: {
                        textAvailableValue.text = data
                    }
                }
            }

            Text {
                id: textLockedDescr
                color: "#cfcfcf"
                text: "Locked/Unconfirmed:"
                anchors.bottom: textLockedUnit.bottom
                anchors.bottomMargin: 0
                font.family: "Arial"
                font.pixelSize: 15
                anchors.left: parent.left
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: textAvailableDescr
                color: "#cfcfcf"
                text: "Available:"
                anchors.bottom: textAvailableUnit.bottom
                anchors.bottomMargin: 0
                anchors.left: textLockedDescr.left
                anchors.leftMargin: 0
                font.family: "Arial"
                font.pixelSize: 15
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
            }
        }

        Text {
            id: textBalance
            color: "#ffffff"
            text: "BALANCE"
            verticalAlignment: Text.AlignBottom
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 15
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.family: "Arial"
            font.pixelSize: 25
        }

        Text {
            id: textBalanceValue
            color: "#ffffff"
            text: "0"
            verticalAlignment: Text.AlignBottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Arial"
            font.pixelSize: 30
            font.bold: true
            anchors.horizontalCenterOffset: 0
            horizontalAlignment: Text.AlignRight
        }

        Text {
            id: textBalanceUnit
            color: "#ffffff"
            text: "TRTL"
            verticalAlignment: Text.AlignBottom
            anchors.left: textBalanceValue.right
            anchors.leftMargin: 15
            anchors.bottom: textBalanceValue.bottom
            anchors.bottomMargin: 2
            font.family: "Arial"
            font.pixelSize: 18
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textBalanceUSD
            color: "#858585"
            text: ""
            anchors.right: textBalanceValue.right
            anchors.rightMargin: 0
            anchors.top: textBalanceUnit.bottom
            anchors.topMargin: 8
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignRight
            visible: false
        }

        Text {
            id: textUSD
            color: "#858585"
            text: "$"
            anchors.left: textBalanceUnit.left
            anchors.leftMargin: 0
            anchors.bottom: textBalanceUSD.bottom
            anchors.bottomMargin: 0
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignLeft
            visible: false
        }
    }

    Rectangle {
        id: rectangleAddress
        height: 126
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangleTop.bottom
        anchors.topMargin: 30
        color: "transparent"

        Text {
            id: textDescrWalletName
            color: "#858585"
            text: "wallet: "
            verticalAlignment: Text.AlignBottom
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.top: parent.top
            anchors.topMargin: 0
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textWalletName
            color: "#858585"
            text: ""
            verticalAlignment: Text.AlignBottom
            anchors.left: textDescrWalletName.right
            anchors.leftMargin: 10
            anchors.bottom: textDescrWalletName.bottom
            anchors.bottomMargin: 0
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignLeft
        }

        Button {
            id: buttonBackupKeys
            text: "Backup wallet"
            anchors.verticalCenter: textDescrWalletName.verticalCenter
            anchors.left: textWalletName.right
            anchors.leftMargin: 30
            height: 30
            enabled: true

            contentItem: Text {
                text: buttonBackupKeys.text
                font.pixelSize: 15
                font.family: "Arial"
                font.bold: true
                opacity: enabled ? 1.0 : 0.3
                color: buttonBackupKeys.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                height: 30
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonBackupKeys.down ? "#383838" : "#444444"
            }

            onClicked: {
                QmlBridge.clickedButtonBackupWallet();
            }
        }

        TextInput {
            id: textAddress
            color: "#ffffff"
            text: "NO WALLET OPEN"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: textDescrWalletName.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 0
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            readOnly: true
            selectionColor: "#eeeeee"
            selectedTextColor: "#777777"
            selectByMouse: true
        }

        Rectangle {
            id: buttonCopy
            width: 39
            height: 42
            anchors.top: textAddress.bottom
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 20
            color: "transparent"
            Image {
                id: imageButtonCopy
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "images/copy.svg"
                antialiasing: true
            }
            ColorOverlay {
                anchors.fill: imageButtonCopy
                source:imageButtonCopy
                color:"white"
                antialiasing: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    QmlBridge.clickedButtonCopyAddress();
                }
            }
        }

        Text {
            id: textDescrCopyAddress
            color: "#858585"
            text: "Copy your address to receive TRTL"
            anchors.verticalCenter: buttonCopy.verticalCenter
            anchors.right: buttonCopy.left
            anchors.rightMargin: 15
            font.family: "Arial"
            horizontalAlignment: Text.AlignRight
            font.weight: Font.Normal
            font.bold: true
            font.pixelSize: 15
        }
    }

    Rectangle {
        id: rectangleHistory
        color: "transparent"
        anchors.bottom: rectangleConnectionInfo.top
        anchors.bottomMargin: 10
        anchors.right: parent.left
        anchors.rightMargin: -590
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: rectangleAddress.bottom
        anchors.topMargin: 10

        Text {
            id: textHistoryTitle
            color: "#ffffff"
            text: "PREVIOUS TRANSACTIONS"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            font.family: "Arial"
            verticalAlignment: Text.AlignBottom
            font.bold: true
        }

        Component {
            id: delegateListViewTransactions
            ItemListTransaction {
                id: itemListTransaction
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 80
            }
        }

        ListModel {
            id: modelListViewTransactions
        }

        Rectangle {
            id: rectangleListTransactions
            color: "#2b2b2b"
            radius: 11
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: textHistoryTitle.bottom
            anchors.topMargin: 15

            ListView {
                id: listViewTransactions
                model: modelListViewTransactions
                delegate: delegateListViewTransactions
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                ScrollBar.vertical: ScrollBar {
                    width: 7
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    policy: ScrollBar.AlwaysOn
                }
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10

                Connections {
                    target: QmlBridge
                    onAddTransactionToList: {
                        modelListViewTransactions.append({
                            transactionAmountValue: amount,
                            transactionPaymentIDValue: paymentID,
                            transactionIDValue: transactionID,
                            transactionConfirmationsValue: confirmations,
                            transactionTimeValue: time,
                            transactionNumberValue: number
                        })
                    }

                    onUpdateConfirmationsOfTransaction: {
                        modelListViewTransactions.setProperty(index, "transactionConfirmationsValue", confirmations)
                    }
                }
            }
        }

        Text {
            id: textListTransactionLimitedDescr
            color: "#cfcfcf"
            text: "Show transactions:"
            anchors.left: rectangleListTransactions.left
            anchors.leftMargin: 5
            anchors.top: rectangleListTransactions.bottom
            anchors.topMargin: 11
            font.family: "Arial"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignRight
        }

        Text {
            id: textListTransactionLimited
            color: "#cfcfcf"
            text: "Last 20"
            anchors.right: switchNumberTransactions.left
            anchors.rightMargin: 4
            anchors.verticalCenter: textListTransactionLimitedDescr.verticalCenter
            font.family: "Arial"
            font.pixelSize: 14
            font.bold: !switchNumberTransactions.checked
            horizontalAlignment: Text.AlignRight
        }

        Switch {
            id: switchNumberTransactions
            anchors.left: textListTransactionLimitedDescr.right
            anchors.leftMargin: 65
            anchors.verticalCenter: textListTransactionLimitedDescr.verticalCenter
            checked: false

            onClicked: {
                QmlBridge.limitDisplayTransactions(!checked)
            }
        }

        Text {
            id: textListTransactionAll
            color: "#cfcfcf"
            text: "All"
            anchors.left: switchNumberTransactions.right
            anchors.leftMargin: 4
            anchors.verticalCenter: textListTransactionLimitedDescr.verticalCenter
            font.family: "Arial"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            font.bold: switchNumberTransactions.checked
        }

        Button {
            id: buttonExportListTransactions
            text: "download history"
            anchors.verticalCenter: textListTransactionLimitedDescr.verticalCenter
            anchors.left: textListTransactionAll.right
            anchors.leftMargin: 50
            height: 25
            enabled: true

            contentItem: Text {
                text: buttonExportListTransactions.text
                font.pixelSize: 12
                font.family: "Arial"
                font.bold: true
                opacity: enabled ? 1.0 : 0.3
                color: buttonExportListTransactions.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 70
                height: buttonExportListTransactions.height
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonExportListTransactions.down ? "#383838" : "#444444"
            }

            onClicked: {
                QmlBridge.exportListTransactions();
            }
        }

        Connections {
            target: QmlBridge
            onClearListTransactions: {
                modelListViewTransactions.clear();
            }
        }
    }

    Rectangle {
        id: rectangleTransfer
        color: "transparent"
        anchors.bottom: rectangleConnectionInfo.top
        anchors.bottomMargin: 10
        anchors.left: rectangleHistory.right
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: rectangleHistory.top
        anchors.topMargin: 0

        property var transferRecipient: ""
        property var transferAmount: ""
        property var transferPaymentID: ""
        property var transferFee: ""
        property var nodeFeeValue: "0"

        Text {
            id: textTransferTitle
            color: "#ffffff"
            text: "TRANSFER"
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            anchors.top: parent.top
            font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignBottom
            anchors.topMargin: 10
        }

        Text {
            id: textTransferAddrDescr
            color: "#ffffff"
            text: "Recipient address (or integrated address)"
            anchors.top: textTransferTitle.bottom
            anchors.topMargin: 34
            anchors.left: parent.left
            anchors.leftMargin: 30
            font.pixelSize: 14
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Rectangle {
            id: rectangleTextInputTransferAddress
            color: "#555555"
            height: 25
            anchors.right: buttonSavedAddress.left
            anchors.rightMargin: 7
            anchors.top: textTransferAddrDescr.bottom
            anchors.topMargin: 6
            anchors.left: textTransferAddrDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputTransferAddress
                anchors.fill: parent
                color: "#cfcfcf"
                text: ""
                rightPadding: 5
                leftPadding: 5
                padding: 2
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonSend.enabled = textInputTransferAmount.text != "" && textInputTransferAddress.text != ""
                    /* Disable payment ID input if integrated address */
                    textInputTransferPaymentID.enabled = textInputTransferAddress.text.length != 187
                }
            }
        }

        Button {
            id: buttonSavedAddress
            text: "addresses"
            anchors.bottom: rectangleTextInputTransferAddress.verticalCenter
            anchors.bottomMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 3
            height: buttonSaveAddress.height
            enabled: true

            contentItem: Text {
                text: buttonSavedAddress.text
                font.pixelSize: 12
                font.family: "Arial"
                font.bold: true
                opacity: enabled ? 1.0 : 0.3
                color: buttonSavedAddress.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 70
                height: buttonSavedAddress.height
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonSavedAddress.down ? "#383838" : "#444444"
            }

            onClicked: {
                dialogListAddresses.show();
            }
        }

        Button {
            id: buttonSaveAddress
            text: "save"
            anchors.top: rectangleTextInputTransferAddress.verticalCenter
            anchors.topMargin: 2
            anchors.horizontalCenter: buttonSavedAddress.horizontalCenter
            height: 25
            enabled: true

            contentItem: Text {
                text: buttonSaveAddress.text
                font.pixelSize: 12
                font.family: "Arial"
                font.bold: true
                opacity: enabled ? 1.0 : 0.3
                color: buttonSaveAddress.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 70
                height: 25
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonSaveAddress.down ? "#383838" : "#444444"
            }

            onClicked: {
                dialogNameAddress.show();
            }
        }

        Text {
            id: textTransferAmountDescr
            color: "#ffffff"
            text: "Amount"
            anchors.top: rectangleTextInputTransferAddress.bottom
            anchors.topMargin: 13
            anchors.left: textTransferAddrDescr.left
            anchors.leftMargin: 0
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            font.family: "Arial"
        }

        Rectangle {
            id: rectangleTextInputTransferAmount
            color: "#555555"
            anchors.left: textTransferAmountDescr.left
            anchors.leftMargin: 0
            anchors.top: textTransferAmountDescr.bottom
            anchors.topMargin: 7
            height: 25
            width: 90
            radius: 3

            TextInput {
                id: textInputTransferAmount
                anchors.fill: parent
                color: "#cfcfcf"
                text: ""
                rightPadding: 5
                leftPadding: 5
                padding: 2
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonSend.enabled = textInputTransferAmount.text != "" && textInputTransferAddress.text != "";
                    textTransferAmountUSD.text = QmlBridge.getTransferAmountUSD(textInputTransferAmount.text);
                }
            }
        }

        Text {
            id: textTransferAmountUnit
            color: "#999999"
            text: "TRTL"
            anchors.verticalCenter: rectangleTextInputTransferAmount.verticalCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 14
            anchors.left: rectangleTextInputTransferAmount.right
            font.family: "Arial"
            verticalAlignment: Text.AlignBottom
            anchors.leftMargin: 10
            font.bold: true
        }

        Text {
            id: textTransferAmountUSD
            color: "#858585"
            text: ""
            anchors.left: textTransferAmountUnit.right
            anchors.leftMargin: 25
            anchors.bottom: textTransferAmountUnit.bottom
            anchors.bottomMargin: 0
            font.family: "Arial"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignRight
            visible: false
        }

        Button {
            id: buttonFullBalance
            text: "full balance"
            anchors.verticalCenter: rectangleTextInputTransferAmount.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 25
            height: 25
            enabled: true

            contentItem: Text {
                text: buttonFullBalance.text
                font.pixelSize: 12
                font.family: "Arial"
                font.bold: true
                opacity: enabled ? 1.0 : 0.3
                color: buttonFullBalance.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 100
                height: buttonFullBalance.height
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonFullBalance.down ? "#383838" : "#444444"
            }

            onClicked: {
                QmlBridge.getFullBalanceAndDisplayInTransferAmount(textInputTransferFee.text);
            }
        }

        Text {
            id: textTransferPaymentIDDescr
            color: "#ffffff"
            text: "Payment ID (optional)"
            anchors.top: rectangleTextInputTransferAmount.bottom
            anchors.topMargin: 13
            anchors.left: textTransferAddrDescr.left
            anchors.leftMargin: 0
            font.pixelSize: 14
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textTransferPaymentIDWarning
            color: "#999999"
            text: "(WARNING: include a payment ID if you were asked to by your recipient)"
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: textTransferPaymentIDDescr.bottom
            anchors.topMargin: 4
            anchors.left: textTransferPaymentIDDescr.left
            anchors.leftMargin: 0
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
            font.family: "Arial"
        }

        Rectangle {
            id: rectangleTextInputTransferPaymentID
            color: "#555555"
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: textTransferPaymentIDWarning.bottom
            anchors.topMargin: 8
            anchors.left: textTransferPaymentIDWarning.left
            anchors.leftMargin: 0
            height: 25
            radius: 3

            TextInput {
                id: textInputTransferPaymentID
                anchors.fill: parent
                color: "#cfcfcf"
                text: ""
                rightPadding: 5
                leftPadding: 5
                padding: 2
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            id: textTransferFeeDescr
            color: "#ffffff"
            text: "Network fee"
            anchors.top: rectangleTextInputTransferPaymentID.bottom
            anchors.topMargin: 13
            anchors.left: textTransferAddrDescr.left
            anchors.leftMargin: 0
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            font.family: "Arial"
        }

        Rectangle {
            id: rectangleTextInputTransferFee
            color: "#555555"
            anchors.left: textTransferFeeDescr.left
            anchors.leftMargin: 0
            anchors.top: textTransferFeeDescr.bottom
            anchors.topMargin: 7
            height: 25
            width: 50
            radius: 3

            TextInput {
                id: textInputTransferFee
                anchors.fill: parent
                color: "#cfcfcf"
                text: ""
                rightPadding: 5
                leftPadding: 5
                padding: 2
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            id: textTransferFeeUnit
            color: "#999999"
            text: "TRTL"
            anchors.verticalCenter: rectangleTextInputTransferFee.verticalCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 14
            anchors.left: rectangleTextInputTransferFee.right
            font.family: "Arial"
            verticalAlignment: Text.AlignBottom
            anchors.leftMargin: 10
            font.bold: true
        }

        Text {
            id: textNodeFeeTitle
            color: "#ffffff"
            text: "Node fee"
            anchors.top: textTransferFeeDescr.top
            anchors.topMargin: 0
            anchors.left: textTransferFeeDescr.right
            anchors.leftMargin: 80
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            font.family: "Arial"
        }

        Text {
            id: textNodeFeeDescr
            color: "#999999"
            text: "The node you connect\nto charges a fee of:"
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: textNodeFeeTitle.bottom
            anchors.topMargin: 4
            anchors.left: textNodeFeeTitle.left
            anchors.leftMargin: 0
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
            font.family: "Arial"
        }

        Text {
            id: textNodeFeeValue
            color: "#cfcfcf"
            text: rectangleTransfer.nodeFeeValue
            font.pixelSize: 14
            font.family: "Arial"
            font.bold: true
            anchors.bottom: textTransferFeeUnit.bottom
            anchors.bottomMargin: 0
            anchors.right: textNodeFeeUnit.left
            anchors.rightMargin: 7
        }

        Text {
            id: textNodeFeeUnit
            color: "#999999"
            text: "TRTL / tr."
            font.pixelSize: 14
            font.family: "Arial"
            font.bold: true
            anchors.bottom: textNodeFeeValue.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        Button {
            id: buttonSend
            text: "SEND"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            enabled: false

            contentItem: Text {
                text: buttonSend.text
                font.bold: true
                font.pointSize: 20
                font.family: "Arial"
                opacity: enabled ? 1.0 : 0.3
                color: buttonSend.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                implicitHeight: 60
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonSend.down ? "#383838" : "#444444"
            }

            onClicked: {
                rectangleTransfer.transferRecipient = textInputTransferAddress.text
                rectangleTransfer.transferAmount = textInputTransferAmount.text
                if (textInputTransferPaymentID.enabled)
                {
                    rectangleTransfer.transferPaymentID = textInputTransferPaymentID.text
                }
                /* Don't add the payment ID if integrated address */
                else
                {
                    rectangleTransfer.transferPaymentID = "";
                }
                rectangleTransfer.transferFee = textInputTransferFee.text
                dialogConfirmTransfer.show(rectangleTransfer.transferRecipient, rectangleTransfer.transferAmount + " TRTL + " + rectangleTransfer.transferFee + " (fee) + " + rectangleTransfer.nodeFeeValue + " (node fee)", rectangleTransfer.transferPaymentID);
            }
        }

        function transferConfirmed() {
            rectangleMainWallet.startWaiting();
            QmlBridge.clickedButtonSend(transferRecipient, transferAmount, transferPaymentID, transferFee);
        }

        function enteredNameAddress(nameAddress) {
            QmlBridge.saveAddress(nameAddress, textInputTransferAddress.text, textInputTransferPaymentID.text);
        }
    }

    Rectangle {
        id: rectangleConnectionInfo
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 20

        Text {
            id: textConnectionInfo
            color: "#ffffff"
            text: ""
            font.pixelSize: 13
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Arial"
            anchors.right: parent.right
            anchors.rightMargin: 0
        }

        Text {
            id: textConnectionInfoSync
            color: "#ffffff"
            text: "Syncing..."
            font.bold: true
            font.pixelSize: 13
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Arial"
            anchors.right: textConnectionInfo.left
            anchors.rightMargin: 20
        }
    }

    Rectangle {
        id: popupText

        color: "#4d4d4d"
        border.color: "#ffffff"; border.width: 1
        radius: 4
        y: parent.height // starts off "screen"
        anchors.horizontalCenter: parent.horizontalCenter
        width: labelPopupText.width + 20
        height: labelPopupText.height + 40
        opacity: 0

        function show(msg) {
            labelPopupText.text = msg
            popupText.state = "visible"
            timerPopupText.start()
        }

        states: State {
            name: "visible"
            PropertyChanges { target: popupText; opacity: 1 }
            PropertyChanges { target: popupText; y: (parent.height-popupText.height)/2 }
        }

        transitions: [
            Transition { from: ""; PropertyAnimation { properties: "opacity,y"; duration: 65 } },
            Transition { from: "visible"; PropertyAnimation { properties: "opacity,y"; duration: 500 } }
        ]

        Timer {
            id: timerPopupText
            interval: 1000
            onTriggered: popupText.state = ""
        }

        Text {
            id: labelPopupText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 15
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            smooth: true
        }

        Connections{
            target: QmlBridge
            onDisplayPopup: {
                timerPopupText.interval = time
                popupText.show(text)
            }
        }
    }

    PrivateKeysDialog {
        id: privateKeysDialog
    }

    SeedDialog {
        id: seedDialog
    }

    Dialog {
        id: dialogConfirmTransfer
        title: "Confirm transfer"
        standardButtons: StandardButton.Cancel | StandardButton.Ok
        width: 400

        Text {
            id: textDescriptionConfirmRecipient
            text: "To:"
            font.family: "Arial"
        }

        Text {
            id: textConfirmRecipient
            text: ""
            font.family: "Arial"
            font.bold: true
            elide: Text.ElideMiddle
            anchors.bottom: textDescriptionConfirmRecipient.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 100
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        Text {
            id: textDescriptionConfirmAmount
            text: "Amount:"
            font.family: "Arial"
            anchors.top: textDescriptionConfirmRecipient.bottom
            anchors.topMargin: 12
            anchors.left: textDescriptionConfirmRecipient.left
            anchors.leftMargin: 0
        }

        Text {
            id: textConfirmAmount
            text: ""
            font.family: "Arial"
            font.bold: true
            anchors.bottom: textDescriptionConfirmAmount.bottom
            anchors.bottomMargin: 0
            anchors.left: textConfirmRecipient.left
            anchors.leftMargin: 0
        }

        Text {
            id: textDescriptionConfirmPaymentID
            text: "Payment ID:"
            font.family: "Arial"
            anchors.top: textDescriptionConfirmAmount.bottom
            anchors.topMargin: 12
            anchors.left: textDescriptionConfirmAmount.left
            anchors.leftMargin: 0
        }

        Text {
            id: textConfirmPaymentID
            text: ""
            font.family: "Arial"
            font.bold: true
            elide: Text.ElideMiddle
            anchors.bottom: textDescriptionConfirmPaymentID.bottom
            anchors.bottomMargin: 0
            anchors.left: textConfirmRecipient.left
            anchors.leftMargin: 0
            anchors.right: textConfirmRecipient.right
            anchors.rightMargin: 0
        }

        function show(recipient, amount, paymentID) {
            textConfirmRecipient.text = recipient;
            textConfirmAmount.text = amount;
            textConfirmPaymentID.text = paymentID;
            dialogConfirmTransfer.open();
        }

        onAccepted: {
            rectangleTransfer.transferConfirmed();
            textConfirmRecipient.text = "";
            textConfirmAmount.text = "";
            textConfirmPaymentID.text = "";
        }
    }

    InfoDialog {
        id: infoDialog
    }

    Dialog {
        id: dialogFusion
        title: "Wallet must be optimized"
        standardButtons: StandardButton.Yes | StandardButton.No
        width: 650
        height: 150

        Text {
            id: textDescriptionDialogFusion
            text: "Transaction size is too big.\nA transaction must be sent from your address to itself for optimizing your wallet (fusion transaction)."
            font.family: "Arial"
        }

        Text {
            text: "Would you like to send a fusion transaction? (you might have to do it multiple times)"
            font.family: "Arial"
            font.bold: true
            anchors.top: textDescriptionDialogFusion.bottom
            anchors.topMargin: 10
        }

        function show() {
            dialogFusion.open();
        }

        onYes: {
            rectangleMainWallet.startWaiting();
            QmlBridge.optimizeWalletWithFusion();
        }
    }

    Dialog {
        id: dialogNameAddress
        title: "Name for saving address"
        standardButtons: StandardButton.Cancel | StandardButton.Ok
        width: 250
        height: 120

        Text {
            id: textDescriptionNameAddress
            text: "Choose a name for this address:"
            font.family: "Arial"
        }

        Rectangle {
            id: rectangleTextInputNameAddress
            color: "#bbbbbb"
            height: 25
            anchors.top: textDescriptionNameAddress.bottom
            anchors.topMargin: 12
            anchors.left: textDescriptionNameAddress.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            radius: 3

            TextInput {
                id: textInputNameAddress
                anchors.fill: parent
                color: "#444444"
                text: ""
                rightPadding: 5
                leftPadding: 5
                verticalAlignment: Text.AlignVCenter
                clip: true
                font.family: "Arial"
            }
        }

        function show() {
            dialogNameAddress.open();
            textInputNameAddress.text = "";
            textInputNameAddress.focus = true;
        }

        onAccepted: {
            rectangleTransfer.enteredNameAddress(textInputNameAddress.text)
        }
    }

    Dialog {
        id: dialogListAddresses
        title: "Your saved addresses"
        standardButtons: StandardButton.Cancel
        width: 400
        height: 500

        Component {
            id: delegateListViewAddresses
            ItemListAddress {
                id: itemListAddress
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 80

                function clickedSavedAddress(address, paymentID) {
                    
                    textInputTransferAddress.text = address;
                    textInputTransferAddress.cursorPosition = 0;
                    textInputTransferPaymentID.text = paymentID;
                    textInputTransferPaymentID.cursorPosition = 0;
                    
                    dialogListAddresses.close();
                }

                function clickedDeleteSavedAddress(dbID) {
                    QmlBridge.deleteSavedAddress(dbID)

                    modelListViewAddresses.clear();
                    QmlBridge.fillListSavedAddresses();
                }
            }
        }

        ListModel {
            id: modelListViewAddresses
        }

        Rectangle {
            id: rectangleListAddresses
            anchors.fill: parent

            ListView {
                id: listViewAddresses
                model: modelListViewAddresses
                delegate: delegateListViewAddresses
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                ScrollBar.vertical: ScrollBar {
                    width: 7
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    policy: ScrollBar.AlwaysOn
                }
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10

                Connections {
                    target: QmlBridge
                    onAddSavedAddressToList: {
                        modelListViewAddresses.append({
                            savedAddressIDValue: dbID,
                            savedAddressNameValue: name,
                            savedAddressAddressValue: address,
                            savedAddressPaymentIDValue: paymentID
                        })
                    }
                }
            }
        }

        function show() {
            modelListViewAddresses.clear();
            QmlBridge.fillListSavedAddresses();
            dialogListAddresses.open();
        }
    }

    BusyIndicator {
        id: busyIndicatorSendTransaction
        anchors.centerIn: parent
        running: false
    }

    Connections {
        target: QmlBridge

        onDisplayPrivateKeys: {
            privateKeysDialog.show(filename, privateViewKey, privateSpendKey, walletAddress);            
        }

        onDisplaySeed: {
            seedDialog.show(filename, mnemonicSeed, walletAddress);            
        }

        onDisplaySyncingInfo: {
            textConnectionInfoSync.text = syncing;
            textConnectionInfo.text = syncingInfo;
        }

        onDisplayTotalBalance: {
            textBalanceValue.text = balance;
            textBalanceUSD.text = balanceUSD;
        }

        onDisplayAddress: {
            textAddress.text = address;
            textWalletName.text = wallet;
            textUSD.visible = displayFiatConversion;
            textBalanceUSD.visible = displayFiatConversion;
            textTransferAmountUSD.visible = displayFiatConversion;
            switchNumberTransactions.checked = false;
        }

        onDisplayFullBalanceInTransferAmount: {
            textInputTransferAmount.text = fullBalance;
        }

        onDisplayDefaultFee: {
            textInputTransferFee.text = fee;
        }

        onDisplayNodeFee: {
            rectangleTransfer.nodeFeeValue = nodeFee;
        }

        onClearTransferAmount: {
            textInputTransferAmount.clear();
            rectangleTransfer.transferAmount = "";
        }

        onAskForFusion: {
            dialogFusion.show();
        }

        onFinishedSendingTransaction: {
            rectangleMainWallet.stopWaiting();
        }
    }

    function clearData() {
        textInputTransferAddress.text = "";
        textInputTransferAmount.text = "";
        textInputTransferPaymentID.text = "";
    }

    function show() {
        walletScreen.visible = true
        walletScreen.state = "visible"
    }

    function hide() {
        walletScreen.state = ""
    }

    function startWaiting() {
        busyIndicatorSendTransaction.running = true;
        rectangleMainWallet.enabled = false;
    }

    function stopWaiting() {
        busyIndicatorSendTransaction.running = false;
        rectangleMainWallet.enabled = true;
    }

    states: State {
        name: "visible"
        PropertyChanges { target: walletScreen; x: 0 }
    }

    transitions: [
        Transition {
            from: ""
            PropertyAnimation {
                properties: "x"
                duration: 200
            }
        },
        Transition {
            from: "visible"
            PropertyAnimation {
                properties: "x"
                duration: 200
            }
            onRunningChanged: {
                if ((state == "") && (!running))
                    walletScreen.visible = false;
            }
        }
    ]
}
