# TurtleCoin Nest

The universal desktop GUI wallet for TurtleCoin

![Logo](/turtlecoinnestlogo.png)

## Installation

[Windows](#windows) - [Mac](#mac) - [Linux](#linux)

### Windows

1. Go [here](https://github.com/turtlecoin/turtle-wallet-go/releases) and download the latest release called **TurtleCoin-Nest-x.xx-Windows.zip**
2. Unzip the folder and launch **TurtleCoin-Nest.exe**. (Make sure you leave everything as is in the folder)

Important notes:

* Make sure *turtle-service.exe* is not running before you start *TurtleCoin-Nest*

### Mac

1. Go [here](https://github.com/turtlecoin/turtle-wallet-go/releases) and download the latest release called **TurtleCoin-Nest-x.xx-Mac.zip**.
2. Unzip it and move the folder wherever you want or drag the application **TurtleCoin-Nest** into /Applications or any other folder.
3. Launch the application. (If your mac complains that the app comes from an unindentified developer and does not want to open it, just right-click (or ctrl-click) on the app, and choose open > open)

Important notes:

* The wallets you create or generate will be saved to your home folder. You can keep them there or move them wherever you want.
* Make sure *turtle-service* is not running before you start *TurtleCoin-Nest*.
* If you encounter crashes, open the activity monitor (in your app > utilities), and force quit *turtle-service* (if it is running) before opening a wallet.
* The log files will be saved in ~/Library/Application Support/TurtleCoin-Nest/.

### Linux

1. Go [here](https://github.com/turtlecoin/turtle-wallet-go/releases) and download the latest release called **TurtleCoin-Nest-x.xx-Linux.tar.gz**
2. extract it
`$ tar xvzf TurtleCoin-Nest-x.xx-Linux.tar.gz`
3. run **TurtleCoin-Nest.sh**. (Make sure you leave everything as is in the folder)

Important notes:

* Make sure *turtle-service* is not running before you start *TurtleCoin-Nest*
* If you want the *copy address to clipboard* button to work, install *xclip* or *xsel* (on Debian/Ubuntu: `$ sudo apt install xclip`).
* If you encounter crashes, open an activity monitor (e.g. `$ htop`), and quit *turtle-service* (if it is running) before opening a wallet. (this bug is being worked on)

## Upgrade

Just download the new release and follow the same steps as [Installation](#installation).
If you are on Windows or Linux, move your wallets (.wallet) and settings.db files from the old Nest folder to the new. Then you can delete the old folder. (on Mac, you do not need to move the settings.db file as it stays in ~/Library/Application Support/TurtleCoin-Nest/).

## Screenshots

![Main Screen](/Screenshots/MainScreen.png)

![Open Wallet](/Screenshots/OpenWallet.png)

## Donations

TRTLv3jzutiQwqHL3qFwsu5EVLWesxZr1AFQ4AuMR3SD56n3rkHDkwj79eKwvaiU1nYQWGydKoXM6fXyiiGKsPDnVCNXzNdusxx

## Build - (for developers only)

### Linux

1. Download Go from [here](https://golang.org/dl/)

2. Use `tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz` to extract the downloaded go package.

3. Add the following lines to `.bashrc` file, save the file and then execute the command `source .bashrc` in a terminal.
    ```
    export GOPATH=$HOME/go

    export GOBIN=$GOPATH/bin

    export GOROOT=/usr/local/go

    export PATH=$HOME/bin:$HOME/.local/bin:$PATH:$GOROOT/bin:$GOBIN
    ```
4. Similarly add the following lines to `.profile` file, save the file and then execute the command `source .profile` in a terminal.
    ```
    CGO_CXXFLAGS_ALLOW=".*" 
    CGO_LDFLAGS_ALLOW=".*" 
    CGO_CFLAGS_ALLOW=".*" 
    ```
5. Follow the instructions present [here](https://github.com/therecipe/qt/wiki/Installation-on-Linux) till **Run the setup** to install Qt which is the most important binding required to build Nest.
6. Type the following commands to clone the Nest wallet, install dependencies and build the wallet.
    ```
    $ cd $HOME/go/src
    $ git clone https://github.com/turtlecoin/turtle-wallet-go.git TurtleCoin-Nest
    $ go get -v github.com/atotto/clipboard github.com/dustin/go-humanize github.com/mattn/go-sqlite3 github.com/mcuadros/go-version github.com/mitchellh/go-ps github.com/pkg/errors
    $ cd TurtleCoin-Nest
    $ qtdeploy build desktop
    ```

1. The app folder is in deploy/linux/
1. Include the latest _turtle-service_ and _TurtleCoind_ builds in the app folder

### Windows - Mac

1. Install Go (https://golang.org/doc/install)

1. Install this binding: https://github.com/therecipe/qt (installation instructions at https://github.com/therecipe/qt/wiki/Installation)

1. Insall Go libraries (in console or terminal):
    ```
    $ go get github.com/atotto/clipboard github.com/dustin/go-humanize github.com/mattn/go-sqlite3 github.com/mcuadros/go-version github.com/mitchellh/go-ps github.com/pkg/errors
    ```

1. Run `qtdeploy build desktop`

1. The app folder is in deploy/*your os*/

1. Include the latest _turtle-service_ and _TurtleCoind_ builds in:
    * Windows: in the app folder
    * Mac: in TurtleCoin-Nest.app/Contents/
