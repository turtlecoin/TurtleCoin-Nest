// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

package main

import (
	"TurtleCoin-Nest/turtlecoinwalletdrpcgo"
	"TurtleCoin-Nest/walletdmanager"
	"encoding/csv"
	"encoding/json"
	"io"
	"io/ioutil"
	"math"
	"net/http"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/dustin/go-humanize"
	_ "github.com/mattn/go-sqlite3"
	log "github.com/sirupsen/logrus"
	"github.com/therecipe/qt/core"
	"github.com/therecipe/qt/gui"
	"github.com/therecipe/qt/qml"
	"github.com/therecipe/qt/quickcontrols2"
)

var (
	transfers                   []turtlecoinwalletdrpcgo.Transfer
	remoteNodes                 []node
	indexSelectedRemoteNode     = 0
	tickerRefreshWalletData     *time.Ticker
	tickerRefreshConnectionInfo *time.Ticker
	tickerRefreshNodeFeeInfo    *time.Ticker
	tickerSaveWallet            *time.Ticker
	useRemoteNode               = true
	useCheckpoints              = true
	displayFiatConversion       = false
	stringBackupKeys            = ""
	rateUSDTRTL                 float64 // USD value for 1 TRTL
	customRemoteDaemonAddress   = defaultRemoteDaemonAddress
	customRemoteDaemonPort      = defaultRemoteDaemonPort
	limitDisplayedTransactions  = true
	countConnectionProblem      = 0
	newVersionAvailable         = ""
	urlNewVersion               = ""
)

func main() {

	logsFolder := "logs"

	pathToLogFile := ""
	if isPlatformWindows {
		pathToLogFile = logsFolder + "\\" + logFileFilename
	} else {
		pathToLogFile = logsFolder + "/" + logFileFilename
	}
	pathToDB := dbFilename
	pathToHomeDir := ""
	pathToAppDirectory, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Fatal("error finding current directory. Error: ", err)
	}

	if isPlatformDarwin {
		// mac
		usr, err := user.Current()
		if err != nil {
			log.Fatal(err)
		}
		pathToHomeDir = usr.HomeDir
		pathToAppFolder := pathToHomeDir + "/Library/Application Support/TurtleCoin-Nest"
		os.Mkdir(pathToAppFolder, os.ModePerm)
		pathToDB = pathToAppFolder + "/" + pathToDB

		pathToLogsFolder := pathToAppFolder + "/" + logsFolder
		os.Mkdir(pathToLogsFolder, os.ModePerm)
		pathToLogFile = pathToAppFolder + "/" + pathToLogFile
	} else {
		// win and linux
		pathToLogsFolder := ""

		if isPlatformLinux {
			// linux
			pathToLogsFolder = pathToAppDirectory + "/" + logsFolder
			pathToLogFile = pathToAppDirectory + "/" + pathToLogFile
			pathToDB = pathToAppDirectory + "/" + pathToDB
		} else if isPlatformWindows {
			// win
			pathToLogsFolder = pathToAppDirectory + "\\" + logsFolder
		}

		os.Mkdir(pathToLogsFolder, os.ModePerm)
	}

	logFile, err := os.OpenFile(pathToLogFile, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0600)
	if err != nil {
		log.Fatal("error opening log file: ", err)
	}
	defer logFile.Close()

	if isPlatformLinux {
		// log to file and console
		mw := io.MultiWriter(os.Stdout, logFile)
		log.SetOutput(mw)
	} else {
		log.SetOutput(logFile)
	}

	log.SetLevel(log.DebugLevel)

	setupDB(pathToDB)

	log.WithField("version", versionNest).Info("Application started")

	go func() {
		requestRateTRTL()
	}()

	platform := "linux"
	if isPlatformDarwin {
		platform = "darwin"
	} else if isPlatformWindows {
		platform = "windows"
	}
	walletdmanager.Setup(platform)

	if isPlatformWindows {
		// for scaling on windows high res screens
		core.QCoreApplication_SetAttribute(core.Qt__AA_EnableHighDpiScaling, true)
	}

	app := gui.NewQGuiApplication(len(os.Args), os.Args)
	app.SetWindowIcon(gui.NewQIcon5("qrc:/qml/images/icon.png"))

	quickcontrols2.QQuickStyle_SetStyle("material")

	engine := qml.NewQQmlApplicationEngine(nil)
	engine.Load(core.NewQUrl3("qrc:/qml/nestmain.qml", 0))

	qmlBridge = NewQmlBridge(nil)

	connectQMLToGOFunctions()

	engine.RootContext().SetContextProperty("QmlBridge", qmlBridge)

	if isPlatformDarwin {
		textLocation := "Your wallet will be saved in your home directory: " + pathToHomeDir + "/"
		qmlBridge.DisplayWalletCreationLocation(textLocation)
	}

	getAndDisplayStartInfoFromDB()

	go func() {
		getAndDisplayListRemoteNodes()
	}()

	go func() {
		newVersionAvailable, urlNewVersion = checkIfNewReleaseAvailableOnGithub(versionNest)
		if newVersionAvailable != "" {
			qmlBridge.DisplayInfoScreen()
		}
	}()

	gui.QGuiApplication_Exec()

	log.Info("Application closed")

	walletdmanager.GracefullyQuitWalletd()
	walletdmanager.GracefullyQuitTurtleCoind()
}

func startDisplayWalletInfo() {

	getAndDisplayBalances()
	getAndDisplayAddress()
	getAndDisplayListTransactions(true)
	getAndDisplayConnectionInfo()
	getDefaultFeeAndDisplay()
	getNodeFeeAndDisplay()

	go func() {
		tickerRefreshWalletData = time.NewTicker(time.Second * 30)
		for range tickerRefreshWalletData.C {
			getAndDisplayBalances()
			getAndDisplayListTransactions(false)
		}
	}()

	go func() {
		tickerRefreshConnectionInfo = time.NewTicker(time.Second * 5)
		for range tickerRefreshConnectionInfo.C {
			getAndDisplayConnectionInfo()
		}
	}()

	go func() {
		tickerRefreshNodeFeeInfo = time.NewTicker(time.Second * 15)
		for range tickerRefreshNodeFeeInfo.C {
			getNodeFeeAndDisplay()
		}
	}()

	go func() {
		tickerSaveWallet = time.NewTicker(time.Second * 289) // every 5 or so minutes
		for range tickerSaveWallet.C {
			walletdmanager.SaveWallet()
		}
	}()
}

func getAndDisplayBalances() {

	walletAvailableBalance, walletLockedBalance, walletTotalBalance, err := walletdmanager.RequestBalance()
	if err == nil {
		qmlBridge.DisplayAvailableBalance(humanize.FormatFloat("#,###.##", walletAvailableBalance))
		qmlBridge.DisplayLockedBalance(humanize.FormatFloat("#,###.##", walletLockedBalance))
		balanceUSD := walletTotalBalance * rateUSDTRTL
		qmlBridge.DisplayTotalBalance(humanize.FormatFloat("#,###.##", walletTotalBalance), humanize.FormatFloat("#,###.##", balanceUSD))
	}
}

func getAndDisplayAddress() {

	walletAddress, err := walletdmanager.RequestAddress()
	if err == nil {
		qmlBridge.DisplayAddress(walletAddress, walletdmanager.WalletFilename, displayFiatConversion)
	}
}

func getAndDisplayConnectionInfo() {

	syncing, walletBlockCount, knownBlockCount, _, peers, err := walletdmanager.RequestConnectionInfo()
	if err != nil {
		log.Info("error getting connection info: ", err)
		return
	}

	walletBlockCountString := humanize.FormatInteger("#,###.", walletBlockCount)
	// add percentage info if not synced
	if walletBlockCount > 1 && knownBlockCount-walletBlockCount > 2 {
		percentageSync := int(math.Floor(100 * (float64(walletBlockCount) / float64(knownBlockCount))))
		walletBlockCountString += " (" + humanize.FormatInteger("#,###.", percentageSync) + "%)"
	}

	localDaemonBlockCountString := "N/A"
	// localDaemonBlockCountString := "..."
	// if localDaemonBlockCount > 1 {
	// 	localDaemonBlockCountString = humanize.FormatInteger("#,###.", localDaemonBlockCount)
	// 	// add percentage info if not synced
	// 	if knownBlockCount-localDaemonBlockCount > 2 {
	// 		percentageSync := int(math.Floor(100 * (float64(localDaemonBlockCount) / float64(knownBlockCount))))
	// 		localDaemonBlockCountString += " (" + humanize.FormatInteger("#,###.", percentageSync) + "%)"
	// 	}
	// }

	knownBlockCountString := "..."
	if knownBlockCount > 1 {
		knownBlockCountString = humanize.FormatInteger("#,###.", knownBlockCount)
	}

	syncingInfo := "wallet: " + walletBlockCountString + " - node: " + localDaemonBlockCountString + "  (" + knownBlockCountString + " blocks - " + strconv.Itoa(peers) + " peers)"
	qmlBridge.DisplaySyncingInfo(syncing, syncingInfo)

	// when not connected to remote node, the knownBlockCount stays at 1. So inform users if there seems to be a connection problem
	if useRemoteNode {
		if knownBlockCount == 1 {
			countConnectionProblem++
		} else {
			countConnectionProblem = 0
		}
		if countConnectionProblem > 2 {
			countConnectionProblem = 0
			qmlBridge.DisplayErrorDialog("Error connecting to remote node", "Check your internet connection, the remote node address and the remote node status. If you cannot connect to the remote node, try another one or choose the \"local blockchain\" option.")
		}
	}
}

func getAndDisplayListTransactions(forceFullUpdate bool) {

	newTransfers, err := walletdmanager.RequestListTransactions()
	if err == nil {
		needFullUpdate := false
		if len(newTransfers) != len(transfers) || forceFullUpdate {
			needFullUpdate = true
		}
		transfers = newTransfers
		// sort starting by the most recent transaction
		sort.Slice(transfers, func(i, j int) bool { return transfers[i].Timestamp.After(transfers[j].Timestamp) })

		if needFullUpdate {
			transactionNumber := len(transfers)

			qmlBridge.ClearListTransactions()

			for index, transfer := range transfers {
				if limitDisplayedTransactions && index >= numberTransactionsToDisplay {
					break
				}
				amount := transfer.Amount
				amountString := ""
				if amount >= 0 {
					amountString += "+ "
					amountString += strconv.FormatFloat(amount, 'f', -1, 64)
				} else {
					amountString += "- "
					amountString += strconv.FormatFloat(-amount, 'f', -1, 64)
				}
				amountString += " TRTL (fee: " + strconv.FormatFloat(transfer.Fee, 'f', 2, 64) + ")"
				confirmationsString := confirmationsStringRepresentation(transfer.Confirmations)
				timeString := transfer.Timestamp.Format("2006-01-02 15:04:05")
				transactionNumberString := strconv.Itoa(transactionNumber) + ")"
				transactionNumber--

				qmlBridge.AddTransactionToList(transfer.PaymentID, transfer.TxID, amountString, confirmationsString, timeString, transactionNumberString)
			}
		} else { // just update the number of confirmations of transactions with less than 110 conf
			for index, transfer := range transfers {
				if limitDisplayedTransactions && index >= numberTransactionsToDisplay {
					break
				}
				if transfer.Confirmations < 110 {
					qmlBridge.UpdateConfirmationsOfTransaction(index, confirmationsStringRepresentation(transfer.Confirmations))
				} else {
					break
				}
			}
		}
	}
}

func transfer(transferAddress string, transferAmount string, transferPaymentID string, transferFee string) {

	log.Info("SEND: to: ", transferAddress, "  amount: ", transferAmount, "  payment ID: ", transferPaymentID, "  network fee: ", transferFee, "  node fee: ", walletdmanager.NodeFee)

	transactionID, err := walletdmanager.SendTransaction(transferAddress, transferAmount, transferPaymentID, transferFee)
	if err != nil {
		log.Warn("error transfer: ", err)
		qmlBridge.FinishedSendingTransaction()
		if strings.Contains(err.Error(), "Transaction size is too big") {
			qmlBridge.AskForFusion()
		} else {
			qmlBridge.DisplayErrorDialog("Error transfer.", err.Error())
		}
		return
	}

	log.Info("success transfer: ", transactionID)

	getAndDisplayBalances()
	qmlBridge.ClearTransferAmount()
	qmlBridge.FinishedSendingTransaction()
	qmlBridge.DisplayPopup("TRTLs sent successfully", 4000)
}

func optimizeWalletWithFusion() {

	transactionID, err := walletdmanager.OptimizeWalletWithFusion()
	if err != nil {
		log.Warn("error fusion transaction: ", err)
		qmlBridge.FinishedSendingTransaction()
		qmlBridge.DisplayErrorDialog("Error sending fusion transaction.", err.Error())

		return
	}

	log.Info("succes fusion: ", transactionID)

	getAndDisplayBalances()
	qmlBridge.ClearTransferAmount()
	qmlBridge.FinishedSendingTransaction()
	qmlBridge.DisplayPopup("Success fusion", 4000)
}

func startWalletWithWalletInfo(pathToWallet string, passwordWallet string) bool {

	remoteDaemonAddress := customRemoteDaemonAddress
	remoteDaemonPort := customRemoteDaemonPort

	if useRemoteNode {
		if indexSelectedRemoteNode+1 < len(remoteNodes) {
			// user did not chose custom node (last item of the list is custom node)

			node := remoteNodes[indexSelectedRemoteNode]
			remoteDaemonAddress = node.URL
			remoteDaemonPort = strconv.FormatUint(node.Port, 10)
		}
	}

	err := walletdmanager.StartWalletd(pathToWallet, passwordWallet, useRemoteNode, useCheckpoints, remoteDaemonAddress, remoteDaemonPort)
	if err != nil {
		log.Warn("error starting turtle-service with provided wallet info. error: ", err)
		qmlBridge.FinishedLoadingWalletd()
		qmlBridge.DisplayErrorDialog("Error opening wallet.", err.Error())
		return false
	}

	log.Info("success starting turtle-service")

	qmlBridge.FinishedLoadingWalletd()
	startDisplayWalletInfo()
	qmlBridge.DisplayMainWalletScreen()

	return true
}

func createWalletWithWalletInfo(filenameWallet string, passwordWallet string, confirmPasswordWallet string) bool {

	err := walletdmanager.CreateWallet(filenameWallet, passwordWallet, confirmPasswordWallet, "", "", "", "")
	if err != nil {
		log.Warn("error creating wallet. error: ", err)
		qmlBridge.FinishedCreatingWallet()
		qmlBridge.DisplayErrorDialog("Error creating the wallet.", err.Error())
		return false
	}

	log.Info("success creating wallet")

	startWalletWithWalletInfo(filenameWallet, passwordWallet)
	showWalletPrivateInfo()

	return true
}

func importWalletWithWalletInfo(filenameWallet string, passwordWallet string, confirmPasswordWallet string, privateViewKey string, privateSpendKey string, mnemonicSeed string, scanHeight string) bool {

	err := walletdmanager.CreateWallet(filenameWallet, passwordWallet, confirmPasswordWallet, privateViewKey, privateSpendKey, mnemonicSeed, scanHeight)
	if err != nil {
		log.Warn("error importing wallet. error: ", err)
		qmlBridge.FinishedCreatingWallet()
		qmlBridge.DisplayErrorDialog("Error importing the wallet.", err.Error())
		return false
	}

	log.Info("success importing wallet")

	startWalletWithWalletInfo(filenameWallet, passwordWallet)

	return true
}

func closeWallet() {

	tickerRefreshWalletData.Stop()
	tickerRefreshConnectionInfo.Stop()
	tickerRefreshNodeFeeInfo.Stop()
	tickerSaveWallet.Stop()

	stringBackupKeys = ""
	transfers = nil
	limitDisplayedTransactions = true
	countConnectionProblem = 0

	go func() {
		walletdmanager.GracefullyQuitWalletd()
	}()

	qmlBridge.DisplayOpenWalletScreen()
}

func showWalletPrivateInfo() {

	isDeterministicWallet, mnemonicSeed, privateViewKey, privateSpendKey, err := walletdmanager.GetPrivateKeys()
	if err != nil {
		log.Error("Error getting private keys: ", err)
	} else {
		stringBackupKeys = "Wallet: " + walletdmanager.WalletFilename + "\n\nAddress: " + walletdmanager.WalletAddress + "\n\n"
		if isDeterministicWallet {
			qmlBridge.DisplaySeed(walletdmanager.WalletFilename, mnemonicSeed, walletdmanager.WalletAddress)

			stringBackupKeys += "Seed: " + mnemonicSeed
		} else {
			qmlBridge.DisplayPrivateKeys(walletdmanager.WalletFilename, privateViewKey, privateSpendKey, walletdmanager.WalletAddress)

			stringBackupKeys += "Private view key: " + privateViewKey + "\n\nPrivate spend key: " + privateSpendKey
		}
	}
}

func getFullBalanceAndDisplayInTransferAmount(transferFee string) {

	availableBalance, err := walletdmanager.RequestAvailableBalanceToBeSpent(transferFee)
	if err != nil {
		qmlBridge.DisplayErrorDialog("Error calculating full balance minus fee.", err.Error())
	}
	qmlBridge.DisplayFullBalanceInTransferAmount(humanize.FtoaWithDigits(availableBalance, 2))
}

func getDefaultFeeAndDisplay() {

	qmlBridge.DisplayDefaultFee(humanize.FtoaWithDigits(walletdmanager.DefaultTransferFee, 2))
}

func getNodeFeeAndDisplay() {

	nodeFee, err := walletdmanager.RequestFeeinfo()
	if err != nil {
		qmlBridge.DisplayNodeFee("-")
	} else {
		qmlBridge.DisplayNodeFee(humanize.FtoaWithDigits(nodeFee, 2))
	}
}

func saveRemoteDaemonInfo(daemonAddress string, daemonPort string) {

	customRemoteDaemonAddress = daemonAddress
	customRemoteDaemonPort = daemonPort
	recordRemoteDaemonInfoToDB(customRemoteDaemonAddress, customRemoteDaemonPort)
	qmlBridge.DisplayUseRemoteNode(getUseRemoteFromDB())
}

func saveAddress(name string, address string, paymentID string) {

	if name == "" || address == "" {
		qmlBridge.DisplayErrorDialog("Address not saved", "The address field and the name cannot be empty")
	} else {
		recordSavedAddressToDB(name, address, paymentID)
		qmlBridge.DisplayPopup("Saved!", 1500)
	}
}

func exportListTransactions() {

	pathToExportFile := "transactions." + walletdmanager.WalletFilename + ".csv"

	if isPlatformDarwin {
		usr, err := user.Current()
		if err != nil {
			log.Fatal(err)
		}
		pathToExportFile = usr.HomeDir + "/" + pathToExportFile
	} else {
		pathToAppDirectory, _ := filepath.Abs(filepath.Dir(os.Args[0]))
		if isPlatformWindows {
			pathToExportFile = pathToAppDirectory + "\\" + pathToExportFile
		} else {
			// linux
			pathToExportFile = pathToAppDirectory + "/" + pathToExportFile
		}
	}

	fileExport, err := os.Create(pathToExportFile)
	if err != nil {
		log.Error("error creating export file. err: ", err)
		qmlBridge.DisplayErrorDialog("error creating export file", err.Error())
		return
	}
	defer fileExport.Close()

	writer := csv.NewWriter(fileExport)

	records := [][]string{
		{"Index", "Timestamp", "Readable Timestamp", "Block", "Amount", "Fee", "TxID", "PaymentID", "Confirmations"},
	}

	inversedTransactionIndex := len(transfers)

	for _, transfer := range transfers {
		indexString := strconv.Itoa(inversedTransactionIndex)
		timestampString := strconv.FormatInt(transfer.Timestamp.Unix(), 10)
		readableTimestampString := transfer.Timestamp.Format("2006-01-02 15:04:05")
		blockString := strconv.Itoa(transfer.Block)
		amountString := strconv.FormatFloat(transfer.Amount, 'f', -1, 64)
		feeString := strconv.FormatFloat(transfer.Fee, 'f', 2, 64)
		txIDString := transfer.TxID
		paymentIDString := transfer.PaymentID
		confirmationsString := strconv.Itoa(transfer.Confirmations)

		records = append(records, []string{indexString, timestampString, readableTimestampString, blockString, amountString, feeString, txIDString, paymentIDString, confirmationsString})

		inversedTransactionIndex--
	}

	for _, record := range records {
		if err := writer.Write(record); err != nil {
			log.Error("error writing record to csv. err: ", err)
			qmlBridge.DisplayErrorDialog("error exporting record", err.Error())
			return
		}
	}

	writer.Flush()

	if err := writer.Error(); err != nil {
		log.Error("error writing to the csv file. err: ", err)
		qmlBridge.DisplayErrorDialog("error writing to the csv file", err.Error())
	} else {
		qmlBridge.DisplayInfoDialog("Success", "list of transactions successfully exported to", pathToExportFile)
	}
}

func getAndDisplayStartInfoFromDB() {

	qmlBridge.DisplayPathToPreviousWallet(getPathWalletFromDB())
	customRemoteDaemonAddress, customRemoteDaemonPort = getRemoteDaemonInfoFromDB()
	qmlBridge.DisplayUseRemoteNode(getUseRemoteFromDB())
	qmlBridge.DisplaySettingsValues(getDisplayConversionFromDB())
	qmlBridge.DisplaySettingsRemoteDaemonInfo(customRemoteDaemonAddress, customRemoteDaemonPort)
}

func openBrowser(url string) bool {
	var args []string
	switch runtime.GOOS {
	case "darwin":
		args = []string{"open"}
	case "windows":
		args = []string{"cmd", "/c", "start"}
	default:
		args = []string{"xdg-open"}
	}
	cmd := exec.Command(args[0], append(args[1:], url)...)
	return cmd.Start() == nil
}

func requestRateTRTL() {
	response, err := http.Get(urlCryptoCompareTRTL)

	if err != nil {
		log.Error("error fetching from cryptocompare: ", err)
	} else {
		b, err := ioutil.ReadAll(response.Body)
		response.Body.Close()
		if err != nil {
			log.Error("error reading result from cryptocompare: ", err)
		} else {
			var resultInterface interface{}
			if err := json.Unmarshal(b, &resultInterface); err != nil {
				log.Error("error JSON unmarshaling request cryptocompare: ", err)
			} else {
				resultsMap := resultInterface.(map[string]interface{})
				rateUSDTRTL = resultsMap["USD"].(float64)
			}
		}
	}
}

func getAndDisplayListRemoteNodes() {
	remoteNodes = requestListRemoteNodes()

	// add an item for displaying the custom node in the dropdown list
	var customNode node
	customNode.Name = "Custom (change in settings)"
	customNode.URL = customNode.Name
	remoteNodes = append(remoteNodes, customNode)

	// to preselect the node previously selected by the user
	addressPreferedNode, portPreferedNode := getSelectedRemoteDaemonFromDB()

	preferedNodeFound := false

	for index, aNode := range remoteNodes {
		qmlBridge.AddRemoteNodeToList(aNode.Name)

		if addressPreferedNode != "" && aNode.URL == addressPreferedNode && aNode.Port == uint64(portPreferedNode) {
			indexSelectedRemoteNode = index
			preferedNodeFound = true
		}
	}

	// if user prefered node not found, select the default one in the list
	if !preferedNodeFound {
		for index, aNode := range remoteNodes {
			if aNode.URL == defaultRemoteDaemonAddress {
				indexSelectedRemoteNode = index
			}
		}
	}

	qmlBridge.SetSelectedRemoteNode(indexSelectedRemoteNode)
}

func amountStringUSDToTRTL(amountTRTLString string) string {
	amountTRTL, err := strconv.ParseFloat(amountTRTLString, 64)
	if err != nil || amountTRTL <= 0 || rateUSDTRTL == 0 {
		return ""
	}
	amountUSD := amountTRTL * rateUSDTRTL
	amountUSDString := strconv.FormatFloat(amountUSD, 'f', 2, 64) + " $"
	return amountUSDString
}

func confirmationsStringRepresentation(confirmations int) string {
	confirmationsString := "("
	if confirmations > 100 {
		confirmationsString += ">100"
	} else {
		confirmationsString += strconv.Itoa(confirmations)
	}
	confirmationsString += " conf.)"
	return confirmationsString
}
