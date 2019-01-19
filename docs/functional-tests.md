# Functional tests to be done on windows, mac and linux before merging to master and deploying a release.

Action | Result
---|---
Open wallet by clicking on the "Open" button | busy indicator for a few seconds then wallet opens and display balance, etc..., sync is ok
Open wallet by typing return key while in password field | busy indicator for a few seconds then wallet opens and display balance, etc..., sync is ok
Click on button to backup keys with old wallet | backup private keys are displayed (check the window is large enough)
Click on button to backup keys with HD wallet | backup seed is displayed
Click on button to copy keys to clipboard | Keys are copied to clipboard
Click create wallet | dialog to confirm the password
Click create wallet and enter wrong password confirmation | error
Create wallet | busy indicator for a few seconds, then the wallet should be created in app folder and wallet open and display backup keys
Create wallet with name already exist in folder | error: same filename already exist
Open wallet -> Close wallet | Wallet closes
Import wallet, switch between seed and keys | proper fields should be enabled
Import wallet from keys | dialog to confirm the password
Import wallet from keys and enter wrong password confirmation | error
Import wallet from keys | wallet created in app folder. Check backup keys, address, balance.
Import wallet from seed | wallet created in app folder. Check backup seed, address, balance.
Open existing wallet -> close Nest -> reopen Nest | path to previously opened wallet should appear. Test opening it again without changing path. 
Button copy address | Pop up "Copied!" and address should be copied to clipboard.
Button copy tr. id | Pop up "Copied!" and tr. id should be copied to clipboard.
Button explore transaction | Trtl explorer opens in default browser with the right transacton.
Receive trtl | Balance updates automatically and new confirmed transaction added to list previous transactions
Send TRTL, address diff. than 99 chars or 187 chars | error: address invalid
Send TRTL, address not start by TRTL | error: address invalid
Send TRTL, amount is 0 or less | error: amount should be greater than 0
Send TRTL, amount is not a number | error: amount invalid
Send TRTL, amount + fee is more than available balance | error: available balance is insufficient
Send TRTL, small valid amount | dialog for confirming transfer. After confirmation, popup TRTL sent. amount is received on the other end
Send TRTL, invalid payment id | error: wrong payment id format
Send TRTL, valid payment id | popup TRTL sent. amount is received on the other end with correct payment id
Send TRTL, valid integrated address | popup TRTL sent. amount is received on the other end with correct payment id from integrated address
Select the option local blockchain, restart | local blockchain should still be selected
Open wallet with local blockchain selected and TurtleCoind started before | TurtleCoind should not be started automatically and should not close after wallet is closed
Open wallet with local blockchain selected and TurtleCoind not started before | TurtleCoind should start automatically and should close after Nest is closed
Test using the wallet with local blockchain selected | 
Test using the wallet with remote node selected |
Reduce window height and test scrolling |
Check wallet filename is displayed above address |
Click Settings | Settings screen appears
Close Settings | Settings screen disappears
Settings: Enable display in USD -> Close Nest -> Reopen | Setting is still enabled
Display in USD enabled -> Open a wallet| Balance is displayed in USD (under TRTL balance)
Display in USD enabled -> type an amount to be transferred| Value is displayed in USD
Settings: change remote node address and port -> click save -> close and reopen Nest | new address in remote node radio button and in settings
Settings: click remote node reset to default -> close and reopen Nest | default address in remote node radio button and in settings
Win only: open a wallet | no black window (turtle-service) should open next to the nest window
Win & Mac only: check executable file | its icon is the nest icon
Win & Mac only: launch nest | icon in taskbar should be nest icon
Launch on a small screen or resolution (800 x 600) | possibility to click full screen and to scroll in the full window
Click button to send full balance | Full balance - fee is automatically displayed in transfer amount field
Transfer with different fee | Check transfer was made with proper fee
Modify transfer fee, then click "default values" | Default value should be displayed in corresponding field
List transactions | 20 transactions are displayed
Switch to display "all transactions" then switch back | Proper number of transactions are displayed
Start application and check log file | version of Nest in "application started" log should be correct
Connect to wrong remote node | error message about connection problem
Click "?" to open Info screen from main screen | info dialog opens, check version
Click "?" to open Info screen from wallet screen | info dialog opens
Open info dialog, click link to chat | browser opens on chat url
Open info dialog, click copy donation address | donation address copied to clipboard
Mac only: open Nest on retina screen | resolution is retina
Open Nest and new version available | displayed at start in info screen
If send transaction with size too large, proposed to do fusion -> click fusion | fusion transaction is made

## Check in the code

- Version number
- No log.Debug remaining
- TurtleCoind and turtle-service included in the bundle
- latest checkpoint csv included in the bundle (same location as TurtleCoind)
