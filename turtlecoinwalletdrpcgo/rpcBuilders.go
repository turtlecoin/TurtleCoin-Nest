// Copyright (c) 2018, The TurtleCoin Developers
//
// Please see the included LICENSE file for more information.
//

package turtlecoinwalletdrpcgo

// rpcPayload is the struct with the right formatting for passing to the post request
type rpcPayload struct {
	JSONRPC  string                  `json:"jsonrpc"`
	Method   string                  `json:"method"`
	Params   *map[string]interface{} `json:"params,omitempty"`
	Password string                  `json:"password"`
	ID       int                     `json:"id"`
}

func buildRPCPayload(
	method string,
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return rpcPayload{
		JSONRPC:  "2.0",
		Method:   method,
		Password: rpcPassword,
		ID:       id,
		Params:   &params}
}

func rpcPayloadReset(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"reset",
		id,
		rpcPassword,
		params)
}

func rpcPayloadSave(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"save",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetViewKey(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getViewKey",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetSpendKeys(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getSpendKeys",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetMnemonicSeed(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getMnemonicSeed",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetStatus(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getStatus",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetAddresses(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getAddresses",
		id,
		rpcPassword,
		params)
}

func rpcPayloadCreateAddress(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"createAddress",
		id,
		rpcPassword,
		params)
}

func rpcPayloadDeleteAddress(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"deleteAddress",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetBalance(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getBalance",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetBlockHashes(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getBlockHashes",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetTransactionHashes(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getTransactionHashes",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetTransactions(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getTransactions",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetUnconfirmedTransactionHashes(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getUnconfirmedTransactionHashes",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadSendTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"sendTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadCreateDelayedTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"createDelayedTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetDelayedTransactionHashes(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getDelayedTransactionHashes",
		id,
		rpcPassword,
		params)
}

func rpcPayloadDeleteDelayedTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"deleteDelayedTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadSendDelayedTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"sendDelayedTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadSendFusionTransaction(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"sendFusionTransaction",
		id,
		rpcPassword,
		params)
}

func rpcPayloadEstimateFusion(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"estimateFusion",
		id,
		rpcPassword,
		params)
}

func rpcPayloadGetFeeInfo(
	id int,
	rpcPassword string,
	params map[string]interface{}) rpcPayload {

	return buildRPCPayload(
		"getFeeInfo",
		id,
		rpcPassword,
		params)
}
