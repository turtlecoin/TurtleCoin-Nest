// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: window

    property var windowWidth: 1060
    property var windowHeight: 755
    property var minWindowHeight: 500

    Material.accent: Material.Grey

    width: windowWidth
    height: windowHeight
    minimumWidth: windowWidth
    minimumHeight: minWindowHeight
    color: "#333333"
    title: "TurtleCoin Nest"
    visible: true

    Flickable{
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: windowWidth
        contentHeight: windowHeight
        width: parent.width
        height: parent.height

        ScrollBar.vertical: ScrollBar {
            width: 10
            anchors.right: parent.right
            anchors.rightMargin: 0
            policy: parent.height < windowHeight ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }

        OpenWallet {
            id: openWalletScreen
            anchors.fill: parent
        }

        Wallet {
            id: walletScreen
        }

        Settings {
            id: settingsScreen
        }
    }

    MessageDialog {
        id: dialogInfo
        title: ""
        text: ""
        standardButtons: StandardButton.Ok

        onAccepted: {
            dialogInfo.title = "";
            dialogInfo.text = "";
            dialogInfo.informativeText = "";
        }

        function show(title, mainText, informativeText) {
            dialogInfo.title = title;
            dialogInfo.text = mainText;
            dialogInfo.informativeText = informativeText;
            dialogInfo.open();
        }

        function showError(errorText, errorInformativeText) {
            dialogInfo.icon = StandardIcon.Warning;
            dialogInfo.show("Error", errorText, errorInformativeText);
        }
    }

    Connections {
        target: QmlBridge

        onDisplayErrorDialog: {
            dialogInfo.showError(errorText, errorInformativeText);
        }

        onDisplayInfoDialog: {
            dialogInfo.show(title, mainText, informativeText);
        }

        onDisplayOpenWalletScreen: {
            openWalletScreen.clearData();
            openWalletScreen.enabled = true;
            walletScreen.hide();
        }

        onDisplayMainWalletScreen: {
            walletScreen.clearData();
            walletScreen.show();
            openWalletScreen.enabled = false;
        }

        onDisplaySettingsScreen: {
            settingsScreen.show();
        }

        onHideSettingsScreen: {
            settingsScreen.hide();
        }
    }
}
