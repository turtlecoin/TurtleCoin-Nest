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

Dialog {
    id: dialogInfo
    title: "Info"
    standardButtons: StandardButton.Ok
    width: 900

    property string addressDev: "TRTLv3jzutiQwqHL3qFwsu5EVLWesxZr1AFQ4AuMR3SD56n3rkHDkwj79eKwvaiU1nYQWGydKoXM6fXyiiGKsPDnVCNXzNdusxx"
    property string websiteChat: "http://chat.turtlecoin.lol"
    property string versionNest: ""
    property string newVersionNestAvailable: ""
    property string urlNewVersionNest: ""

    Text {
        id: textNest
        text: "Nest"
        font.family: "Arial"
        font.pixelSize: 21
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: textVersion
        text: "v. " + versionNest
        font.family: "Arial"
        font.pixelSize: 13
        anchors.horizontalCenter: textNest.horizontalCenter
        anchors.top: textNest.bottom
        anchors.topMargin: 5
    }

    Rectangle {
        id: rectangleNewVersion
        width: parent.width
        height: 30
        anchors.horizontalCenter: textNest.horizontalCenter
        anchors.top: textVersion.bottom
        anchors.topMargin: 10
        color: "transparent"

        Text {
            id: textNewVersion
            text: "New version (v. " + newVersionNestAvailable + ") is available. Download here"
            font.family: "Arial"
            font.pixelSize: 13
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        Rectangle {
            id: buttonGoToNewVersion
            width: 25
            height: 28
            anchors.verticalCenter: textNewVersion.verticalCenter
            anchors.left: textNewVersion.right
            anchors.leftMargin: 15
            color: "transparent"
            Image {
                id: imageButtonGoToNewVersion
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "images/openLink.svg"
                antialiasing: true
            }
            ColorOverlay {
                anchors.fill: imageButtonGoToNewVersion
                source:imageButtonGoToNewVersion
                color:"#444444"
                antialiasing: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    QmlBridge.goToWebsite(urlNewVersionNest);
                }
            }
        }
    }

    Text {
        id: textDescriptionHelp
        text: "Need help?"
        font.family: "Arial"
        font.pixelSize: 13
        anchors.top: rectangleNewVersion.bottom
        anchors.topMargin: 30
    }

    Text {
        id: textHelp
        anchors.top: textDescriptionHelp.bottom
        anchors.topMargin: 10
        anchors.left: textDescriptionHelp.left
        anchors.leftMargin: 0
        text: "Ask the community on " + websiteChat
        leftPadding: 5
        font.family: "Arial"
        font.pixelSize: 13
        font.bold: true
    }

    Rectangle {
        id: buttonGoToChat
        width: 25
        height: 28
        anchors.verticalCenter: textHelp.verticalCenter
        anchors.left: textHelp.right
        anchors.leftMargin: 15
        color: "transparent"
        Image {
            id: imageButtonGoToChat
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/openLink.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonGoToChat
            source:imageButtonGoToChat
            color:"#444444"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.goToWebsite(websiteChat);
            }
        }
    }

    Text {
        id: textDescriptionDonate
        text: "Donate to support Nest's dev"
        font.family: "Arial"
        font.pixelSize: 13
        anchors.top: textHelp.bottom
        anchors.topMargin: 25
        anchors.left: textHelp.left
        anchors.leftMargin: 0
    }

    TextInput {
        id: textInputAddress
        anchors.top: textDescriptionDonate.bottom
        anchors.topMargin: 10
        anchors.left: textDescriptionDonate.left
        anchors.leftMargin: 0
        readOnly: true
        text: addressDev
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

    Rectangle {
        id: buttonCopyAddressDev
        width: 25
        height: 28
        anchors.verticalCenter: textInputAddress.verticalCenter
        anchors.left: textInputAddress.right
        anchors.leftMargin: 15
        color: "transparent"
        Image {
            id: imageButtonCopyAddressDev
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/copy.svg"
            antialiasing: true
        }
        ColorOverlay {
            anchors.fill: imageButtonCopyAddressDev
            source:imageButtonCopyAddressDev
            color:"#444444"
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QmlBridge.clickedButtonCopy(addressDev);
            }
        }
    }

    function show() {
        versionNest = QmlBridge.getVersion();
        newVersionNestAvailable = QmlBridge.getNewVersion();
        if (newVersionNestAvailable != "") {
            rectangleNewVersion.visible = true;
            urlNewVersionNest = QmlBridge.getNewVersionURL();
        } else {
            rectangleNewVersion.visible = false;
        }
        dialogInfo.open();
    }
}
