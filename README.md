# DECENOMY (DMY) Masternode Multinode Script

Detailed documentation can be found at https://docs.decenomy.net/tutorials/decenomy-multinode-script

## Overview

This script was created to manage all coins related to DECENOMY, making it easy to handle masternode multinode installations and maintenance. With this tool, it´s possible to:

- Easily manage the masternodes of multiple coins in each system
- Track the status of your wallet
- Check masternode status with Explorer
- Perform maintenance tasks such as wallet updates, bootstraps, and connection management

The script will always have the latest wallet coin versions available as soon as they are released on each Github repo, which is handy and avoids the need to re-release the script each time.


## Install and launch

The script was designed to be installed on pre-purchased Virtual Private Servers (VPS) running a Linux distribution.

**To install and run the script for the first time**, copy and paste the full command below into a terminal prompt :

**`wget -q https://raw.githubusercontent.com/decenomy/mnscript/main/decenomy.sh && bash decenomy.sh`**


After the first run, the script will convert the file " *decenomy.sh* " into an executable file named decenomy. Therefore, the user can simply type the **following command at the terminal prompt to run the script the next time:**

**`./decenomy`**

## Environment basis

The installation of files provided by this script has been carried out in a proper manner, with due consideration given to the best security practices. 

As a result, the files will not be deployed at the root level, as is common with similar tools. 
Instead, every instance of coin installation will create its own user ID on the Linux system files, with the coin name serving as the identifier for the deployment location of the coin blockchain respective files.

Please take into consideration the exact file locations, using the coin sapphire as an example.

|Description   |Directory  |Example ( when need )|
| ------------ | ------------ | ------------ |
|$HOME directory   | /home/users/   | - 
|Directory of user ID   | /home/users/userID/ |/home/users/sapphire/|
|Wallet files location for user id   | /home/users/userID/.coin |/home/users/sapphire/.sapphire|
|Daemon location | /usr/local/bin/|-|
|Service files directory | /etc/systemd/system/ |-|

In case of need for terminal access to the mention directories and files please follow the next steps:

|Description   |Command  |Example |
| ------------ | ------------ | ------------ |
| To enter in userID  | su - userID  | su - sapphire  |
| To logout from userID  | exit  |exit   |

