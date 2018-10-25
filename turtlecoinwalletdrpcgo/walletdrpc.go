// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

// Package turtlecoinwalletdrpcgo handles the the rpc connection between your app and turtle-service
package turtlecoinwalletdrpcgo

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
)

// Transfer contains all the information about a specific transfer
type Transfer struct {
	PaymentID              string
	TxID                   string
	Timestamp              time.Time
	Amount                 float64
	Fee                    float64
	Block                  int
	Confirmations          int
	IsRecievingTransaction bool
}

var (
	rpcURL = "http://127.0.0.1:8070/json_rpc"
)

// RequestBalance provides the available and locked balances of the current wallet
// returned balances are expressed in TRTL, not in 0.01 TRTL
func RequestBalance(rpcPassword string) (availableBalance float64, lockedBalance float64, totalBalance float64, err error) {

	args := make(map[string]interface{})
	payload := rpcPayloadGetBalance(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return 0, 0, 0, errors.Wrap(err, "httpRequest failed")
	}

	if responseMap["result"] == nil {
		return 0, 0, 0, errors.Wrap(err, "getBalance result is nil")
	}

	availableBalance = responseMap["result"].(map[string]interface{})["availableBalance"].(float64) / 100
	lockedBalance = responseMap["result"].(map[string]interface{})["lockedAmount"].(float64) / 100
	totalBalance = availableBalance + lockedBalance

	return availableBalance, lockedBalance, totalBalance, nil
}

// RequestAddress provides the address of the current wallet
func RequestAddress(rpcPassword string) (address string, err error) {

	args := make(map[string]interface{})
	payload := rpcPayloadGetAddresses(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", errors.Wrap(err, "httpRequest failed")
	}

	walletAddresses := responseMap["result"].(map[string]interface{})["addresses"].([]interface{})
	address = walletAddresses[0].(string)
	return address, nil
}

// RequestListTransactions provides the list of transactions of current wallet
func RequestListTransactions(blockCount int, firstBlockIndex int, addresses []string, rpcPassword string) (transfers []Transfer, err error) {

	args := make(map[string]interface{})
	args["blockCount"] = blockCount
	args["firstBlockIndex"] = firstBlockIndex
	args["addresses"] = addresses
	payload := rpcPayloadGetTransactions(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return nil, errors.Wrap(err, "httpRequest failed")
	}

	if responseMap["result"] == nil {
		return nil, nil
	}

	blocks := responseMap["result"].(map[string]interface{})["items"].([]interface{})

	for _, block := range blocks {

		transactions := block.(map[string]interface{})["transactions"].([]interface{})

		for _, transaction := range transactions {

			mapTransaction := transaction.(map[string]interface{})

			var transfer Transfer
			transfer.PaymentID = mapTransaction["paymentId"].(string)
			transfer.TxID = mapTransaction["transactionHash"].(string)
			transfer.Timestamp = time.Unix(int64(mapTransaction["timestamp"].(float64)), 0)
			transfer.Amount = mapTransaction["amount"].(float64) / 100
			transfer.Fee = mapTransaction["fee"].(float64) / 100
			transfer.Block = int(mapTransaction["blockIndex"].(float64))
			transfer.Confirmations = blockCount - transfer.Block + 1
			transfer.IsRecievingTransaction = transfer.Amount >= 0

			transfers = append(transfers, transfer)
		}
	}
	return transfers, nil
}

// RequestStatus requests turtle-service connection and sync status
func RequestStatus(rpcPassword string) (walletBlockCount int, knownBlockCount int, localDaemonBlockCount int, peerCount int, err error) {

	args := make(map[string]interface{})
	payload := rpcPayloadGetStatus(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return 0, 0, 0, 0, errors.Wrap(err, "httpRequest failed")
	}

	walletBlockCount = int(responseMap["result"].(map[string]interface{})["blockCount"].(float64))
	knownBlockCount = int(responseMap["result"].(map[string]interface{})["knownBlockCount"].(float64))
	localDaemonBlockCount = int(responseMap["result"].(map[string]interface{})["localDaemonBlockCount"].(float64))
	peerCount = int(responseMap["result"].(map[string]interface{})["peerCount"].(float64))

	return walletBlockCount, knownBlockCount, localDaemonBlockCount, peerCount, nil
}

// SendTransaction makes a transfer with the provided information.
// parameters amount and fee are expressed in TRTL, not 0.01 TRTL
func SendTransaction(addressRecipient string, amount float64, paymentID string, fee float64, rpcPassword string) (transactionHash string, err error) {

	amountInt := uint64(amount * 100) // expressed in hundredth of TRTL
	feeInt := uint64(fee * 100)       // expressed in hundredth of TRTL

	args := make(map[string]interface{})
	args["fee"] = feeInt
	args["paymentId"] = paymentID
	var transfers [1]map[string]interface{}
	transfer := make(map[string]interface{})
	transfer["amount"] = amountInt
	transfer["address"] = addressRecipient
	transfers[0] = transfer
	args["transfers"] = transfers

	payload := rpcPayloadSendTransaction(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", errors.Wrap(err, "httpRequest failed")
	}

	responseError := responseMap["error"]
	if responseError != nil {
		return "", errors.Wrap(errors.New(responseError.(map[string]interface{})["message"].(string)), "response with error")
	}
	return responseMap["result"].(map[string]interface{})["transactionHash"].(string), nil
}

// GetViewKey provides the private view key
func GetViewKey(rpcPassword string) (privateViewKey string, err error) {

	args := make(map[string]interface{})
	payload := rpcPayloadGetViewKey(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", errors.Wrap(err, "httpRequest failed")
	}

	privateViewKey = responseMap["result"].(map[string]interface{})["viewSecretKey"].(string)
	return privateViewKey, nil
}

// GetSpendKeys provides the private and public spend keys
func GetSpendKeys(address string, rpcPassword string) (spendSecretKey string, spendPublicKey string, err error) {

	args := make(map[string]interface{})
	args["address"] = address
	payload := rpcPayloadGetSpendKeys(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", "", err
	}

	spendSecretKey = responseMap["result"].(map[string]interface{})["spendSecretKey"].(string)
	spendPublicKey = responseMap["result"].(map[string]interface{})["spendSecretKey"].(string)
	return spendSecretKey, spendPublicKey, nil
}

// GetMnemonicSeed provides the mnemonic seed.
func GetMnemonicSeed(address string, rpcPassword string) (isDeterministicWallet bool, mnemonicSeed string, err error) {

	args := make(map[string]interface{})
	args["address"] = address
	payload := rpcPayloadGetMnemonicSeed(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return false, "", err
	}

	if responseMap["result"] == nil { // wallet is not deterministic. error in the response is: application_code:6 message:"Keys not deterministic"
		return false, "", nil
	}

	mnemonicSeed = responseMap["result"].(map[string]interface{})["mnemonicSeed"].(string)

	return true, mnemonicSeed, nil
}

// SaveWallet saves the sync info in the wallet
func SaveWallet(rpcPassword string) (err error) {

	args := make(map[string]interface{})
	payload := rpcPayloadSave(0, rpcPassword, args)

	_, err = httpRequest(payload)
	if err != nil {
		return errors.Wrap(err, "httpRequest failed")
	}

	return nil
}

// EstimateFusion counts the number of unspent outputs of the specified addresses and returns how many of those outputs can be optimized. This method is used to understand if a fusion transaction can be created. If fusionReadyCount returns a value = 0, then a fusion transaction cannot be created.
// threshold is the value that determines which outputs will be optimized. Only the outputs, lesser than the threshold value, will be included into a fusion transaction (threshold is expressed in TRTL, not 0.01 TRTL).
// fusionReadyCount is the number of outputs that can be optimized.
// totalOutputCount is the total number of unspent outputs of the specified addresses.
func EstimateFusion(threshold int, addresses []string, rpcPassword string) (fusionReadyCount int, totalOutputCount int, err error) {

	threshold *= 100 // expressed in hundredth of TRTL

	args := make(map[string]interface{})
	args["threshold"] = threshold
	args["addresses"] = addresses
	payload := rpcPayloadEstimateFusion(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return 0, 0, errors.Wrap(err, "httpRequest failed")
	}

	fusionReadyCount = int(responseMap["result"].(map[string]interface{})["fusionReadyCount"].(float64))
	totalOutputCount = int(responseMap["result"].(map[string]interface{})["totalOutputCount"].(float64))

	return fusionReadyCount, totalOutputCount, nil
}

// SendFusionTransaction allows you to send a fusion transaction, by taking funds from selected addresses and transferring them to the destination address.
// threshold is the value that determines which outputs will be optimized. Only the outputs, lesser than the threshold value, will be included into a fusion transaction (threshold is expressed in TRTL, not 0.01 TRTL).
// parameters amount and fee are expressed in TRTL, not 0.01 TRTL
func SendFusionTransaction(threshold int, addresses []string, destinationAddress string, rpcPassword string) (transactionHash string, err error) {

	threshold *= 100 // expressed in hundredth of TRTL

	args := make(map[string]interface{})
	args["threshold"] = threshold
	args["addresses"] = addresses
	args["destinationAddress"] = destinationAddress

	payload := rpcPayloadSendFusionTransaction(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", errors.Wrap(err, "httpRequest failed")
	}

	responseError := responseMap["error"]
	if responseError != nil {
		return "", errors.Wrap(errors.New(responseError.(map[string]interface{})["message"].(string)), "response with error")
	}
	return responseMap["result"].(map[string]interface{})["transactionHash"].(string), nil
}

// GetFeeInfo returns info on the fee requested by the remote node for every transactions
// returned fee is expressed in TRTL, not in 0.01 TRTL
func GetFeeInfo(rpcPassword string) (address string, fee float64, status string, err error) {

	args := make(map[string]interface{})

	payload := rpcPayloadGetFeeInfo(0, rpcPassword, args)

	responseMap, err := httpRequest(payload)
	if err != nil {
		return "", 0, "", errors.Wrap(err, "httpRequest failed")
	}

	responseError := responseMap["error"]
	if responseError != nil {
		return "", 0, "", errors.Wrap(errors.New(responseError.(map[string]interface{})["message"].(string)), "response with error")
	}

	result := responseMap["result"]
	if result == nil {
		return "", 0, "", errors.New("result from feeinfo request is nil")
	}

	resultAddress := result.(map[string]interface{})["address"]
	if resultAddress != nil {
		address = resultAddress.(string)
	} else {
		address = ""
	}

	resultAmount := result.(map[string]interface{})["amount"]
	if resultAmount != nil {
		fee = resultAmount.(float64) / 100
	} else {
		fee = 0
	}

	if address == "" && fee > 0 {
		return "", 0, "", errors.New("fee info is not valid")
	}

	resultStatus := result.(map[string]interface{})["status"]
	if resultStatus != nil {
		status = resultStatus.(string)
	} else {
		status = ""
	}

	return address, fee, status, nil
}

func httpRequest(payload rpcPayload) (responseMap map[string]interface{}, err error) {

	payloadjson, err := json.Marshal(payload)
	if err != nil {
		log.Fatal("error json marshal: ", err)
	}

	req, err := http.NewRequest("POST", rpcURL, bytes.NewBuffer(payloadjson))
	if err != nil {
		log.Fatal("error creating http request: ", err)
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	responseBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal("error reading result from rpc request getSpendKey:", err)
	} else {
		var responseBodyInterface interface{}
		if err := json.Unmarshal(responseBody, &responseBodyInterface); err != nil {
			log.Fatal("JSON unmarshaling with interface failed:", err)
		} else {
			responseMap := responseBodyInterface.(map[string]interface{})
			return responseMap, nil
		}
	}

	return nil, errors.New("unknown error")
}
