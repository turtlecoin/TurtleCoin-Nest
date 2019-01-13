#!/bin/sh

# sudo apt-get -y install build-essential libglu1-mesa-dev libpulse-dev libglib2.0-dev libdbusmenu-qt5-dev libqt*5-dev qt*5-dev

export OUR_BUILD_PATH=`pwd`
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOROOT=$HOME/usr/local/go
export PATH=$HOME/bin:$HOME/.local/bin:$GOROOT/bin:$GOBIN:$PATH
export CGO_CXXFLAGS_ALLOW=".*"
export CGO_LDFLAGS_ALLOW=".*" 
export CGO_CFLAGS_ALLOW=".*" 

mkdir -p $HOME/usr/local

echo -n "Checking for Go... "
if [ ! -e ${HOME}/usr/local/go/bin/go ]; then
  echo "Not found"
  wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
  tar -C $HOME/usr/local -xzf go1.11.4.linux-amd64.tar.gz
  rm -rf go1.11.4.linux-amd64.tar.gz
  echo "Go installed"
else
  echo "Found"
fi

# Install dependencies
echo -n "Installing Go dependencies... "
go get -u -v github.com/therecipe/qt/cmd/... >/dev/null
go get github.com/atotto/clipboard >/dev/null
go get github.com/dustin/go-humanize >/dev/null
go get github.com/mattn/go-sqlite3 >/dev/null
go get github.com/mcuadros/go-version >/dev/null
go get github.com/mitchellh/go-ps >/dev/null
go get github.com/pkg/errors >/dev/null
echo "Done"

# Clean this up and link to where we are building from
rm -rf $HOME/go/src/TurtleCoin-Nest
ln -s $OUR_BUILD_PATH $HOME/go/src/TurtleCoin-Nest

# Remove previous builds
echo -n "Building project... "
rm -rf deploy
qtdeploy build desktop
echo "Complete"
