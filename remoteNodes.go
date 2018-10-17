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

const urlTurtleCoinRemoteNodes = "https://raw.githubusercontent.com/turtlecoin/turtlecoin-nodes-json/master/turtlecoin-nodes.json"

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
