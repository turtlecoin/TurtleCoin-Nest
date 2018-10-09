// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Item {
    id: itemListAddress
    visible: true

    property int dbID: savedAddressIDValue

    Rectangle {
        color: "#2b2b2b"
        radius: 4
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 9

        Text {
            id: savedAddressName
            color: "#ffffff"
            text: savedAddressNameValue
            elide: Text.ElideRight
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: buttonDeleteSavedAddress.left
            anchors.rightMargin: 5
            font.family: "Arial"
            font.bold: true
            font.pixelSize: 15
        }

        Text {
            id: savedAddressAddressDescr
            color: "#cfcfcf"
            text: "addr.:"
            anchors.left: savedAddressName.left
            anchors.leftMargin: 0
            anchors.top: savedAddressName.bottom
            anchors.topMargin: 5
            font.family: "Arial"
            font.pixelSize: 13
        }

        Text {
            id: savedAddressAddress
            color: "#ffffff"
            text: savedAddressAddressValue
            elide: Text.ElideMiddle
            anchors.bottom: savedAddressAddressDescr.bottom
            anchors.bottomMargin: 0
            anchors.left: savedAddressAddressDescr.right
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            font.family: "Arial"
            font.pixelSize: 13
        }

        Text {
            id: savedAddressPaymentIDDescr
            color: "#cfcfcf"
            text: "payment ID:"
            anchors.left: savedAddressAddressDescr.left
            anchors.leftMargin: 0
            anchors.top: savedAddressAddressDescr.bottom
            anchors.topMargin: 5
            font.family: "Arial"
            font.pixelSize: 13
        }

        Text {
            id: savedAddressPaymentID
            color: "#ffffff"
            text: savedAddressPaymentIDValue
            elide: Text.ElideMiddle
            anchors.bottom: savedAddressPaymentIDDescr.bottom
            anchors.bottomMargin: 0
            anchors.left: savedAddressPaymentIDDescr.right
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            font.family: "Arial"
            font.pixelSize: 13
        }

        Rectangle {
            id: buttonDeleteSavedAddress
            width: 17
            height: 17
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            color: "transparent"
            Image {
                id: imageButtonDeleteSavedAddress
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "images/close.svg"
                antialiasing: true
            }
            ColorOverlay {
                anchors.fill: imageButtonDeleteSavedAddress
                source:imageButtonDeleteSavedAddress
                color:"white"
                antialiasing: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    clickedDeleteSavedAddress(dbID);
                }
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: buttonDeleteSavedAddress.left
            anchors.rightMargin: 5
            onClicked: {
                clickedSavedAddress(savedAddressAddressValue, savedAddressPaymentIDValue);
            }
        }
    }
}
