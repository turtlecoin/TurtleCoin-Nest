// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

package main

import (
	"TurtleCoin-Nest/walletdmanager"

	"github.com/atotto/clipboard"
	_ "github.com/mattn/go-sqlite3"
	log "github.com/sirupsen/logrus"
	"github.com/therecipe/qt/core"
)

var (
	// qmlObjects = make(map[string]*core.QObject)
	qmlBridge *QmlBridge
)

// QmlBridge is the bridge between qml and go
type QmlBridge struct {
	core.QObject

	// go to qml
	_ func(balance string,
		balanceUSD string) `signal:"displayTotalBalance"`
	_ func(data string) `signal:"displayAvailableBalance"`
	_ func(data string) `signal:"displayLockedBalance"`
	_ func(address string,
		wallet string,
		displayFiatConversion bool) `signal:"displayAddress"`
	_ func(paymentID string,
		transactionID string,
		amount string,
		confirmations string,
		time string,
		number string) `signal:"addTransactionToList"`
	_ func(nodeName string)                    `signal:"addRemoteNodeToList"`
	_ func(index int, newText string)          `signal:"changeTextRemoteNode"`
	_ func(index int)                          `signal:"setSelectedRemoteNode"`
	_ func(text string, time int)              `signal:"displayPopup"`
	_ func(syncing string, syncingInfo string) `signal:"displaySyncingInfo"`
	_ func(errorText string,
		errorInformativeText string) `signal:"displayErrorDialog"`
	_ func(title string,
		mainText string,
		informativeText string) `signal:"displayInfoDialog"`
	_ func() `signal:"clearTransferAmount"`
	_ func() `signal:"askForFusion"`
	_ func() `signal:"clearListTransactions"`
	_ func(filename string,
		privateViewKey string,
		privateSpendKey string,
		walletAddress string) `signal:"displayPrivateKeys"`
	_ func(filename string,
		mnemonicSeed string,
		walletAddress string) `signal:"displaySeed"`
	_ func()                            `signal:"displayOpenWalletScreen"`
	_ func()                            `signal:"displayMainWalletScreen"`
	_ func()                            `signal:"finishedLoadingWalletd"`
	_ func()                            `signal:"finishedCreatingWallet"`
	_ func()                            `signal:"finishedSendingTransaction"`
	_ func(pathToPreviousWallet string) `signal:"displayPathToPreviousWallet"`
	_ func(walletLocation string)       `signal:"displayWalletCreationLocation"`
	_ func(useRemote bool)              `signal:"displayUseRemoteNode"`
	_ func()                            `signal:"hideSettingsScreen"`
	_ func()                            `signal:"displaySettingsScreen"`
	_ func(displayFiat bool)            `signal:"displaySettingsValues"`
	_ func(remoteNodeAddress string,
		remoteNodePort string) `signal:"displaySettingsRemoteDaemonInfo"`
	_ func(fullBalance string)              `signal:"displayFullBalanceInTransferAmount"`
	_ func(fee string)                      `signal:"displayDefaultFee"`
	_ func(nodeFee string)                  `signal:"displayNodeFee"`
	_ func(index int, confirmations string) `signal:"updateConfirmationsOfTransaction"`
	_ func()                                `signal:"displayInfoScreen"`
	_ func(dbID int,
		name string,
		address string,
		paymentID string) `signal:"addSavedAddressToList"`

	// qml to go
	_ func(msg string)           `slot:"log"`
	_ func(transactionID string) `slot:"clickedButtonExplorer"`
	_ func(url string)           `slot:"goToWebsite"`
	_ func(transactionID string) `slot:"clickedButtonCopyTx"`
	_ func()                     `slot:"clickedButtonCopyAddress"`
	_ func()                     `slot:"clickedButtonCopyKeys"`
	_ func(stringToCopy string)  `slot:"clickedButtonCopy"`
	_ func(transferAddress string,
		transferAmount string,
		transferPaymentID string,
		transferFee string) `slot:"clickedButtonSend"`
	_ func()                                           `slot:"clickedButtonBackupWallet"`
	_ func()                                           `slot:"clickedCloseWallet"`
	_ func(pathToWallet string, passwordWallet string) `slot:"clickedButtonOpen"`
	_ func(filenameWallet string,
		passwordWallet string,
		confirmPasswordWallet string) `slot:"clickedButtonCreate"`
	_ func(filenameWallet string,
		passwordWallet string,
		privateViewKey string,
		privateSpendKey string,
		mnemonicSeed string,
		confirmPasswordWallet string,
		scanHeight string) `slot:"clickedButtonImport"`
	_ func(remote bool)              `slot:"choseRemote"`
	_ func(index int)                `slot:"selectedRemoteNode"`
	_ func(amountTRTL string) string `slot:"getTransferAmountUSD"`
	_ func()                         `slot:"clickedCloseSettings"`
	_ func()                         `slot:"clickedSettingsButton"`
	_ func(displayFiat bool)         `slot:"choseDisplayFiat"`
	_ func(checkpoints bool)         `slot:"choseCheckpoints"`
	_ func(daemonAddress string,
		daemonPort string) `slot:"saveRemoteDaemonInfo"`
	_ func()                   `slot:"resetRemoteDaemonInfo"`
	_ func(transferFee string) `slot:"getFullBalanceAndDisplayInTransferAmount"`
	_ func()                   `slot:"getDefaultFeeAndDisplay"`
	_ func(limit bool)         `slot:"limitDisplayTransactions"`
	_ func() string            `slot:"getVersion"`
	_ func() string            `slot:"getNewVersion"`
	_ func() string            `slot:"getNewVersionURL"`
	_ func()                   `slot:"optimizeWalletWithFusion"`
	_ func(name string,
		address string,
		paymentID string) `slot:"saveAddress"`
	_ func()         `slot:"fillListSavedAddresses"`
	_ func(dbID int) `slot:"deleteSavedAddress"`
	_ func()         `slot:"exportListTransactions"`

	_ func(object *core.QObject) `slot:"registerToGo"`
	_ func(objectName string)    `slot:"deregisterToGo"`
}

func connectQMLToGOFunctions() {

	qmlBridge.ConnectLog(func(msg string) {
		log.Info("QML: ", msg)
	})

	qmlBridge.ConnectClickedButtonCopyAddress(func() {
		clipboard.WriteAll(walletdmanager.WalletAddress)
		qmlBridge.DisplayPopup("Copied!", 1500)
	})

	qmlBridge.ConnectClickedButtonCopyKeys(func() {
		clipboard.WriteAll(stringBackupKeys)
	})

	qmlBridge.ConnectClickedButtonCopy(func(stringToCopy string) {
		clipboard.WriteAll(stringToCopy)
	})

	qmlBridge.ConnectClickedButtonCopyTx(func(transactionID string) {
		clipboard.WriteAll(transactionID)
		qmlBridge.DisplayPopup("Copied!", 1500)
	})

	qmlBridge.ConnectClickedButtonExplorer(func(transactionID string) {
		url := urlBlockExplorer + "?hash=" + transactionID + "#blockchain_transaction"
		successOpenBrowser := openBrowser(url)
		if !successOpenBrowser {
			log.Error("failure opening browser, url: " + url)
		}
	})

	qmlBridge.ConnectGoToWebsite(func(url string) {
		successOpenBrowser := openBrowser(url)
		if !successOpenBrowser {
			log.Error("failure opening browser, url: " + url)
		}
	})

	qmlBridge.ConnectClickedButtonSend(func(transferAddress string, transferAmount string, transferPaymentID string, transferFee string) {
		go func() {
			transfer(transferAddress, transferAmount, transferPaymentID, transferFee)
		}()
	})

	qmlBridge.ConnectGetTransferAmountUSD(func(amountTRTL string) string {
		return amountStringUSDToTRTL(amountTRTL)
	})

	qmlBridge.ConnectClickedButtonBackupWallet(func() {
		showWalletPrivateInfo()
	})

	qmlBridge.ConnectClickedButtonOpen(func(pathToWallet string, passwordWallet string) {
		go func() {
			recordPathWalletToDB(pathToWallet)
			startWalletWithWalletInfo(pathToWallet, passwordWallet)
		}()
	})

	qmlBridge.ConnectClickedButtonCreate(func(filenameWallet string, passwordWallet string, confirmPasswordWallet string) {
		go func() {
			createWalletWithWalletInfo(filenameWallet, passwordWallet, confirmPasswordWallet)
		}()
	})

	qmlBridge.ConnectClickedButtonImport(func(filenameWallet string, passwordWallet string, privateViewKey string, privateSpendKey string, mnemonicSeed string, confirmPasswordWallet string, scanHeight string) {
		go func() {
			importWalletWithWalletInfo(filenameWallet, passwordWallet, confirmPasswordWallet, privateViewKey, privateSpendKey, mnemonicSeed, scanHeight)
		}()
	})

	qmlBridge.ConnectClickedCloseWallet(func() {
		closeWallet()
	})

	qmlBridge.ConnectChoseRemote(func(remote bool) {
		useRemoteNode = remote
		recordUseRemoteToDB(useRemoteNode)
	})

	qmlBridge.ConnectSelectedRemoteNode(func(index int) {
		indexSelectedRemoteNode = index

		node := remoteNodes[indexSelectedRemoteNode]
		recordSelectedRemoteDaemonToDB(node)
	})

	qmlBridge.ConnectClickedCloseSettings(func() {
		qmlBridge.HideSettingsScreen()
	})

	qmlBridge.ConnectClickedSettingsButton(func() {
		qmlBridge.DisplaySettingsScreen()
	})

	qmlBridge.ConnectChoseDisplayFiat(func(displayFiat bool) {
		displayFiatConversion = displayFiat
		recordDisplayConversionToDB(displayFiat)
	})

	qmlBridge.ConnectChoseCheckpoints(func(checkpoints bool) {
		useCheckpoints = checkpoints
	})

	qmlBridge.ConnectSaveRemoteDaemonInfo(func(daemonAddress string, daemonPort string) {
		saveRemoteDaemonInfo(daemonAddress, daemonPort)
	})

	qmlBridge.ConnectResetRemoteDaemonInfo(func() {
		saveRemoteDaemonInfo(defaultRemoteDaemonAddress, defaultRemoteDaemonPort)
		qmlBridge.DisplaySettingsRemoteDaemonInfo(defaultRemoteDaemonAddress, defaultRemoteDaemonPort)
	})

	qmlBridge.ConnectGetFullBalanceAndDisplayInTransferAmount(func(transferFee string) {
		getFullBalanceAndDisplayInTransferAmount(transferFee)
	})

	qmlBridge.ConnectLimitDisplayTransactions(func(limit bool) {
		limitDisplayedTransactions = limit
		getAndDisplayListTransactions(true)
	})

	qmlBridge.ConnectGetVersion(func() string {
		return versionNest
	})

	qmlBridge.ConnectGetNewVersion(func() string {
		return newVersionAvailable
	})

	qmlBridge.ConnectGetNewVersionURL(func() string {
		return urlNewVersion
	})

	qmlBridge.ConnectOptimizeWalletWithFusion(func() {
		go func() {
			optimizeWalletWithFusion()
		}()
	})

	qmlBridge.ConnectSaveAddress(func(name string, address string, paymentID string) {
		saveAddress(name, address, paymentID)
	})

	qmlBridge.ConnectFillListSavedAddresses(func() {
		getSavedAddressesFromDBAndDisplay()
	})

	qmlBridge.ConnectDeleteSavedAddress(func(dbID int) {
		deleteSavedAddressFromDB(dbID)
	})

	qmlBridge.ConnectExportListTransactions(func() {
		exportListTransactions()
	})
}
