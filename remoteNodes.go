package main

import (
	"strconv"

	log "github.com/sirupsen/logrus"
)

type nodes struct {
	Nodes []node `json:"nodes"`
}

type node struct {
	Name string `json:"name"`
	URL  string `json:"url"`
	Port uint64 `json:"port"`
	SSL  bool   `json:"ssl"`
}

type nodeFeeInfo struct {
	Address string  `json:"address"`
	Amount  float64 `json:"amount"`
}

const urlTurtleCoinRemoteNodes = "https://raw.githubusercontent.com/turtlecoin/turtlecoin-nodes-json/master/turtlecoin-nodes.json"
const apiPointFee = "/fee"
const apiPointFee2 = "/feeinfo"

func requestListRemoteNodes() (remoteNodes []node) {

	theNodes := new(nodes)
	err := getJSONFromHTTPRequest(urlTurtleCoinRemoteNodes, theNodes)

	if err != nil {

		// if error getting the list, include only one node - the default one
		var defaultNode node
		defaultNode.Name = defaultRemoteDaemonName
		defaultNode.URL = defaultRemoteDaemonAddress
		defaultPort, err := strconv.ParseUint(defaultRemoteDaemonPort, 10, 64)
		if err != nil {
			log.Fatal("error parsing remote node port: ", err)
		}
		defaultNode.Port = defaultPort
		defaultNode.SSL = defaultRemoteDaemonSSL

		remoteNodes = append(remoteNodes, defaultNode)

	} else {

		remoteNodes = theNodes.Nodes
	}

	return remoteNodes
}

func requestFeeOfNode(theNode node) (feeValue float64, err error) {

	theNodeFeeInfo := new(nodeFeeInfo)
	url := "http://" + theNode.URL + ":" + strconv.Itoa(int(theNode.Port))
	err = getJSONFromHTTPRequest(url+apiPointFee, theNodeFeeInfo)

	if err != nil {
		err = getJSONFromHTTPRequest(url+apiPointFee2, theNodeFeeInfo)
		if err != nil {
			return 0, err
		}
	}

	return theNodeFeeInfo.Amount / 100, nil
}
