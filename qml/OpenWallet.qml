import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: rectangleOpenWallet
    anchors.fill: parent
    color: "transparent"

    Text {
        id: textOpenWalletDescr
        color: "#ffffff"
        text: "If you are new to TurtleCoin, choose \"Create a new wallet\"."
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 20
        font.pixelSize: 14
        verticalAlignment: Text.AlignBottom
        font.family: "Arial"
        font.bold: true
        horizontalAlignment: Text.AlignLeft
    }

    Rectangle {
        id: rectangleRadioButtonRemote
        color: "transparent"
        anchors.right: buttonSettings.right
        anchors.rightMargin: 60
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 400
        height: 74

        MyComboBox {
            id: comboBox
            sizeToContents: true
            model: [ "Local Blockchain", "public.turtlenode.io", "public.turtlenode.net" ]
            onAccepted: {
                if(currentIndex === 0) {
                    QmlBridge.choseRemote(false)
                }
                else {
                    QmlBridge.choseRemote(true)
                }
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
                infoDialog.show();
            }
        }
    }

    Rectangle {
        id: buttonSettings
        width: 33
        height: 33
        anchors.top: buttonInfo.top
        anchors.topMargin: 0
        anchors.right: buttonInfo.left
        anchors.rightMargin: 15
        color: "transparent"
        Image {
            id: imageButtonSettings
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/settings.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonSettings
            source:imageButtonSettings
            color:"white"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedSettingsButton()
            }
        }
    }

    Component {
        id: radioButtonStyle
        RadioButtonStyle {
            label: Text {
                color: "#ffffff"
                font.pixelSize: 14
                font.family: "Arial"
                text: control.text
                leftPadding: 10
                font.bold: control.checked
            }
        }
    }

    // section open existing wallet
    Rectangle {
        id: rectangleOpenExistingWallet
        color: "transparent"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: textOpenWalletDescr.bottom
        anchors.topMargin: 25
        height: 120
        radius: 7

        Text {
            id: textOpenExistingWalletDescr
            color: "#ffffff"
            text: "Open an existing wallet"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.bold: true
            font.pixelSize: 16
            font.family: "Arial"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
        }

        Text {
            id: textExistingWalletPathDescr
            color: "#ffffff"
            text: "Path to wallet file"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textOpenExistingWalletDescr.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 80
        }

        Rectangle {
            id: rectangleTextInputExistingWalletPath
            color: "#555555"
            height: 25
            width: 360
            anchors.top: textExistingWalletPathDescr.bottom
            anchors.topMargin: 15
            anchors.left: textExistingWalletPathDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputExistingWalletPath
                readOnly: true
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonOpenWallet.enabled = textInputExistingWalletPath.text != "" && textInputExistingWalletPassword.text != ""
                }
            }

            MouseArea {
                id: mouseAreaExistingWalletPath
                anchors.fill: parent
                onClicked: {
                    dialogChooseWalletFile.show();
                }
            }
        }

        Text {
            id: textExistingWalletPasswordDescr
            color: "#ffffff"
            text: "Password"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textExistingWalletPathDescr.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 520
        }

        Rectangle {
            id: rectangleTextInputExistingWalletPassword
            color: "#555555"
            height: 25
            width: 200
            anchors.top: rectangleTextInputExistingWalletPath.top
            anchors.topMargin: 0
            anchors.left: textExistingWalletPasswordDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputExistingWalletPassword
                echoMode: TextInput.Password
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonOpenWallet.enabled = textInputExistingWalletPath.text != "" && textInputExistingWalletPassword.text != ""
                }

                Keys.onReturnPressed: {
                    if (buttonOpenWallet.enabled) {
                        buttonOpenWallet.clicked();
                    }
                }
            }

        }

        Button {
            id: buttonOpenWallet
            text: "OPEN"
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            enabled: false

            contentItem: Text {
                text: buttonOpenWallet.text
                font.bold: true
                font.pointSize: 20
                font.family: "Arial"
                opacity: enabled ? 1.0 : 0.3
                color: buttonOpenWallet.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                implicitHeight: 60
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonOpenWallet.down ? "#383838" : "#444444"
            }

            onClicked: {
                busyIndicator.running = true
                QmlBridge.clickedButtonOpen(textInputExistingWalletPath.text, textInputExistingWalletPassword.text);
                textInputExistingWalletPassword.text = ""
            }
        }
    }

    // separator horizontal 1
    Rectangle {
        height: 2
        color: "#858585"
        anchors.top: rectangleOpenExistingWallet.bottom
        anchors.topMargin: 10
        anchors.left: rectangleOpenExistingWallet.left
        anchors.leftMargin: 30
        anchors.right: rectangleOpenExistingWallet.right
        anchors.rightMargin: 30
    }

    // section create new wallet
    Rectangle {
        id: rectangleCreateWallet
        color: "transparent"
        anchors.left: rectangleOpenExistingWallet.left
        anchors.leftMargin: 0
        anchors.right: rectangleOpenExistingWallet.right
        anchors.rightMargin: 0
        anchors.top: rectangleOpenExistingWallet.bottom
        anchors.topMargin: 20
        height: 160
        radius: 7

        Text {
            id: textCreateWalletDescr
            color: "#ffffff"
            text: "Create a new wallet"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.bold: true
            font.pixelSize: 16
            font.family: "Arial"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
        }

        Text {
            id: textCreateWalletFilenameDescr
            color: "#ffffff"
            text: "Choose a filename for your new wallet file"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textCreateWalletDescr.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 80
        }

        Rectangle {
            id: rectangleTextInputCreateWalletFilename
            color: "#555555"
            height: 25
            width: 200
            anchors.top: textCreateWalletFilenameDescr.bottom
            anchors.topMargin: 15
            anchors.left: textCreateWalletFilenameDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputCreateWalletFilename
                anchors.fill: parent
                color: "#cfcfcf"
                text: "myFirstTRTLWallet"
                rightPadding: 5
                leftPadding: 5
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonCreateWallet.enabled = textInputCreateWalletFilename.text != "" && textInputCreateWalletPassword.text != ""
                }
            }
        }

        Text {
            id: textCreateWalletFilename
            color: "#999999"
            text: textInputCreateWalletFilename.text + ".wallet"
            anchors.verticalCenter: rectangleTextInputCreateWalletFilename.verticalCenter
            anchors.left: rectangleTextInputCreateWalletFilename.right
            anchors.leftMargin: 20
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textCreateWalletExtensionDescr
            color: "#999999"
            text: "Do not include any extension. Avoid spaces."
            anchors.top: rectangleTextInputCreateWalletFilename.bottom
            anchors.topMargin: 8
            anchors.left: rectangleTextInputCreateWalletFilename.left
            anchors.leftMargin: 0
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textCreateWalletLocation
            color: "#999999"
            text: ""
            anchors.top: textCreateWalletExtensionDescr.bottom
            anchors.topMargin: 2
            anchors.left: textCreateWalletExtensionDescr.left
            anchors.leftMargin: 0
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textCreateWalletPasswordDescr
            color: "#ffffff"
            text: "Choose a strong password"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textCreateWalletFilenameDescr.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 520
        }

        Rectangle {
            id: rectangleTextInputCreateWalletPassword
            color: "#555555"
            height: 25
            width: 200
            anchors.top: rectangleTextInputCreateWalletFilename.top
            anchors.topMargin: 0
            anchors.left: textCreateWalletPasswordDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputCreateWalletPassword
                echoMode: TextInput.Password
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    buttonCreateWallet.enabled = textInputCreateWalletFilename.text != "" && textInputCreateWalletPassword.text != ""
                }

                Keys.onReturnPressed: {
                    if (buttonCreateWallet.enabled) {
                        buttonCreateWallet.clicked();
                    }
                }
            }
        }

        Button {
            id: buttonCreateWallet
            text: "CREATE"
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            enabled: false

            contentItem: Text {
                text: buttonCreateWallet.text
                font.bold: true
                font.pointSize: 20
                font.family: "Arial"
                opacity: enabled ? 1.0 : 0.3
                color: buttonOpenWallet.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                implicitHeight: 60
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonCreateWallet.down ? "#383838" : "#444444"
            }

            onClicked: {
                dialogConfirmPassword.show(false);
            }
        }

        function enteredPasswordConfirmation(passwordConfirmation) {
            busyIndicator.running = true;
            QmlBridge.clickedButtonCreate(textCreateWalletFilename.text, textInputCreateWalletPassword.text, passwordConfirmation);
            textInputCreateWalletPassword.text = "";
        }
    }

    // separator horizontal 2
    Rectangle {
        height: 2
        color: "#858585"
        anchors.top: rectangleCreateWallet.bottom
        anchors.topMargin: 10
        anchors.left: rectangleOpenExistingWallet.left
        anchors.leftMargin: 30
        anchors.right: rectangleOpenExistingWallet.right
        anchors.rightMargin: 30
    }

    // section import wallet from keys
    Rectangle {
        id: rectangleImportWalletFromKeys
        color: "transparent"
        anchors.left: rectangleOpenExistingWallet.left
        anchors.leftMargin: 0
        anchors.right: rectangleOpenExistingWallet.right
        anchors.rightMargin: 0
        anchors.top: rectangleCreateWallet.bottom
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        radius: 7

        Text {
            id: textImportWalletDescr
            color: "#ffffff"
            text: "Import wallet"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.bold: true
            font.pixelSize: 16
            font.family: "Arial"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
        }

        Text {
            id: textSwitchImportFromSeed
            color: !switchImportFrom.checked ? "#ffffff" : "#cfcfcf"
            text: "from seed"
            anchors.right: switchImportFrom.left
            anchors.rightMargin: 4
            anchors.verticalCenter: textImportWalletDescr.verticalCenter
            font.family: "Arial"
            font.pixelSize: 14
            font.bold: !switchImportFrom.checked
            horizontalAlignment: Text.AlignRight
        }

        Switch {
            id: switchImportFrom
            anchors.left: textImportWalletDescr.right
            anchors.leftMargin: 105
            anchors.verticalCenter: textImportWalletDescr.verticalCenter
            checked: false

            onClicked: {
                rectangleImportWalletFromKeys.displayOrHideSeedAndPrivateKeys(!checked);
            }
        }

        Text {
            id: textSwitchImportFromKeys
            color: switchImportFrom.checked ? "#ffffff" : "#cfcfcf"
            text: "from private keys"
            anchors.left: switchImportFrom.right
            anchors.leftMargin: 4
            anchors.verticalCenter: textImportWalletDescr.verticalCenter
            font.family: "Arial"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignLeft
            font.bold: switchImportFrom.checked
        }

        Text {
            id: textImportWalletFilenameDescr
            color: "#ffffff"
            text: "Choose a filename for your new wallet file"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textImportWalletDescr.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 80
        }

        Rectangle {
            id: rectangleTextInputImportWalletFilename
            color: "#555555"
            height: 25
            width: 200
            anchors.top: textImportWalletFilenameDescr.bottom
            anchors.topMargin: 15
            anchors.left: textImportWalletFilenameDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputImportWalletFilename
                anchors.fill: parent
                color: "#cfcfcf"
                text: "myTRTLWallet"
                rightPadding: 5
                leftPadding: 5
                selectionColor: "#eeeeee"
                selectedTextColor: "#999999"
                selectByMouse: true
                clip: true
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    rectangleImportWalletFromKeys.checkEnableButton()
                }
            }
        }

        Text {
            id: textImportWalletFilename
            color: "#999999"
            text: textInputImportWalletFilename.text + ".wallet"
            anchors.verticalCenter: rectangleTextInputImportWalletFilename.verticalCenter
            anchors.left: rectangleTextInputImportWalletFilename.right
            anchors.leftMargin: 20
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textImportWalletExtensionDescr
            color: "#999999"
            text: "Do not include any extension. Avoid spaces."
            anchors.top: rectangleTextInputImportWalletFilename.bottom
            anchors.topMargin: 8
            anchors.left: rectangleTextInputImportWalletFilename.left
            anchors.leftMargin: 0
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textImportWalletLocation
            color: "#999999"
            text: ""
            anchors.top: textImportWalletExtensionDescr.bottom
            anchors.topMargin: 2
            anchors.left: textImportWalletExtensionDescr.left
            anchors.leftMargin: 0
            font.pixelSize: 13
            verticalAlignment: Text.AlignBottom
            font.family: "Arial"
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: textImportWalletPasswordDescr
            color: "#ffffff"
            text: "Choose a strong password"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textImportWalletFilenameDescr.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 520
        }

        Rectangle {
            id: rectangleTextInputImportWalletPassword
            color: "#555555"
            height: 25
            width: 200
            anchors.top: rectangleTextInputImportWalletFilename.top
            anchors.topMargin: 0
            anchors.left: textImportWalletPasswordDescr.left
            anchors.leftMargin: 0
            radius: 3

            TextInput {
                id: textInputImportWalletPassword
                echoMode: TextInput.Password
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    rectangleImportWalletFromKeys.checkEnableButton()
                }
            }
        }

        Text {
            id: textImportWalletSeedDescr
            color: "#ffffff"
            text: "Seed (25 words)"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textImportWalletExtensionDescr.bottom
            anchors.topMargin: 30
            anchors.left: textImportWalletExtensionDescr.left
            anchors.leftMargin: 0
        }

        Rectangle {
            id: rectangleTextInputImportWalletSeed
            color: "#555555"
            height: 25
            anchors.top: textImportWalletSeedDescr.bottom
            anchors.topMargin: 15
            anchors.left: textImportWalletSeedDescr.left
            anchors.leftMargin: 0
            anchors.right: rectangleTextInputImportWalletPassword.right
            anchors.rightMargin: 0
            radius: 3

            TextInput {
                id: textInputImportWalletSeed
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    rectangleImportWalletFromKeys.checkEnableButton()
                }
            }
        }

        Text {
            id: textImportWalletPrivateViewKeyDescr
            color: "#ffffff"
            text: "Private view key"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: textImportWalletExtensionDescr.bottom
            anchors.topMargin: 30
            anchors.left: textImportWalletExtensionDescr.left
            anchors.leftMargin: 0
            visible: false
        }

        Rectangle {
            id: rectangleTextInputImportWalletPrivateViewKey
            color: "#555555"
            height: 25
            anchors.top: textImportWalletPrivateViewKeyDescr.bottom
            anchors.topMargin: 15
            anchors.left: textImportWalletPrivateViewKeyDescr.left
            anchors.leftMargin: 0
            anchors.right: rectangleTextInputImportWalletPassword.right
            anchors.rightMargin: 0
            visible: false
            radius: 3

            TextInput {
                id: textInputImportWalletPrivateViewKey
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                enabled: false

                onTextChanged: {
                    rectangleImportWalletFromKeys.checkEnableButton()
                }
            }
        }

        Text {
            id: textImportWalletPrivateSpendKeyDescr
            color: "#ffffff"
            text: "Private spend key"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.family: "Arial"
            anchors.top: rectangleTextInputImportWalletPrivateViewKey.bottom
            anchors.topMargin: 20
            anchors.left: rectangleTextInputImportWalletPrivateViewKey.left
            anchors.leftMargin: 0
            visible: false
        }

        Rectangle {
            id: rectangleTextInputImportWalletPrivateSpendKey
            color: "#555555"
            height: 25
            anchors.top: textImportWalletPrivateSpendKeyDescr.bottom
            anchors.topMargin: 15
            anchors.left: textImportWalletPrivateSpendKeyDescr.left
            anchors.leftMargin: 0
            anchors.right: rectangleTextInputImportWalletPrivateViewKey.right
            anchors.rightMargin: 0
            visible: false
            radius: 3

            TextInput {
                id: textInputImportWalletPrivateSpendKey
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
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                enabled: false

                onTextChanged: {
                    rectangleImportWalletFromKeys.checkEnableButton()
                }
            }
        }

        Button {
            id: buttonImportWallet
            text: "IMPORT"
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.bottom: rectangleTextInputImportWalletPrivateSpendKey.bottom
            anchors.bottomMargin: 0
            enabled: false

            contentItem: Text {
                text: buttonImportWallet.text
                font.bold: true
                font.pointSize: 20
                font.family: "Arial"
                opacity: enabled ? 1.0 : 0.3
                color: buttonImportWallet.down ? "#dddddd" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                implicitHeight: 60
                opacity: enabled ? 1 : 0.3
                radius: 6
                color: buttonImportWallet.down ? "#383838" : "#444444"
            }

            onClicked: {
                dialogConfirmPassword.show(true);
            }
        }

        function checkEnableButton() {
            if (!switchImportFrom.checked) {
                buttonImportWallet.enabled = textInputImportWalletFilename.text != "" && textInputImportWalletPassword.text != "" && textInputImportWalletSeed.text != ""
            } else {
                buttonImportWallet.enabled = textInputImportWalletFilename.text != "" && textInputImportWalletPassword.text != "" && textInputImportWalletPrivateViewKey.text != "" && textInputImportWalletPrivateSpendKey.text != ""
            }
        }

        function enteredPasswordConfirmation(passwordConfirmation) {
            busyIndicator.running = true;
            QmlBridge.clickedButtonImport(textImportWalletFilename.text, textInputImportWalletPassword.text, textInputImportWalletPrivateViewKey.text, textInputImportWalletPrivateSpendKey.text, textInputImportWalletSeed.text, passwordConfirmation);
            textInputImportWalletPassword.text = "";
        }

        function displayOrHideSeedAndPrivateKeys(displaySeed) {
            textImportWalletSeedDescr.visible = displaySeed
            rectangleTextInputImportWalletSeed.visible = displaySeed
            textInputImportWalletSeed.text = ""
            textInputImportWalletSeed.enabled = displaySeed

            textImportWalletPrivateViewKeyDescr.visible = !displaySeed
            rectangleTextInputImportWalletPrivateViewKey.visible = !displaySeed
            textInputImportWalletPrivateViewKey.text = ""
            textInputImportWalletPrivateViewKey.enabled = !displaySeed

            textImportWalletPrivateSpendKeyDescr.visible = !displaySeed
            rectangleTextInputImportWalletPrivateSpendKey.visible = !displaySeed
            textInputImportWalletPrivateSpendKey.text = ""
            textInputImportWalletPrivateSpendKey.enabled = !displaySeed
        } 
    }

    FileDialog {
        id: dialogChooseWalletFile
        title: "Please select your wallet file"
        visible: false
        onAccepted: {
            textInputExistingWalletPath.text = dialogChooseWalletFile.fileUrl
        }
        
        function show() {
            dialogChooseWalletFile.open()
        }
    }

    Dialog {
        id: dialogConfirmPassword
        title: "Confirm password"
        standardButtons: StandardButton.Cancel | StandardButton.Ok
        width: 250
        height: 120

        property var walletIsImporting: false

        Text {
            id: textDescriptionConfirmPassword
            text: "Re-type your new password:"
            font.family: "Arial"
        }

        Rectangle {
            id: rectangleTextInputConfirmPassword
            color: "#bbbbbb"
            height: 25
            anchors.top: textDescriptionConfirmPassword.bottom
            anchors.topMargin: 12
            anchors.left: textDescriptionConfirmPassword.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            radius: 3

            TextInput {
                id: textInputConfirmPassword
                echoMode: TextInput.Password
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

        function show(isImporting) {
            walletIsImporting = isImporting;
            dialogConfirmPassword.open();
            textInputConfirmPassword.text = "";
            textInputConfirmPassword.focus = true;
        }

        onAccepted: {
            if (walletIsImporting) {
                rectangleImportWalletFromKeys.enteredPasswordConfirmation(textInputConfirmPassword.text)
            } else {
                rectangleCreateWallet.enteredPasswordConfirmation(textInputConfirmPassword.text)
            }
        }
    }

    InfoDialog {
        id: infoDialog
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    Connections {
        target: QmlBridge

        onFinishedLoadingWalletd: {
            busyIndicator.running = false
        }

        onFinishedCreatingWallet: {
            busyIndicator.running = false
        }

        onDisplayPathToPreviousWallet: {
            textInputExistingWalletPath.text = pathToPreviousWallet
        }

        onDisplayWalletCreationLocation: {
            textCreateWalletLocation.text = walletLocation;
            textImportWalletLocation.text = walletLocation;
        }

        onDisplayUseRemoteNode: {
            radioButtonUseLocal.checked = !useRemote;
            radioButtonUseRemoteNode.checked = useRemote;
            radioButtonUseRemoteNode.text = remoteNodeDescr;
        }

        onDisplayInfoDialog: {
            infoDialog.show();
        }
    }

    function clearData() {
        textInputImportWalletPrivateViewKey.text = "";
        textInputImportWalletPrivateSpendKey.text = "";
    }
}
