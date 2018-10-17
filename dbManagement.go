// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

package main

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
	log "github.com/sirupsen/logrus"
)

var (
	db *sql.DB
)

func setupDB(pathToDB string) {

	var err error
	db, err = sql.Open("sqlite3", pathToDB)
	if err != nil {
		log.Fatal("error opening db file. err: ", err)
	}

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS pathWallet (id INTEGER PRIMARY KEY AUTOINCREMENT,path VARCHAR(64) NULL)")
	if err != nil {
		log.Fatal("error creating table pathWallet. err: ", err)
	}

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS remoteNode (id INTEGER PRIMARY KEY AUTOINCREMENT, useRemote BOOL NOT NULL DEFAULT '1')")
	if err != nil {
		log.Fatal("error creating table remoteNode. err: ", err)
	}

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS fiatConversion (id INTEGER PRIMARY KEY AUTOINCREMENT, displayFiat BOOL NOT NULL DEFAULT '0', currency VARCHAR(64) DEFAULT 'USD')")
	if err != nil {
		log.Fatal("error creating table fiatConversion. err: ", err)
	}

	// table for storing custom node set in settings
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS remoteNodeInfo (id INTEGER PRIMARY KEY AUTOINCREMENT, address VARCHAR(64), port VARCHAR(64))")
	if err != nil {
		log.Fatal("error creating table remoteNodeInfo. err: ", err)
	}

	// table for remembering which remote node was lastly selected by the user in the list
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS selectedRemoteNode (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(64), address VARCHAR(64), port INTEGER)")
	if err != nil {
		log.Fatal("error creating table selectedRemoteNode. err: ", err)
	}

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS savedAddresses (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(64), address VARCHAR(64), paymentID VARCHAR(64))")
	if err != nil {
		log.Fatal("error creating table savedAddresses. err: ", err)
	}
}

func getPathWalletFromDB() string {

	pathToPreviousWallet := ""

	rows, err := db.Query("SELECT path FROM pathWallet ORDER BY id DESC LIMIT 1")
	if err != nil {
		log.Fatal("error querying path from pathwallet table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		path := ""
		err = rows.Scan(&path)
		if err != nil {
			log.Fatal("error reading item from pathWallet table. err: ", err)
		}
		pathToPreviousWallet = path
	}

	return pathToPreviousWallet
}

func recordPathWalletToDB(path string) {

	stmt, err := db.Prepare(`INSERT INTO pathWallet(path) VALUES(?)`)
	if err != nil {
		log.Fatal("error preparing to insert pathWallet into db. err: ", err)
	}
	_, err = stmt.Exec(path)
	if err != nil {
		log.Fatal("error inserting pathWallet into db. err: ", err)
	}
}

func getUseRemoteFromDB() bool {

	rows, err := db.Query("SELECT useRemote FROM remoteNode ORDER BY id DESC LIMIT 1")
	if err != nil {
		log.Fatal("error querying useRemote from remoteNode table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		useRemote := true
		err = rows.Scan(&useRemote)
		if err != nil {
			log.Fatal("error reading item from remoteNode table. err: ", err)
		}
		useRemoteNode = useRemote
	}

	return useRemoteNode
}

func recordUseRemoteToDB(useRemote bool) {

	stmt, err := db.Prepare(`INSERT INTO remoteNode(useRemote) VALUES(?)`)
	if err != nil {
		log.Fatal("error preparing to insert useRemoteNode into db. err: ", err)
	}
	_, err = stmt.Exec(useRemote)
	if err != nil {
		log.Fatal("error inserting useRemoteNode into db. err: ", err)
	}
}

func getRemoteDaemonInfoFromDB() (daemonAddress string, daemonPort string) {

	rows, err := db.Query("SELECT address, port FROM remoteNodeInfo ORDER BY id DESC LIMIT 1")
	if err != nil {
		log.Fatal("error querying address and port from remoteNodeInfo table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		daemonAddress := ""
		daemonPort := ""
		err = rows.Scan(&daemonAddress, &daemonPort)
		if err != nil {
			log.Fatal("error reading item from remoteNodeInfo table. err: ", err)
		}
		customRemoteDaemonAddress = daemonAddress
		customRemoteDaemonPort = daemonPort
	}

	return customRemoteDaemonAddress, customRemoteDaemonPort
}

func recordRemoteDaemonInfoToDB(daemonAddress string, daemonPort string) {

	stmt, err := db.Prepare(`INSERT INTO remoteNodeInfo(address,port) VALUES(?,?)`)
	if err != nil {
		log.Fatal("error preparing to insert address and port of remote node into db. err: ", err)
	}
	_, err = stmt.Exec(daemonAddress, daemonPort)
	if err != nil {
		log.Fatal("error inserting address and port of remote node into db. err: ", err)
	}
}

func getSelectedRemoteDaemonFromDB() (daemonAddress string, daemonPort int) {

	rows, err := db.Query("SELECT address, port FROM selectedRemoteNode ORDER BY id DESC LIMIT 1")
	if err != nil {
		log.Fatal("error querying address and port from selectedRemoteNode table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		err = rows.Scan(&daemonAddress, &daemonPort)
		if err != nil {
			log.Fatal("error reading item from selectedRemoteNode table. err: ", err)
		}
	}

	return daemonAddress, daemonPort
}

func recordSelectedRemoteDaemonToDB(selectedNode node) {

	stmt, err := db.Prepare(`INSERT INTO selectedRemoteNode(name,address,port) VALUES(?,?,?)`)
	if err != nil {
		log.Fatal("error preparing to insert name, address and port of selected remote node into db. err: ", err)
	}
	_, err = stmt.Exec(selectedNode.Name, selectedNode.URL, selectedNode.Port)
	if err != nil {
		log.Fatal("error inserting name, address and port of selected remote node into db. err: ", err)
	}
}

func getDisplayConversionFromDB() bool {

	rows, err := db.Query("SELECT displayFiat FROM fiatConversion ORDER BY id DESC LIMIT 1")
	if err != nil {
		log.Fatal("error reading displayFiat from fiatConversion table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		displayFiat := false
		err = rows.Scan(&displayFiat)
		if err != nil {
			log.Fatal("error reading item from fiatConversion table. err: ", err)
		}
		displayFiatConversion = displayFiat
	}

	return displayFiatConversion
}

func recordDisplayConversionToDB(displayConversion bool) {

	stmt, err := db.Prepare(`INSERT INTO fiatConversion(displayFiat) VALUES(?)`)
	if err != nil {
		log.Fatal("error preparing to insert displayFiat into db. err: ", err)
	}
	_, err = stmt.Exec(displayConversion)
	if err != nil {
		log.Fatal("error inserting displayFiat into db. err: ", err)
	}
}

func getSavedAddressesFromDBAndDisplay() {

	rows, err := db.Query("SELECT id, name, address, paymentID FROM savedAddresses ORDER BY id ASC")
	if err != nil {
		log.Fatal("error querying saved addresses from savedAddresses table. err: ", err)
	}
	defer rows.Close()
	for rows.Next() {
		dbID := 0
		name := ""
		address := ""
		paymentID := ""
		err = rows.Scan(&dbID, &name, &address, &paymentID)
		if err != nil {
			log.Fatal("error reading item from savedAddresses table. err: ", err)
		}
		qmlBridge.AddSavedAddressToList(dbID, name, address, paymentID)
	}
}

func recordSavedAddressToDB(name string, address string, paymentID string) {

	stmt, err := db.Prepare(`INSERT INTO savedAddresses(name,address,paymentID) VALUES(?,?,?)`)
	if err != nil {
		log.Fatal("error preparing to insert saved address into db. err: ", err)
	}
	_, err = stmt.Exec(name, address, paymentID)
	if err != nil {
		log.Fatal("error inserting saved address into db. err: ", err)
	}
}

func deleteSavedAddressFromDB(dbID int) {

	stmt, err := db.Prepare("delete from savedAddresses where id=?")
	if err != nil {
		log.Fatal("error preparing to delete saved address from db. err: ", err)
	}

	_, err = stmt.Exec(dbID)
	if err != nil {
		log.Fatal("error deleting saved address from db. err: ", err)
	}
}
