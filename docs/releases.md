# Releases

## 0.37

### Release notes

- Updated to patch for CLI argument discrepancies in turtle-service
- Includes TurtleCoin core 0.12.0 (turtle-service and TurtleCoind) and checkpoints.csv as of 12th of January 2019.

## 0.36

### Release notes

- Button to export history of transactions in csv files.
- Display local daemon sync status besides wallet sync status.
- Display names of remote nodes instead of urls in dropdown list.
- Display nodes fees in list of remote nodes.
- Move log files into a log folder.
- Various small improvements.
- Includes TurtleCoin core 0.8.4 (turtle-service and TurtleCoind) and checkpoints.csv as of 29th of October 2018.

### Sha256

TurtleCoin-Nest-0.36-Windows.zip:
`a54285fef3863a3bdc03f3e3af2e3abcc88305767239d1f4cb0615c6c0b75613`

TurtleCoin-Nest-0.36-Mac.zip:
`b370c8fa0b7c98d38ec97ab558794e2c2bee0a759d19c219390422ef8393001a`

TurtleCoin-Nest-0.36-Linux.tar.gz:
`a9f9ea43a195683b2dcdb85437fb1aa0175fc793ceb05cf0e101dad4d5ba6f11`

## 0.35

### Release notes

- Dropdown list for choosing a remote node (list is requested from https://github.com/turtlecoin/turtlecoin-nodes-json).
- Can use checkpoints for syncing local chain (includes checkpoints.csv as of 3rd of October 2018).
- Various small improvements.
- Includes TurtleCoin core 0.8.3 (turtle-service and TurtleCoind).

### Sha256

TurtleCoin-Nest-0.35-Windows.zip:
`7c41be52bf33af36172f12f9aac9ce5d04cb4b6942dbcf24b2f6092f8964ea19`

TurtleCoin-Nest-0.35-Mac.zip:
`8ce0a26cde80fd4f12e02382257195dd43865e94adf1acd20752be0033db2623`

TurtleCoin-Nest-0.35-Linux.tar.gz:
`dc34af24c8e6c9d11a28503514895aa3275c6d80775fbd4e5717f249d8a4c655`

## 0.34

### Release notes

- Address directory (save the addresses you use often).
- Choose a block height (scan height) for importing a wallet.
- Includes TurtleCoin core 0.8.3 (turtle-service and TurtleCoind).

### Sha256

TurtleCoin-Nest-0.34-Windows.zip:
`968c38f4eb6d8b985d0133489bd43e8397a406a076c9e267225fd20fe97c90f7`

TurtleCoin-Nest-0.34-Mac.zip:
`8b13f32e587d46ff1565d4e62fe391d9aec6adb09172bff80e522111b208f201`

TurtleCoin-Nest-0.34-Linux.tar.gz:
`53e5ab1da58a267d100ad362bd80eb1bd37b77200e8949e6cb339a678a39ba00`

## 0.32

### Release notes

- Compatibility with new fees from remote nodes (if you connect to a remote node, the node can charge you a fee per transaction, as a compensation for their running costs).
- Compatibility with core 0.8.0
- Uses turtle-service and TurtleCoind 0.8.0.

### Sha256

TurtleCoin-Nest-0.32-Windows.zip:
`0957dfcd42aa4fa3332d4419c888144cbf0fc0cd8f3ce4b3b2954e2d57dc9858`

TurtleCoin-Nest-0.32-Mac.zip:
`a84eb3d5e56e3bcae27c6688ba070a6a7393a4141b1aa7eb1217cc4082e7957e`

TurtleCoin-Nest-0.32-Linux.tar.gz:
`910cc9e8abc8cf55af43c908d9a456c88c659e03c3fda4679b08c78b9e094ca4`

## 0.31

### Release notes

- Possibility to use local blockchain is re-enabled.
- Possibility to send to integrated addresses
- Fixed resolution on high res screens on Windows
- Added scrollbar when window is smaller than nominal height
- Uses turtle-service and TurtleCoind 0.7.0.

Regarding the local blockchain option: TurtleCoind will be launched in the background if you did not launch it manually. Some difficulties can arise, please check the different log files to understand the problem (especially TurtleCoind-session.log) or ask some help in the discord. You will also avoid issues if you launch TurtleCoind manually before launching Nest (and potentially wait for sync). Please tell us if you have issues so we can improve for the next release. 

### Sha256

TurtleCoin-Nest-0.31-Windows.zip:
`e3f6ad0f377528fd3e28d30a9ae9a8db69229f5ffd00a272993808db25ee49d6`

TurtleCoin-Nest-0.31-Mac.zip:
`f2325823c268be8b8bc3feeaece0f4d141a13e80a2cbbfe49b55420afa0baa98`

TurtleCoin-Nest-0.31-Linux.tar.gz:
`cf24f364a5abba8d6464e4e48d9700a7705d2c84163436818844ea5edfb1f223`

## 0.30

### Release notes

- Backup new wallets with seed (25 words) and import wallet from seed.
- Possibility to optimize the wallet with a fusion transaction when too many inputs (solves the "transaction is too big" error).
- Mixin is set to 7 (in line with new protocol rules).
- Message when new version of Nest is available.
- Retina resolution on macs retina.
- uses walletd 0.6.3.
- Local blockchain option is still unavailable (due to a bug in walletd). Only connection option is via remote node. Use the CLI if you need to sync locally. Sorry for the inconvenience. We are working on bringing it back.

### Sha256

TurtleCoin-Nest-0.30-Windows.zip:
`4b48a21840821af92b7ce758361e9c426ffdf6b3b757c2b9ff74f0d36e8f9bf3`

TurtleCoin-Nest-0.30-Mac.zip:
`36c63e9807dc900076a04f27cc76ee8c412be4bc4beeef93f0d0ab9a44e1840d`

TurtleCoin-Nest-0.30-Linux.tar.gz:
`564dcb179fd1beea7d25f69d3671db55a0a18fad661642d38ce8cc2b3412030c`

## 0.23

### Release notes

- IMPORTANT: Local blockchain option is temporarily unavailable (due to a bug in walletd). Only connection option is via remote node. Use the CLI if you need to sync locally. Sorry for the inconvenience. We are working on bringing it back.
- uses walletd 0.6.2 (which incorporates bug fixes that were causing crashes of Nest).
- info page with Nest version.
- keeps status of wallet sync even if walletd crashes.
- default mixin changed to 7.
- various other improvements and bug fixes.

### Sha256

TurtleCoin-Nest-0.23-Windows.zip:
`2be201454c84838e849fb726c2b14775c9c37dac1c387efcfaa2dc16deed9ef4`

TurtleCoin-Nest-0.23-Mac.zip:
`42c121876fdc9c79872f932fa1f704bfdca8bde269c53d0c478aa4327b318b9a`

TurtleCoin-Nest-0.23-Linux.tar.gz:
`da4ce5bf9c7d14f5a191a971e89e08e1ab3b36a57091cf84b38960d200a7f312`

## 0.22

### Release notes

- uses walletd 0.5.0
- wallet opens faster
- logs nest version in log file
- error message when connection problem with remote node
- fix a path problem when creating a shortcut to Nest on Linux
- fix crash when creating or importing a wallet

### Sha256

TurtleCoin-Nest-0.22-Windows.zip:
`6631538819c0d4ca1170c8dadcac4d45fc8441c1f9fdd4706b836028111b85d1`

TurtleCoin-Nest-0.22-Mac.zip:
`74c521f4e48b83a36e4a2b89d7d97ad6d60e9c3c38110a7ee96fbb20cf984caf`

TurtleCoin-Nest-0.22-Linux.tar.gz:
`3ec44cd936caddfdeb40ea29d776492917ceebe953319a8fbaea8884f1fe2565`

## 0.21

### Release notes

- possibility to modify fee and mixin count
- confirmation window when making a transfer
- confirmation of password when creating wallet
- can open a wallet by typing return key on keyboard (while in password field)
- button to send full balance
- on windows: no more black window (walletd)
- app icon for executable and task bar (win and mac)
- possibility to maximize window (useful for people with small sreen/resolution)
- various small improvements and bug fixes
- with walletd 0.4.2

### Sha256

TurtleCoin-Nest-0.21-Windows.zip:
`513551824ed887bd89d74ecd3b91d3a68653425f0230c965c734faddacad44b5`

TurtleCoin-Nest-0.21-Mac.zip:
`594de87d77da896715447b156657ea3f2639fd14977cf2992452ff7fcb49a581`

TurtleCoin-Nest-0.21-Linux.tar.gz:
`da5e12da3960e8c042f93070ed38a49fbb6f942dd69d52142101b6957b3cdc7d`

## 0.20

### Release notes

- various UI improvements
- display balance in USD, as well as transfer amounts (must be enabled in settings)
- possibility to connect to any remote node
- can scroll the window down (it was an issue on smaller screen)
- with walletd 0.4.2 (as users with older processors have issues with 0.4.3)

### Sha256

TurtleCoin-Nest-0.20-Windows.zip:
`29ae368acf147a24962f1f068fc8f3bcc002cbb8b0b515be517d948e1acc51fc`

TurtleCoin-Nest-0.20-Mac.zip:
`57e430a91d8aa8efb3748b8209fc302645f6e11c73f99400d0adfd4e525abe7b`

TurtleCoin-Nest-0.20-Linux.tar.gz:
`0034e9609d8033f26ac77b78026bd7b1645743e0eb5453b79c8815098d849e2e`

## 0.15

### Release notes

- with walletd 0.4.3

### Sha256

TurtleCoin-Nest-0.15-Windows.zip:
`0a198732ca2368991b6334135e3745206450b79fd26a47aec6632464c389a5f1`

TurtleCoin-Nest-0.15-Mac.zip:
`63b9859b2e6f11b105c44cfce331843ca4fa7694c1a6fbad2730877e65e79728`

TurtleCoin-Nest-0.15-Linux.tar.gz:
`255504c49f289839d699cb6f95b22831c099db1f90598ddd4df67be6bbe44b35`

## 0.14

### Release notes

- with walletd 0.4.2 (after 350,000 fork / mining algo change)

### Sha256

TurtleCoin-Nest-0.14-Windows.zip:
`1951be4812059dff1211033c9a0187c5d92a389f20cd64b60c5a4885f8d11d53`

TurtleCoin-Nest-0.14-Mac.zip:
`542c93a29c34064a3d33ebba769088b92186933bffa0518322551c4d122ebdd1`

TurtleCoin-Nest-0.14-Linux.tar.gz:
`cf2da15013c4f3eb785eedf1d1c0c3ddf6afd8275c7a573c6c2478170efa58e3`

