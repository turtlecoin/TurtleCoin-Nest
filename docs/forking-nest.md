# Fork Nest for your fork of TurtleCoin

If you created your cryptonote coin by forking TurtleCoin and you want a universal desktop GUI wallet to go with it, Nest is your best choice. This guide will help you to fork Nest and adapt it to your coin.

## Warning

I have no idea when you forked TurtleCoin and how you keep up with its development. Nor do I know all the parameters you changed and what you implemented differently compared to TurtleCoin. TurtleCoin-Nest evolves very much together with TurtleCoin. Adapting Nest will depend from coin to coin. In this guide, we do our best to identify the things to modify and places in the code to look at. But do not expect it to be one-size-fits-all. That being said, we will assume that you followed this guide to create your coin: [Forking TurtleCoin
](https://github.com/turtlecoin/turtlecoin/wiki/Forking-Turtlecoin).

Nest was not developed with the idea in mind to be easily forked for other coins (Shame on me! But sorry, I did not expect it to gather so much interest). Forking it involves a bit more than just changing some parameters in a config file. But do not worry, it is not complicated. And we will work on improving its forkability.

If you follow this guide and encounter difficulties or discover missing steps, please provide feedback so we can improve it. In the following, we will assume that the name of your coin is _MyCoin_.

## Install the building environment

Nest is developed in Golang for the backend and Qt for the user interface. Qt is normally combined with C++, not Golang. So for using QT with Golang, we use a [Qt binding for Go](https://github.com/therecipe/qt), that will automatically generate the C++ code from the Go code and package our application. For building Nest, you will therefore have to install Go, Qt and that binding. You will have to install those 3 tools on each OS you want Nest to be working for. You will build on Windows for the Windows version of Nest, on Mac for the Mac version of Nest, and on Linyx for the Linux version of Nest. The Qt binding for Go proposes [docker images](https://github.com/therecipe/qt/wiki/Deploying-Application) for, theoritically, building for multiple OS from one OS, but I could not get them to work properly, so I use 3 different machines to build all Nest versions.

1. Install Go (https://golang.org/doc/install)

1. Install this binding: https://github.com/therecipe/qt (installation instructions at https://github.com/therecipe/qt/wiki/Installation). They describe the whole procedure for every OS, including the installation of Qt. If you have any issue, check their [issues page](https://github.com/therecipe/qt/issues?utf8=%E2%9C%93&q=is%3Aissue). You are done and can proceed further only once you have successfully run their _qtsetup_ script and it automatically launched multiple examples of Qt applications.

1. Insall Go libraries used by Nest (in console or terminal):
    ```bash
    go get github.com/atotto/clipboard github.com/dustin/go-humanize github.com/mattn/go-sqlite3 github.com/mcuadros/go-version github.com/mitchellh/go-ps github.com/pkg/errors
    ```

## Forking Nest

1. Go to [https://github.com/turtlecoin/turtle-wallet-go](https://github.com/turtlecoin/turtle-wallet-go) and log in to Github with your Github account.

1. Click the _Fork_ button at the top right of the page. Wait for the forking process, and once done, you should be brought to the new _turtle-wallet-go_ forked repository on your Github account.

1. Click _Settings_ and rename of your repository. Choose the name you want to be your Nest wallet called as. When you will build Nest, the name will be automatically taken from the name of your main folder (so the name of your repository). To avoid confusions and credit Nest, we advise to choose _MyCoin-Nest_, but you can choose whatever you want.

1. Once you have changed the name of your repository, clone it on your local machine. If you forked TurtleCoin, I guess you already know how to do that. Just make sure you clone it in your _GOPATH_ (if you have installed Go and the Qt/Go binding, you now know what the _GOPATH_ is).

1. Checkout a tag that was created around the time you forked TurtleCoin. If you forked TurtleCoin 2 months ago and did not include latest developments, there will be issues with the latest Nest as it evolved with TurtleCoin.

Now, before making the necessary changes in Nest, we will build your fork to make sure everything is ok. Nevertheless there is one thing we have to edit first before being able to build.

## Modify names

### Main name

You must modify all the occurrences of _TurtleCoin-Nest_ and _TurtleCoin Nest_ in the code by the name you chose (let's assume you chose _MyCoin-Nest_). The reason we have to do it before building is that some packages are referenced with their absolute path, and you changed the name of the main folder. Let us forget for now the files README.md and releases.md, you will do whatever you want with those files.

- in constants.go:

    ```Go
    logFileFilename             = "TurtleCoin-Nest.log"
    ```

- in main.go:

    in the import statement (that's the most important one):

    ```Go
    "TurtleCoin-Nest/turtlecoinwalletdrpcgo"
    "TurtleCoin-Nest/walletdmanager"
    ```

    and

    ```Go
    pathToAppFolder := pathToHomeDir + "/Library/Application Support/TurtleCoin-Nest"
    ```

- in walletdmanager/walletdmanager.go:

    in the import statement (that's also an important one):

    ```Go
    "TurtleCoin-Nest/turtlecoinwalletdrpcgo"
    ```

    and 2 occurences of

    ```Go
    pathToAppLibDir := pathToHomeDir + "/Library/Application Support/TurtleCoin-Nest"
    ```

    I know, I know, this could be refactored and put in constants or config files. It will be done at some point.

- in qml/nestmain.qml:

    ```QML
    title: "TurtleCoin Nest"
    ```

### TurtleCoin fork name

When you changed the name of your coin, you probably also modified the names of _TurtleCoind_ and _turlte-service_ (previously _walletd_). If you did so, you must also change the references of those names in Nest.

- in walletdmanager/constants.go, change, in the strings (not the variable names), _turtle-service_ by the name you chose when you forked TurtleCoin:

    ```Go
    logWalletdCurrentSessionFilename     = "turtle-service-session.log"
    logWalletdAllSessionsFilename        = "turtle-service.log"

    walletdCommandName                   = "turtle-service"
    ```

- in walletdmanager/constants.go, change, in the strings (not the variable names), _TurtleCoind_ by the name you chose when you forked TurtleCoin:

    ```Go
    logTurtleCoindCurrentSessionFilename = "TurtleCoind-session.log"
    logTurtleCoindAllSessionsFilename    = "TurtleCoind.log"

    turtlecoindCommandName               = "TurtleCoind"
    ```

## Building Nest

Now you are ready to build for testing your repo and your environment. I would advise to re-build and test for each little following modification you will make.

1. In your terminal or console, go to your _MyCoin-Nest_ main folder and run
    ```bash
    qtdeploy build desktop
    ```

    It takes around 10 seconds for the app to be built and you will see that a new subdirectory is automatically created: _deploy/*your os*/_. Your app is in that folder.

1. Include the _turtle-service_ and _TurtleCoind_ builds (or however you called them) in:
    - Windows/Linux: in the app folder
    - Mac: in _MyCoin-Nest.app/Contents/_ (right click on the .app and click on "show package content")

    (You can do that manually or, if you do it often, make a script that would build, copy those files, then run in one command.)

1. Run _MyCoin-Nest_:
    - Windows: _MyCoin-Nest.exe_
    - Mac: _MyCoin-Nest.app_
    - Linux: _MyCoin-Nest.sh_

## Logo

If you have a logo and you want the MyCoin-Nest app to have that logo, follow below steps.

### Windows

1. Export your logo in .ico format and name it "icon.ico"

1. Replace the _icon.ico_ in the root folder with your _icon.ico_

1. Open your console or terminal inside your project directory, then run `windres` like this:

    ```bash
    path/to/windres.exe icon.rc -o icon_windows.syso
    ```

    On my installation of Qt, _windres.exe_ is located in "C:\Qt\Tools\mingw530_32\bin\windres.exe".

    That command will create the file _icon_windows.syso_ in your project directory. It is that file which will be recognized by the build process and be used for giving a logo to your Windows build.

If you have an issue, all the steps are explained here: [Qt/Go binding - Setting the Icon on Windows](https://github.com/therecipe/qt/wiki/Setting-the-Application-Icon#setting-the-icon-on-windows).

### Mac

1. Create a .icns file based on your icon (if you do not know how to do that, Google is your friend).

1. Name that file "icon.icns" and replace the "icon.icns" file in "MyCoin-Nest/darwin/Contents/Resources/" with yours. It will then be automatically recognized by the building process.

### Linux

I could not figure it out for Linux yet.

### To be done additionally for all OS'

1. Create a .png version of your icon and name it "icon.png".

1. Replace the "icon.png" file in "MyCoin-Nest/qml/images/" with yours.

## All other things to modify or check

I recommend to build and test your modifications everytime you make a change, so that if you break something, it will be easier to debug.

### Ticker and address prefix

If you followed the _Forking TurtleCoin_ guide, you probably changed the ticker and address prefix for your coin. It would be great if you just had to change one parameter in Nest to reflect that change, but it would be too easy, wouldn't it? Naaa, Nest was not built with forkability in mind, so until Nest code is refactored, you will have to modify this manually in many places.

Search for "TRTL" in the code, and everytime it is in a string, change it for your ticker.

### Address size

TurtleCoin addresses are strings of 99 characters (187 for integrated addresses). If you changed those parameters, change them also in Nest code:

- in walletdmanager/walletdmanager.go, change the "99" and "187" by the sizes of your addresses and integrated addresses respectively:

    ```Go
    if !strings.HasPrefix(transferAddress, "TRTL") || (len(transferAddress) != 99 && len(transferAddress) != 187) {
        return "", errors.New("address is invalid")
    }
    ```

- in qml/wallet.qml, change the "187" by the size of your integrated addresses:

    ```Go
    /* Disable payment ID input if integrated address */
    textInputTransferPaymentID.enabled = textInputTransferAddress.text.length != 187
    ```

### Decimal point

TurtleCoin uses 2 decimal points. When you forked it, if you changed the parameter _CRYPTONOTE_DISPLAY_DECIMAL_POINT_, you should also change some pieces of code in Nest:

- in turtlecoinwalletdrpcgo/walletdrpc.go:

    - in func RequestBalance(...), replace the two occurrences of "100" by 10 exponent the decimal points you chose. e.g. If you chose 5, divide by 100000.

    - in func RequestListTransactions(...), do the same for the two occurrences of "100".

    - in func SendTransaction(...), do the same for the two occurrences of "100".

    - in func EstimateFusion(...), do the same for the one occurrence of "100".

    - in func SendFusionTransaction(...), do the same for the one occurrence of "100".

    - in func Feeinfo(...), do the same for the one occurrence of "100".

- in main.go:

    - I use the _humanize_ lib to create strings from floats. With that lib, you can specify how you want your float to be displayed. In the following lines, replace the "#,###.##" with the format of your choosing. If you want more decimal points, add "#" after the ".":

        ```Go
        func getAndDisplayBalances() {

            walletAvailableBalance, walletLockedBalance, walletTotalBalance, err := walletdmanager.RequestBalance()
            if err == nil {
                qmlBridge.DisplayAvailableBalance(humanize.FormatFloat("#,###.##", walletAvailableBalance))
                qmlBridge.DisplayLockedBalance(humanize.FormatFloat("#,###.##", walletLockedBalance))
                balanceUSD := walletTotalBalance * rateUSDTRTL
                qmlBridge.DisplayTotalBalance(humanize.FormatFloat("#,###.##", walletTotalBalance), humanize.FormatFloat("#,###.##", balanceUSD))
            }
        }
        ```

    - In the following lines, replace the "2" at the end of the "humanize.FtoaWithDigits(xxxx, 2)" (3 occurrences) with the number of digits you want to be displayed after the decimal separator:

        ```Go
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

        ```

### Mixin

At different points in time (based on block height), TurtleCoin had optional mixins or minimum mixins or fixed mixins. You should choose to checkout Nest at a specific tag based on the time you forked TurtleCoin and the mixin parameters you chose.

### Other small modifications

- in constants.go:

    - `urlCryptoCompareTRTL`: if your coin is listed on cryptocompare.com, modify the ticker in the url, otherwise remove the exchange rate feature entirely.

    - `defaultRemoteDaemonAddress` and `defaultRemoteDaemonPort`: modify based on your most reliable remote node.

    - `urlBlockExplorer`: insert the url of your most reliable block explorer.

- in walletdmanager/constants.go:

    - `DefaultTransferFee`: choose your default transfer fee.

- in turtlecoinwalletdrpcgo/walletdrpc.go:

    - `rpcURL = "http://127.0.0.1:8070/json_rpc"`: change the port (8070) to another one if you changed that parameter.