#!/bin/bash

# DECENOMY (DMY) Masternode Multinode Script.
# Designed to automate masternode multinode installation on pre-purchased Virtual Private Servers (VPS), with maintenance features built in.
# (c) João@DECENOMY, 2023
# All rights reserved 
# MIT License

# Term colors.
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'

# Predefined Constants.
ASCII_L="--│█│█"
ASCII_R="│█│█--"
ASCII_LINE="--------------------------------------------------------------"
SCRIPVERSION=v1.0.4
SCRIPT_GITHUB=https://api.github.com/repos/decenomy/mnscript/releases/latest
SCRIPT_FILE=`curl -s $SCRIPT_GITHUB | grep "browser_download_url.*decenomy.sh" | cut -d : -f 2,3 | tr -d \" | xargs`
NODEIP=$(curl --fail --retry 3 -s4 icanhazip.com)
if [[ -z "$NODEIP" ]]; then
  #if we get here, then most likely icanhazip.com is timing out
  echo -e "${RED}Failed to determine IP address. Please wait a couple minutes and rerun script. If this continues, ask for assistance in discord.${NC}"
  exit 1
fi

# Header for menu screen.
header() {
  echo
  echo -e "${BLUE}${BOLD}
  \t\t    ██████╗ ███╗   ███╗██╗   ██╗
  \t\t    ██╔══██╗████╗ ████║╚██╗ ██╔╝
  \t\t    ██║  ██║██╔████╔██║ ╚████╔╝ 
  \t\t    ██║  ██║██║╚██╔╝██║  ╚██╔╝  
  \t\t    ██████╔╝██║ ╚═╝ ██║   ██║   
  \t\t    ╚═════╝ ╚═╝     ╚═╝   ╚═╝   
  \t\t                       $SCRIPVERSION${NC}
  \t\t   DECENOMY Masternode Script
  \t\t ******************************"
  echo
}

# Title allign for menu screen.
allign() {
  local COIN_NAME=$COIN_NAME
  local TEXT_1=$2
  local TEXT_2=$3
  local COIN_NAME_LEN=${#COIN_NAME}
  local TEXT_1_LEN=${#TEXT_1}
  local TEXT_2_LEN=${#TEXT_2}
  local MAX_LEN=58
  local ASCII_L_LEN=${#ASCII_L}
  local ASCII_R_LEN=${#ASCII_R}
  local TOTAL_LEN=$((ASCII_L_LEN + TEXT_1_LEN + COIN_NAME_LEN + TEXT_2_LEN + ASCII_R_LEN))
  local PADDING=$(((MAX_LEN - TOTAL_LEN + 1) / 2))
  
  if [ "$PADDING" -lt 0 ]; then
    PADDING=0
  fi

  printf "%s\n" "$ASCII_LINE"
  printf "%*s%s%s${GREEN}%s${NC}%s%s%*s\n" $PADDING "" "$ASCII_L" "  $TEXT_1" "$COIN_NAME" " $TEXT_2 " "$ASCII_R" $PADDING ""
  printf "%s\n" "$ASCII_LINE"
}

# Variable.
var_overview() {
  TICKER1=""
  COIN_NAME1=""
  COIN_CLI1=""

  case "$dir" in
    */.azzure) TICKER1="AZR"; COIN_NAME1="azzure"; COIN_CLI1="azzure-cli" ;;
    */.beacon) TICKER1="BECN"; COIN_NAME1="beacon"; COIN_CLI1="beacon-cli" ;;
    */.birake) TICKER1="BIR"; COIN_NAME1="birake"; COIN_CLI1="birake-cli" ;;
    */.cryptoflow) TICKER1="CFL"; COIN_NAME1="cryptoflow"; COIN_CLI1="cryptoflow-cli" ;;
    */.cryptosaga) TICKER1="SAGA"; COIN_NAME1="cryptosaga"; COIN_CLI1="cryptosaga-cli" ;;
    */.dashdiamond) TICKER1="DASHD"; COIN_NAME1="dashdiamond"; COIN_CLI1="dashdiamond-cli" ;;
    */.eskacoin) TICKER1="ESK"; COIN_NAME1="eskacoin"; COIN_CLI1="eskacoin-cli" ;;
    */.flits) TICKER1="FLS"; COIN_NAME1="flits"; COIN_CLI1="flits-cli" ;;
    */.jackpot) TICKER1="777"; COIN_NAME1="jackpot"; COIN_CLI1="jackpot-cli" ;;
    */.kyanite) TICKER1="KYAN"; COIN_NAME1="kyanite"; COIN_CLI1="kyanite-cli" ;;
    */.mobic) TICKER1="MOBIC"; COIN_NAME1="mobic"; COIN_CLI1="mobic-cli" ;;
    */.monk) TICKER1="MONK"; COIN_NAME1="monk"; COIN_CLI1="monk-cli" ;;
    */.oneworld) TICKER1="OWO"; COIN_NAME1="oneworld"; COIN_CLI1="oneworld-cli" ;;
    */.peony) TICKER1="PNY"; COIN_NAME1="peony"; COIN_CLI1="peony-cli" ;;
    */.sapphire) TICKER1="SAPP"; COIN_NAME1="sapphire"; COIN_CLI1="sapphire-cli" ;;
    */.suvereno) TICKER1="SUV"; COIN_NAME1="suvereno"; COIN_CLI1="suvereno-cli" ;;
    */.ultraclear) TICKER1="UCR"; COIN_NAME1="ultraclear"; COIN_CLI1="ultraclear-cli" ;;
  esac
}

var_azr() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='azzure.conf'
  CONFIGFOLDER='/home/users/azzure/.azzure'
  COIN_DAEMON='azzured'
  COIN_CLI='azzure-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='azzure'
  TICKER='AZR'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=14725
  RPC_PORT=14724
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_becn() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='beacon.conf'
  CONFIGFOLDER='/home/users/beacon/.beacon'
  COIN_DAEMON='beacond'
  COIN_CLI='beacon-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='beacon'
  TICKER='BECN'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status	
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=36552
  RPC_PORT=36553
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_bir() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='birake.conf'
  CONFIGFOLDER='/home/users/birake/.birake'
  COIN_DAEMON='biraked'
  COIN_CLI='birake-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='birake'
  TICKER='BIR'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status	
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=39697
  RPC_PORT=39698
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_cfl() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='cryptoflow.conf'
  CONFIGFOLDER='/home/users/cryptoflow/.cryptoflow'
  COIN_DAEMON='cryptoflowd'
  COIN_CLI='cryptoflow-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='cryptoflow'
  TICKER='CFL'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=13333
  RPC_PORT=13334
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_saga() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='cryptosaga.conf'
  CONFIGFOLDER='/home/users/cryptosaga/.cryptosaga'
  COIN_DAEMON='cryptosagad'
  COIN_CLI='cryptosaga-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='cryptosaga'
  TICKER='SAGA'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_NAME='cryptosaga'
  COIN_PORT=37552
  RPC_PORT=37553
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_dashd() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='dashdiamond.conf'
  CONFIGFOLDER='/home/users/dashdiamond/.dashdiamond'
  COIN_DAEMON='dashdiamondd'
  COIN_CLI='dashdiamond-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='dashdiamond'
  TICKER='DASHD'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=12341
  RPC_PORT=23452
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_esk() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='eskacoin.conf'
  CONFIGFOLDER='/home/users/eskacoin/.eskacoin'
  COIN_DAEMON='eskacoind'
  COIN_CLI='eskacoin-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='eskacoin'
  TICKER='ESK'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=14215
  RPC_PORT=14214
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_fls() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='flits.conf'
  CONFIGFOLDER='/home/users/flits/.flits'
  COIN_DAEMON='flitsd'
  COIN_CLI='flits-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='flits'
  TICKER='FLS'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status	
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=32972
  RPC_PORT=32973
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_777() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='jackpot.conf'
  CONFIGFOLDER='/home/users/jackpot/.jackpot'
  COIN_DAEMON='jackpotd'
  COIN_CLI='jackpot-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='jackpot'
  TICKER='777'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=17771
  RPC_PORT=27772
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_kyan() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='kyanite.conf'
  CONFIGFOLDER='/home/users/kyanite/.kyanite'
  COIN_DAEMON='kyanited'
  COIN_CLI='kyanite-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='kyanite'
  TICKER='KYAN'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=7757
  RPC_PORT=7758
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_mobic() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='mobic.conf'
  CONFIGFOLDER='/home/users/mobic/.mobic'
  COIN_DAEMON='mobicd'
  COIN_CLI='mobic-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='mobic'
  TICKER='MOBIC'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=22487
  RPC_PORT=22488
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_monk() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='monk.conf'
  CONFIGFOLDER='/home/users/monk/.monk'
  COIN_DAEMON='monkd'
  COIN_CLI='monk-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='monk'
  TICKER='MONK'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=32270
  RPC_PORT=32271
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_owo() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='oneworld.conf'
  CONFIGFOLDER='/home/users/oneworld/.oneworld'
  COIN_DAEMON='oneworldd'
  COIN_CLI='oneworld-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='oneworld'
  TICKER='OWO'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=32112
  RPC_PORT=32113
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_pny() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='peony.conf'
  CONFIGFOLDER='/home/users/peony/.peony'
  COIN_DAEMON='peonyd'
  COIN_CLI='peony-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='peony'
  TICKER='PNY'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=36779
  RPC_PORT=36780
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}	

var_sapp() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='sapphire.conf'
  CONFIGFOLDER='/home/users/sapphire/.sapphire'
  COIN_DAEMON='sapphired'
  COIN_CLI='sapphire-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='sapphire'
  TICKER='SAPP'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=45328
  RPC_PORT=45329
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_suv() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='suvereno.conf'
  CONFIGFOLDER='/home/users/suvereno/.suvereno'
  COIN_DAEMON='suverenod'
  COIN_CLI='suvereno-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='suvereno'
  TICKER='SUV'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=18976
  RPC_PORT=18977
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

var_ucr() {
  TMP_FOLDER=$(mktemp -d)
  CONFIG_FILE='ultraclear.conf'
  CONFIGFOLDER='/home/users/ultraclear/.ultraclear'
  COIN_DAEMON='ultracleard'
  COIN_CLI='ultraclear-cli'
  COIN_PATH='/usr/local/bin/'
  COIN_NAME='ultraclear'
  TICKER='UCR'
  GITHUB=https://api.github.com/repos/decenomy/$TICKER/releases/latest
  EXPLORER=https://explorer.decenomy.net/api/v2/$TICKER/status
  COIN_TGZ=`curl -s $GITHUB | grep "browser_download_url.*Linux\\.zip" | cut -d : -f 2,3 | tr -d \" | xargs`
  COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
  COIN_PORT=32628
  RPC_PORT=32627
  BOOTSTRAP=https://explorer.decenomy.net/bootstraps/$TICKER/bootstrap.zip
  user_creations
}

# Menu to select the coin we want to manage / install.
main_menu() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}\n"
  echo -e $ASCII_LINE
  echo -e $ASCII_L"   "Select the DECENOMY coin you want to manage"    "$ASCII_R
  echo -e $ASCII_LINE
  echo
  echo -e " "[-] Azzure - AZR"            |-|-|   "[-] Beacon - BECN
  echo -e " "[-] Birake - BIR"            |-|-|   "[4] Cryptoflow - CFL
  echo -e " "[-] Cryptosaga - SAGA"       |-|-|   "[6] Dash Diamond - DASHD
  echo -e " "[-] Eskacoin - ESK"          |-|-|   "[8] Flits - FLS
  echo -e " "[9] Jackpot - 777"           |-|-|   "[10] Kyanite - KYAN
  echo -e " "[11] Mobility Coin - MOBIC"  |-|-|   "[--] Monk - MONK
  echo -e " "[--] One World - OWO"        |-|-|   "[14] Peony - PNY
  echo -e " "[15] Sapphire - SAPP"        |-|-|   "[--] Suvereno - SUV
  echo -e " "[--] Ultra Clear - UCR"      |-|-|   "
  echo
  echo -e $ASCII_LINE
  echo -e " "[18] ${YELLOW}Update this script${NC}"     |-|-|   "[19] ${YELLOW}Overview Center${NC}
  echo -e $ASCII_LINE
  echo -e "\t\t\t   [0]  Exit"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      #1) clear
      #   var_azr
      # ;;
      #2) clear
      #   var_becn
      # ;;
      #3) clear
      #   var_bir
      # ;;
      4) clear
         var_cfl
      ;;
      #5) clear
      #   var_saga
      # ;;
      6) clear
         var_dashd
      ;;
      #7) clear
      #   var_esk
      # ;;
      8) clear
         var_fls
      ;;
      9) clear
         var_777
      ;;
      10) clear
          var_kyan
      ;;
      11) clear
          var_mobic
      ;;
      #12) clear
      #    var_monk
      # ;;
      #13) clear
      #    var_owo
      # ;;
      14) clear
          var_pny
      ;;
      15) clear
          var_sapp
      ;;
      #16) clear
      #    var_suv
      # ;;
      #17) clear
      #    var_ucr
      # ;;
      18) clear
          update_script
      ;;
      19) clear
          overview_center
          main_menu
      ;;
      0) clear
         exit
      ;;
      *) clear
         echo -e " Please choose one of the options available "
         echo
         main_menu
      ;;
    esac
    read opt
  done
}

# Menu for wallets and masternodes options after selection of the coin we want.
coin_selected() {
  header_display() {
    echo -e "\t\t  ${YELLOW} Main Menu"
    echo -e "\t\t\t|- Coin selected${NC}\n"
    allign  "$COIN_NAME" "Coin selected " ""
  }
  if [ -f "$CONFIGFOLDER/activemasternode.conf" ]; then
    header
    header_display
    echo
    echo -e " "[1] Reinstall masternode multinode
    echo -e " "[2] Masternode multinode management
    echo -e " "[3] Stats wallet and masternode
    echo -e " "[4] Wallet management
    echo -e " "[5] Others
    echo
    echo -e $ASCII_LINE
    echo -e "\t\t\t   [0]  Exit"
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           install_mn_multinode
        ;;
        2) clear
           mn_multinode_management
        ;;
        3) clear
           stats_wallet_mn
        ;;
        4) clear
           wallet_management
        ;;
        5) clear
           others
        ;;
        0) clear
           main_menu
        ;;
        *) clear
           echo -e " Please choose one of the options available "
           echo
           coin_selected
        ;;
      esac
      read opt
    done
  else 
 
    header
    header_display
    echo
    echo -e " "[1] Install masternode multinode
    echo -e " "[2] Others
    echo
    echo -e $ASCII_LINE
    echo -e "\t\t\t   [0]  Exit"
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           install_mn_multinode
        ;;
        2) clear
           others
        ;;
        0) clear
           main_menu
        ;;
        *) clear
           echo -e " Please choose one of the options available "
           echo
           coin_selected
        ;;
      esac
      read opt
    done
  fi
}

# Menu to install a masternode multinode.
install_mn_multinode() {
  if [ -f "$CONFIGFOLDER/activemasternode.conf" ]; then
    header
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t${YELLOW}|- Masternode multinode reinstallation${NC}\n"
    allign  "$COIN_NAME" "" "masternode multinode reinstallation"
    echo
    echo -e "\t\t\t   ${RED}WARNING${NC}"
    echo
    echo -e "        "This installation is for 
    echo -e "        "one ${GREEN}$COIN_NAME${NC} Masternode Multinode instance.
    echo 
    echo -e "        "There is a ${GREEN}$COIN_NAME${NC} Masternode 
    echo -e "        "installed in this machine, this action will
    echo -e "        "override that , and all related data will be lost.
    echo
    echo -e "        "Do you want to keep with the reinstallation ?
    echo
    echo
    echo -e $ASCII_LINE
    echo -e "    "[1] ${YELLOW}Yes${NC}"     |-|-|     "[0] ${YELLOW}No, go back to previous menu${NC}
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt
    
    while true; do
      case $opt in
        1) clear
           purge_old_installation
           checks
           prepare_system
           download_node
           setup_mn_multinode
           coin_selected
        ;;
        0) clear
           coin_selected
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           install_mn_multinode
        ;;
      esac
      read opt
    done
  else

    purge_old_installation
    checks
    prepare_system
    download_node
    setup_mn_multinode
    coin_selected
  fi
}

# Menu to manage activemasternode file for multinode on installation.
activemasternode_multi() {
  clear
  header
  allign  "$COIN_NAME" "Add " "masternodes to multinode list"
  echo
  echo
  echo -e " ""Do you want to manage the masternodes for multinode purpose ?"
  echo
  echo -e $ASCII_LINE
  echo -e "    "[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, will do that later${NC}
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         add_multinode_masternode
      ;;
      0) clear
         coin_selected
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         activemasternode_multi
      ;;
    esac
    read opt
  done
}

# Menu to masternode multinode management.
mn_multinode_management() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t${YELLOW}|- Masternode multinode management${NC}\n"
  allign  "$COIN_NAME" "" "Masternode multinode management"
  echo
  echo -e " "[1] List of masternodes in multinode List
  echo -e " "[2] Add masternode to multinode List
  echo -e " "[3] Delete masternode from multinode List
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         list_multinode_masternode
      ;;
      2) clear
         add_multinode_masternode
      ;;
      3) clear
         delete_multinode_masternode
      ;;
      0) clear
         coin_selected
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         mn_multinode_management
      ;;
    esac
    read opt
  done
}

# Menu to list masternodes information from the activemasternode file for multinode.
list_multinode_masternode() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Masternode multinode management"
  echo -e "\t\t\t${YELLOW}|- List of Masternodes in Multinode${NC}\n"
  allign  "$COIN_NAME" "List of " "Masternode in Multinode"
  echo
  echo -e " This is the content of the file ${YELLOW}activemasternode.conf${NC}"
  echo -e " from ${GREEN}$COIN_NAME${NC} masternode multinode"
  echo
  echo
  cat $CONFIGFOLDER/activemasternode.conf
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo 
  read -p " Enter the number option: " -n 1 -r

  if [ "$REPLY" == "0" ]; then
    read -p "" -n 1 -r
    clear
    mn_multinode_management
  else
    clear
    list_multinode_masternode
  fi
  clear
}

# Menu to add masternodes information in the activemasternode file for multinode.
add_multinode_masternode() {
  header_display() {
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t|- Masternode multinode management${NC}"
    echo -e "\t\t\t${YELLOW}|- Add masternodes to multinode list${NC}\n"
    allign  "$COIN_NAME" "Add " "masternode to multinode list"
    echo
    echo -e " "This is the content of the file ${YELLOW}activemasternode.conf${NC}
    echo -e " "from ${GREEN}$COIN_NAME${NC} multinode
    echo 
    cat $CONFIGFOLDER/activemasternode.conf
    echo
    echo -e $ASCII_LINE
    echo
    echo -e " "To add more you will need to enter the ${YELLOW}alias${NC} you want and also
    echo -e " "the ${CYAN}MasternodeKey${NC} for your ${GREEN}$COIN_NAME${NC} masternode
    echo
    echo -e " "Guideline:
    echo -e " "Format: ${YELLOW}alias${NC} ${CYAN}MasternodeKey${NC}
    echo
    echo -e " "Example: ${YELLOW}mn1${NC} ${CYAN}93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg${NC}
    echo
    echo -e $ASCII_LINE
  }

  header
  header_display
  echo	
  echo -e  " ( if you want to exit, press the number 0 )"
  echo
  echo -e  " "Please introduce just the ${YELLOW}alias${NC}
  echo
  read ALIAS

  if [ -z "$ALIAS" ]; then
    clear
    echo "Alias cannot be empty. Please try again."
    add_multinode_masternode
    elif [ "$ALIAS" == "0" ]; then
    echo "Exiting the function"
    clear
    mn_multinode_management
  else
    clear
    header
    header_display
    echo
    echo -e " "${YELLOW}Alias created : ${NC}$ALIAS
    echo
    create_key
    echo
    echo
    echo $ALIAS $COINKEY >> $CONFIGFOLDER/activemasternode.conf
    echo
  fi

  while true; do
    clear
    header
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t|- Masternode multinode management${NC}"
    echo -e "\t\t\t${YELLOW}|- Add masternodes to multinode list${NC}\n"
    allign  "$COIN_NAME" "Add " "masternode to multinode list"
    echo
    echo
    echo -e " This is the content of the file ${YELLOW}activemasternode.conf${NC}"
    echo -e " from ${GREEN}$COIN_NAME${NC} multinode"
    echo
    cat $CONFIGFOLDER/activemasternode.conf
    echo
    echo -e $ASCII_LINE
    echo
    echo -e " For your ${GREEN}$COIN_NAME${NC} multinode masternode"
    echo -e " Do you want to register another masternode?" 
    echo
    echo -e $ASCII_LINE
    echo -e	"\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    case $opt in
      1) clear
         add_multinode_masternode
      ;;
      0) clear
         mn_multinode_management
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         continue
      ;;
    esac
    read opt
  done		
}

# Menu to delete masternodes information in the activemasternode file for multinode.
delete_multinode_masternode() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Masternode multinode management${NC}"
  echo -e "\t\t\t${YELLOW}|- Delete masternodes from multinode list${NC}\n"
  allign  "$COIN_NAME" "Delete Masternodes from " "Multinode List"
  echo
  echo -e  "This is the content of your  ${YELLOW}activemasternode.conf${NC} file"
  echo -e  "from ${GREEN}$COIN_NAME${NC} multinode"
  echo
  nl $CONFIGFOLDER/activemasternode.conf
  echo
  echo -e $ASCII_LINE
  echo
  echo -e Please select the number of the line you want to delete
  echo
  echo -e "( if you want to exit, please press the number 0 )"
  echo
  read NUMBER

  if ! expr "$NUMBER" : '[0-9]*' > /dev/null; then
    clear
    echo -e " Please choose one of the options available"
    delete_multinode_masternode
  elif [ $NUMBER -eq 0 ]; then
    echo -e " Exiting the function"
    clear
    mn_multinode_management
    elif [ $NUMBER -gt $(wc -l < $CONFIGFOLDER/activemasternode.conf) ]; then
    clear
    echo -e " The selected line number is not available"
    delete_multinode_masternode
  else
    echo 
    clear
  fi

  while true; do
    header
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t|- Masternode multinode management${NC}"
    echo -e "\t\t\t${YELLOW}|- Delete masternodes from multinode list${NC}\n"
    allign  "$COIN_NAME" "Delete Masternodes from " "Multinode List"
    echo
    echo -e "  Do you really want to delete the line number $NUMBER from"
    echo -e "  ${YELLOW}activemasternode.conf${NC} file ?"
    echo
    echo -e "  "$(cat $CONFIGFOLDER/activemasternode.conf | head -n $NUMBER | tail -n 1)
    echo
    echo -e $ASCII_LINE
    echo -e	"\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    case $opt in
      1) clear
         sed -i "${NUMBER}d" $CONFIGFOLDER/activemasternode.conf
         delete_multinode_masternode
      ;;
      0) clear
         delete_multinode_masternode
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         continue
      ;;
    esac
    read opt
  done
}

# Menu for wallet management.
wallet_management() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t${YELLOW}|- Wallet management ${NC}\n"
  allign  "$COIN_NAME" " " " Wallet management "
  echo
  echo -e " "[1] Update wallet
  echo -e " "[2] Apply bootstrap
  echo -e " "[3] Clean peers and banlist
  echo -e " "[4] Connections management
  echo -e " "[5] Restart service
  echo -e " "[6] Delete wallet
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         update_wallet
      ;;
      2) clear
         apply_bootstrap
      ;;
      3) clear
         peer_banlist_delete
         wallet_management
      ;;
      4) clear
         connections_management
         wallet_management
      ;;
      5) clear
         restart_service
         wallet_management
      ;;   
      6) clear
         delete_wallet
      ;;
      0) clear
         coin_selected
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         wallet_management
         clear
      ;;
    esac
    read opt
  done
}

# Menu to apply a wallet update.
update_wallet() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t${YELLOW}|- Update wallet${NC}\n"
  allign  "$COIN_NAME" " " "Masternode wallet update"
  echo
  echo -e " "Wallet version on Github"  : "${YELLOW}$(curl -s $GITHUB | jq -r '.tag_name')${NC}
  echo
  echo -e " "Wallet version installed"  : "${YELLOW}$($COIN_CLI -version | awk '{print $5}' | awk -F '-' '{print $1}')${NC}
  echo
  echo -e " "Do you want to update it ?
  echo
  echo -e $ASCII_LINE
  echo -e "\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         update_wallet_process
         wallet_management
      ;;
      0) clear
         wallet_management
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         update_wallet
      ;;
    esac
    read opt
  done
}

# Menu to apply bootstrap in the wallet files.
apply_bootstrap() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t${YELLOW}|- Apply bootstrap ${NC}\n"
  allign  "$COIN_NAME" "Bootstrap for " "masternode wallet"
  echo
  echo -e " "This process will apply a bootstrap for ${GREEN}$COIN_NAME${NC} masternode wallet
  echo
  echo -e " "Do you want to keep with it?
  echo
  echo -e $ASCII_LINE
  echo -e "\t"[1]	${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         bootstrap
         peer_banlist_delete
         wallet_management
      ;;
      0) clear
         wallet_management
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         apply_bootstrap
      ;;
    esac
    read opt
  done
}

# Menu wallet connections management.
connections_management() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t${YELLOW}|- Wallet connections management${NC}\n"
  allign "$COIN_NAME" "" " Wallet connections management "
  echo
  echo -e " "[1] List of extra connections on the wallet
  echo -e " "[2] Add connections to the wallet 
  echo -e " "[3] Delete connections from the wallet 
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         list_connections
      ;;
      2) clear
         add_connections
      ;;
      3) clear
         delete_connections
      ;;
      0) clear
         echo -e "Reloading ${GREEN}$COIN_NAME${NC} Service..."
         reload_service
         clear
         coin_selected
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         connections_management
      ;;
    esac
    read opt
  done
}

# Menu to list connections from the wallet.
list_connections() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t|- Wallet connections management"
  echo -e "\t\t\t${YELLOW}|- List of extra wallet connections ${NC}"
  allign  "$COIN_NAME" "List of " "added connections on config file"
  echo
  echo -e " This is the content of the wallet config file that "
  echo -e " have the already added connections for ${GREEN}$COIN_NAME${NC} wallet"
  echo
  cat $CONFIGFOLDER/$CONFIG_FILE  | grep "^addnode"
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " -n 1 -r

  if [ "$REPLY" == "0" ]; then
    read -p "" -n 1 -r
    clear
    connections_management
  else
    clear
    list_connections
  fi
  clear
}

# Menu to add connections to the wallet.
add_connections() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t|- Wallet connections management"
  echo -e "\t\t\t${YELLOW}|- Add extra connections to the wallet${NC}\n"
  allign  "$COIN_NAME" "Add " " extra connections "
  echo
  echo -e " This is the content of the wallet config file that "
  echo -e " have the already added connections for ${GREEN}$COIN_NAME${NC} wallet"
  echo
  cat $CONFIGFOLDER/$CONFIG_FILE  | grep "^addnode"
  echo
  echo -e $ASCII_LINE
  echo
  echo -e " "Guideline:
  echo
  echo -e " "Please visit the explorer website
  echo
  echo -e " "${YELLOW}https://explorer.decenomy.net/$TICKER/peers${NC}
  echo
  echo -e " "- On connected network clients, following the last subversion  ${YELLOW}$(curl -s $GITHUB | jq -r '.tag_name')${NC}
  echo -e " "- Click on node list button.
  echo -e " "- Copy the content inside and past it below
  echo
  echo -e " "Please introduce just the addnodes followed by enter
  echo -e "( if you want to exit, please press enter )"
  echo

  while true; do
    read -r line
    if [ -z "$line" ]; then
      clear
      connections_management
    fi
    echo "$line" >> "$CONFIGFOLDER/$CONFIG_FILE"

    while true; do
      clear
      header
      echo -e "\t\t  ${YELLOW} Main Menu${NC}"
      echo -e "\t\t\t|- Coin selected"
      echo -e "\t\t\t|- Wallet management"
      echo -e "\t\t\t|- Wallet connections management"
      echo -e "\t\t\t${YELLOW}|- Add of extra wallet connections ${NC}\n"
      allign  "$COIN_NAME" "Add " " extra connections "
      echo
      echo -e " "Do you want to add more connections to ${GREEN}$COIN_NAME${NC} Wallet?
      echo
      cat $CONFIGFOLDER/$CONFIG_FILE  | grep "^addnode"
      echo
      echo -e $ASCII_LINE
      echo -e "\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
      echo -e $ASCII_LINE
      echo
      read -p " Enter the number option: " opt

      case $opt in
        1) clear
           add_connections
        ;;
        0) clear
           connections_management
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           continue
        ;;
      esac
      read opt
    done
  done
}

# Menu to delete connections from the wallet.
delete_connections() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t|- Wallet connections management"
  echo -e "\t\t\t${YELLOW}|- Delete extra connections ${NC}"
  allign  "$COIN_NAME" "Delete " " extra connections "
  echo
  echo -e " "This is the content of the wallet config file
  echo -e " "that have the list of already added connections
  echo -e " "${GREEN}$COIN_NAME${NC} wallet
  echo
  echo
  nl -ba $CONFIGFOLDER/$CONFIG_FILE | grep "addnode"
  echo
  echo -e $ASCII_LINE
  echo
  echo -e Please select the number of the line you want to delete
  echo
  echo -e "( if you want to exit, please press the number 0 )"
  echo
  read NUMBER

  if [[ -z "$NUMBER" ]]; then
    clear
    echo "Invalid input. Please enter a number or 0 to exit"
    delete_connections
  elif ! expr "$NUMBER" : '[0-9]*' > /dev/null; then
    echo "Invalid caracter. Please enter the number of the line"
  else

    if [ $NUMBER -eq 0 ]; then
      echo "Exiting the function"
      clear
      connections_management
      else
      LINE=$(sed -n "${NUMBER}p" $CONFIGFOLDER/$CONFIG_FILE)

      if echo "$LINE" | grep -q "addnode"; then
        clear

        while true; do
          header
          echo -e "\t\t  ${YELLOW} Main Menu${NC}"
          echo -e "\t\t\t|- Coin selected"
          echo -e "\t\t\t|- Wallet management"
          echo -e "\t\t\t|- Wallet connections management"
          echo -e "\t\t\t${YELLOW}|- Delete extra connections ${NC}\n"
          allign  "$COIN_NAME" "Delete " " extra connections "
          echo
          echo -e " "Do you really want to delete the line number $NUMBER  
          echo -e " "from ${YELLOW}$CONFIG_FILE${NC} 
          echo
          echo -e "  "$(cat $CONFIGFOLDER/$CONFIG_FILE | head -n $NUMBER | tail -n 1) 
          echo
          echo -e $ASCII_LINE
          echo -e "\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
          echo -e $ASCII_LINE
          echo
          read -r -p " Enter the number option: " opt

          case $opt in
            1) clear
               sed -i "${NUMBER}d" $CONFIGFOLDER/$CONFIG_FILE
               delete_connections
            ;;
            0) clear
               connections_management
            ;;
            *) clear
               echo -e "Please choose one of the options available "
               echo
               continue
            ;;
          esac
        done

      else
        clear
        echo " The selected line number does not contain an addnode, deletion not allowed."
        delete_connections
      fi
    fi
  fi
}

# Menu to Restart coin service
restart_service() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t${YELLOW}|- Restart service${NC}\n"
  allign  "$COIN_NAME" " Restart " "system service "
  echo
  echo -e " "Given that several routines in this script come with an 
  echo -e " "integrated service restart, we recommend utilizing
  echo -e " "this function only for isolated scenarios, such as 
  echo -e " "collateral changes or in the event of service malfunction.
  echo
  echo -e " "Do you want to proceed ?
  echo
  echo -e $ASCII_LINE
  echo -e "\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         echo
         echo -e " Stopping current service related to ${GREEN}$COIN_NAME${NC}"
         echo
         systemctl stop $COIN_NAME.service > /dev/null 2>&1
         reload_service
         clear
         echo -e "${GREEN}$COIN_NAME${NC} Service restarted "
         echo
         wallet_management
      ;;
      0) clear
         wallet_management
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         update_wallet
      ;;
    esac
    read opt
  done
}

# Menu - Delete wallet and masternode.
delete_wallet() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet management"
  echo -e "\t\t\t${YELLOW}|- Delete wallet ${NC}\n"
  allign "$COIN_NAME" " Delete " "wallet and masternode"
  echo
  echo -e " "System have a ${GREEN}$COIN_NAME${NC} wallet installation"	"${YELLOW}$($COIN_CLI -version | awk '{print $5}' | awk -F '-' '{print $1}')${NC}
  echo
  echo -e " "Going forward with this action all related data will be lost.
  echo
  echo -e " "Are you sure you want to delete the wallet?
  echo
  echo -e $ASCII_LINE
  echo -e	"\t"[1]	${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         del_wallet
      ;;
      0) clear
         wallet_management
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         delete_wallet
      ;;
    esac
    read opt
  done
}

# Menu - Wallet and masternode stats.
stats_wallet_mn() {
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t${YELLOW}|- Wallet and masternode stats ${NC}\n"
  allign  "$COIN_NAME" " " " Wallet and masternode stats "
  echo
  echo -e " "[1] Wallet statistics
  echo -e " "[2] Masternode statistics
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         wallet_info
      ;;
      2) clear
         masternode_info
      ;;
      0) clear
         coin_selected
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         stats_wallet_mn
      ;;
    esac
    read opt
  done
}

# Menu - Wallet statistics.
wallet_info() {
  EXPLORER_BLOCK=$(curl -s $EXPLORER | jq -r '.response.daemon_bestblockheight')
  EXPLORER_HASH=$(curl -s $EXPLORER | jq -r '.response.daemon_bestblockhash')
  header
  echo -e "\t\t  ${YELLOW} Main Menu${NC}"
  echo -e "\t\t\t|- Coin selected"
  echo -e "\t\t\t|- Wallet and masternode stats"
  echo -e "\t\t\t${YELLOW}|- Wallet statistics${NC}\n"
  allign  "$COIN_NAME" " " " Wallet Statistics "
  echo
  echo -e " Wallet version on Github: "${YELLOW}$(curl -s $GITHUB | jq -r '.tag_name')${NC}
  echo
  echo -e " Wallet version installed: "${YELLOW}$($COIN_CLI -version | awk '{print $5}' | awk -F '-' '{print $1}')${NC}
  echo
  echo -e " Protocol version: "${YELLOW}$(su - $COIN_NAME -c "$COIN_CLI getinfo | grep -o ':.*,' | awk -F: '{print $2}' | tr -d ',: ' | awk 'NR==2'; exit")${NC}
  echo
  echo -e " Number of connections:  "${YELLOW}$(su - $COIN_NAME -c "$COIN_CLI getconnectioncount; exit")${NC} "( In : $(su - $COIN_NAME -c "$COIN_CLI getpeerinfo|grep inbound|grep -c  true; exit") / Out : $(su - $COIN_NAME -c "$COIN_CLI getpeerinfo|grep inbound|grep -c  false; exit") )"
  echo
  echo -e " Wallet sync:    "${YELLOW}$(su - $COIN_NAME -c "$COIN_CLI mnsync status | grep -o ':.*,' | awk -F: '{print $2}' | tr -d ',: ' | awk 'NR==1'; exit")${NC}
  echo 
  echo -e " Wallet block:   "${YELLOW}$(su - $COIN_NAME -c "$COIN_CLI getinfo | grep -o ':.*,' | awk -F: '{print $2}' | tr -d ',: ' | awk 'NR==7'; exit")${NC}
  echo
  echo -e " Block hash verification:"
  echo
  echo -e " Explorer block: "${YELLOW}$EXPLORER_BLOCK${NC} hash:  ${YELLOW}${EXPLORER_HASH:0:12} ... ${EXPLORER_HASH: -12}${NC}
  echo -e " Wallet   block: "${YELLOW}$EXPLORER_BLOCK${NC} hash:  ${YELLOW}$(su - $COIN_NAME -c "$COIN_CLI getblockhash $EXPLORER_BLOCK; exit" | cut -c 1-12) ... $(su - $COIN_NAME -c "$COIN_CLI getblockhash $EXPLORER_BLOCK; exit" | rev | cut -c 1-12 | rev)${NC}
  echo
  echo
  echo
  echo -e " "[1] Reload information
  echo -e " "[2] Wallet management
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         wallet_info
      ;;
      2) clear
         wallet_management
      ;;
      0) clear
         stats_wallet_mn
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         wallet_info
      ;;
    esac
    read opt
  done
}

# Menu - Masternode statistics.
masternode_info() {
  header_display() {
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t|- Wallet and masternode stats"
    echo -e "\t\t\t${YELLOW}|- Masternode statistics${NC}\n" 
    allign  "$COIN_NAME" " " " Masternode statistics "
  }
  header
  header_display
  echo
  echo -e " "Multinode Status
  echo
  su - $COIN_NAME -c "$COIN_CLI getactivemasternodecount | jq '\"total \(.total) / initial \(.initial) / syncing \(.syncing) / not_capable \(.not_capable) / started \(.started)\"'; exit"
  echo
  echo -e $ASCII_LINE
  echo
  echo -e " "Masternode Status
  echo
  su - $COIN_NAME -c "$COIN_CLI getmasternodestatus | jq '.[] | \"alias: \(.alias) / addr: \(.addr) / status: \(.status)\"'; exit"
  echo
  echo -e "$ASCII_LINE"
  echo
  echo -e " "[1] Reload information
  echo -e " "[2] Masternode status complete info
  echo -e " "[3] Masternode on explorer
  echo -e " "[4] Wallet management
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         masternode_info
      ;;
      2) clear
         mn_status_comp_info
      ;;
      3) clear
         mn_explorer
      ;;
      4) clear
         wallet_management
      ;;
      0) clear
         stats_wallet_mn
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         wallet_info
      ;;
    esac
    read opt
  done
}

# Menu - Others
others() {
  header_display() {
    echo -e "\t\t  ${YELLOW} Main Menu${NC}"
    echo -e "\t\t\t|- Coin selected"
    echo -e "\t\t\t${YELLOW}|- Others options${NC}\n"
    allign  "$COIN_NAME" " " " Other Options "
  }

  if [ -f "$CONFIGFOLDER/activemasternode.conf" ]; then

    header
    header_display
    echo
    echo -e " "[1] Update this script
    echo -e " "[2] File System
    echo -e " "[-] Others
    echo
    echo -e $ASCII_LINE
    echo -e "\t\t  [0]  Go back to previous menu"
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           update_script
        ;;
        2) clear
           file_system_list
        ;;
        0) clear
           coin_selected
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           others
        ;;
      esac
      read opt
    done
  else

    header
    header_display
    echo
    echo -e " "[1] Update this script
    echo -e " "[-] Others
    echo
    echo -e $ASCII_LINE
    echo -e "\t\t  [0]  Go back to previous menu"
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           update_script
        ;;
        0) clear
           coin_selected
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           coin_selected
        ;;
      esac
      read opt
    done
  fi
}

# Menu to update script.
update_script() {
  if [ -f "decenomy_old" ]; then
    header
    echo -e $ASCII_LINE
    echo -e "           $ASCII_L        Update script        $ASCII_R"
    echo -e $ASCII_LINE
    echo
    echo -e " "Script version Github"\t\t"${YELLOW}$(curl -s $SCRIPT_GITHUB | jq -r '.tag_name')${NC}
    echo
    echo -e " "Script version Installed"\t"${YELLOW}$SCRIPVERSION${NC}
    echo
    echo
    echo -e " "[1] Update script
    echo -e " "[2] Downgrade script version
    echo
    echo -e $ASCII_LINE
    echo -e "\t\t  [0]  Go back to previous menu"
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           rm -rf decenomy_old
           upgrade_script
        ;;
        2) clear
           downgrade_script
        ;;
        0) clear
           main_menu
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           update_script
        ;;
      esac
      read opt
    done
  else
    header
    echo -e $ASCII_LINE
    echo -e "           $ASCII_L        Update script        $ASCII_R"
    echo -e $ASCII_LINE
    echo
    echo -e " "Script version Github"\t\t"${YELLOW}$(curl -s $SCRIPT_GITHUB | jq -r '.tag_name')${NC}
    echo
    echo -e " "Script version Installed"\t"${YELLOW}$SCRIPVERSION${NC}
    echo
    echo -e " Do you want to Upgrade this script"
    echo
    echo -e $ASCII_LINE
    echo -e "\t"[1] ${YELLOW}Yes${NC}"     |-|-|    "[0] ${YELLOW}No, go back to previous menu${NC}
    echo -e $ASCII_LINE
    echo
    read -p " Enter the number option: " opt

    while true; do
      case $opt in
        1) clear
           upgrade_script
        ;;
        0) clear
           main_menu
        ;;
        *) clear
           echo -e "Please choose one of the options available "
           echo
           update_script
        ;;
      esac
      read opt
    done
  fi
}

# Full list of needed files location
file_system_list() {
  header
  header_display
  echo
  echo -e " ${GREEN}Wallet files location:\t ${NC}${RED}$CONFIGFOLDER${NC}"
  echo -e " ${GREEN}Configuration file is:\t ${NC}${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
  echo -e " ${GREEN}Daemon location:\t ${NC}${RED}$COIN_PATH${NC}"
  echo -e " ${GREEN}Service location:\t ${NC}${RED}/etc/systemd/system/${NC}"
  echo -e " ${GREEN}Start Service:\t\t ${NC}${RED}systemctl start $COIN_NAME.service${NC}"
  echo -e " ${GREEN}Stop Service:\t\t ${NC}${RED}systemctl stop $COIN_NAME.service${NC}"
  echo -e " ${GREEN}VPS IP:PORT\t\t ${NC}${RED}$NODEIP:$COIN_PORT${NC}"
  echo
  echo -e " To manually access wallet on terminal"
  echo
  echo -e " ${CYAN}Wallet Commands need to be done inside user $COIN_NAME${NC}"
  echo -e " ${GREEN}To enter in user $COIN_NAME do:\t ${NC}${YELLOW}su - $COIN_NAME${NC}"
  echo -e " ${GREEN}To logout from user $COIN_NAME do:\t ${NC}${YELLOW}exit${NC}"
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " -n 1 -r

  if [ "$REPLY" == "0" ]; then
    read -p "" -n 1 -r
    clear
    others
  else
    clear	
    file_system_list
  fi
}

# Process to check full getmasternodestatus from cli.
function mn_status_comp_info() {
  header
  header_display
  echo
  echo "$(su - $COIN_NAME -c "$COIN_CLI getmasternodestatus";exit)"
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " -n 1 -r

  if [ "$REPLY" == "0" ]; then
    read -p "" -n 1 -r
    clear
    masternode_info
  else
    clear
    mn_status_comp_info	
    continue
  fi
}

# Process to check masternodes on explorer based on IP query.
function mn_explorer() {
  header
  header_display
  echo
  echo -e "\t(  Be aware, this process can take some time  )"
  echo
  result=$(curl -s https://explorer.decenomy.net/api/v2/$TICKER/masternodes | jq -c '.response[] | select(.ip == "'$NODEIP:$COIN_PORT'") | {status: .status, ip: .ip, addr: .addr}')

  if [ -z "$result" ]; then
    echo -e "No masternode with the IP=${YELLOW}$NODEIP:$COIN_PORT${NC} on the blockchain"
    echo
    else
    echo -e "$result"
    echo
  fi
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " -n 1 -r

  if [ "$REPLY" == "0" ]; then
    read -p "" -n 1 -r
    clear
    masternode_info
  else
    clear
    mn_explorer
  fi
}

# Process to clean old installed wallet files.
function purge_old_installation() {
  clear
  echo -e " "Searching and removing old ${GREEN}$COIN_NAME${NC} files and configurations
  #stop and kill wallet daemon
  systemctl stop $COIN_NAME.service > /dev/null 2>&1
  sudo killall $COIN_DAEMON > /dev/null 2>&1
  echo -e " "Service stoped
  echo
  #remove service
  cd /etc/systemd/system && rm -rf $COIN_NAME.service > /dev/null 2>&1
  echo -e " "Service deleted
  echo
  #remove old ufw port allow
  sudo ufw delete allow $COIN_PORT/tcp > /dev/null 2>&1
  echo -e " "Firewall rule deleted
  echo
  #remove old files
  sudo rm -rf $CONFIGFOLDER/bootstrap.dat.old > /dev/null 2>&1
  cd /usr/local/bin && sudo rm -rf $COIN_CLI $COIN_DAEMON && cd
  cd /usr/bin && sudo rm -rf $COIN_CLI $COIN_DAEMON && cd
  sudo rm -rf $CONFIGFOLDER
  echo -e " "Old files removed
  echo
  echo -e " "${GREEN}* Done${NC}
  clear
  echo -e " "Removed ${GREEN}$COIN_NAME ${NC}files and configurations
  echo
}

# Process to download wallet files from Github and alocate them in the system. 
function download_node() {
  echo -e " "Downloading files to install ${GREEN}$COIN_NAME${NC} Daemon
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  7z x -bso0 -bse0 $COIN_ZIP
  chmod +x $COIN_DAEMON $COIN_CLI
  cp $COIN_DAEMON $COIN_CLI $COIN_PATH
  chown $COIN_NAME:users -R $COIN_PATH$COIN_DAEMON
  chown $COIN_NAME:users -R $COIN_PATH$COIN_CLI
  cd ~
  rm -rf $TMP_FOLDER
  clear
}

# Process to relode service.
function reload_service() {
  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1
  sleep 5
}
 
# Process to configure service multinode.
function configure_systemd_multi() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target
[Service]
User=$COIN_NAME
Group=users
Type=forking
ExecStart=$COIN_PATH$COIN_DAEMON -daemon -server -listen -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
  echo -e Starting $COIN_NAME Service...
  reload_service

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e " "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:
    echo -e " "systemctl start $COIN_NAME.service
    echo -e " "systemctl status $COIN_NAME.service
    echo -e " "less /var/log/syslog
    exit 1
  fi
}

# Process to install bootstrap.
function bootstrap() {
  echo
  mkdir -p $CONFIGFOLDER/bootstrap && cd $CONFIGFOLDER/bootstrap >/dev/null 2>&1
  echo -e " "Downloading ${GREEN}$COIN_NAME${NC} boostrap
  echo
  while true; do
    curl -# -o bootstrap.zip -f "$BOOTSTRAP"
    if [ $? -eq 0 ]; then
      echo
      echo -e " "Download succeeded
      break
    else
      clear
      echo -e " "Failed to download bootstrap. Retrying in 5 seconds...
      echo
      sleep 5
      clear
      echo 
      echo -e " "Downloading ${GREEN}$COIN_NAME${NC} boostrap
      echo
    fi
  done
  clear
  echo
  echo -e " "Extracting files from ${GREEN}$COIN_NAME${NC} boostrap
  echo
  7z x -bso0 -bse0 bootstrap.zip
  echo
  echo -e " Extraction completed"
  echo
  echo -e " Moving ${GREEN}$COIN_NAME${NC} bootstrap files extracted"
  echo
  echo -e " Be aware that if it's a considerable bootstrap file size,"
  echo -e " it can take some time"
  chmod +x blocks chainstate
  echo
  systemctl stop $COIN_NAME.service
  sleep 3
  rm -rf $CONFIGFOLDER/blocks $CONFIGFOLDER/chainstate
  cp -rf blocks/ chainstate/ $CONFIGFOLDER/
  cd ~
  chown $COIN_NAME:users -R $CONFIGFOLDER/
  rm -rf $CONFIGFOLDER/bootstrap 
  clear
}

# Process to configure coin file multinode.
function create_config_multi() {
  mkdir -p $CONFIGFOLDER && chown $COIN_NAME:users -R $CONFIGFOLDER
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
listen=1
server=1
daemon=0
maxconnections=256
bind=0.0.0.0
masternode=1
EOF

  chown $COIN_NAME:users -R $CONFIGFOLDER/$CONFIG_FILE
}

# Process to create masternode key.
function create_key() {
  echo
  echo -e " Please introduce now your ${GREEN}$COIN_NAME ${NC} ${CYAN}MasternodeKey${NC}"
  echo -e " ( you can also press "Enter" and it's automatically created)"
  echo
  read -e COINKEY

  if [[ -z "$COINKEY" ]]; then

    if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
      echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
      exit 1
    fi
    COINKEY=$(su - $COIN_NAME -c "$COIN_CLI createmasternodekey; exit")

    if [ "$?" -gt "0" ]; then
      echo -e "${RED}Wallet not fully loaded. Please wait 30 seconds and I will try again to generate a key. Do not press any buttons.${NC}"
      sleep 30
      COINKEY=$(su - $COIN_NAME -c "$COIN_CLI createmasternodekey; exit")
    fi
  fi
}

# Process to enable firewall to each coin.
function enable_firewall() {
  echo -e " Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
  clear
}

# Process to get the ip from the system.
function get_ip() {
  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}'); do
    NODE_IPS+=($(curl --retry 3 --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done
  
  if [ ${#NODE_IPS[@]} -gt 1 ]; then
    echo -e "${GREEN}More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
    INDEX=0

    for ip in "${NODE_IPS[@]}"; do
      echo ${INDEX} $ip
      let INDEX=${INDEX}+1
    done
    read -e choose_ip
    NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
  fi
  
  if [[ -z "$NODEIP" ]]; then
    #Couldn't determine IP, most likely icanhazip.com is timed out
    echo -e "${RED}Failed to determine IP address. Please wait a couple minutes and rerun script. If this continues, ask for assistance on Discord.${NC}"
    exit 1
  fi
}

# Initial checks of the system.
function checks() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}$0 must be run as root.${NC}"
    exit 1
  fi

  if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
    echo -e "${RED}$COIN_NAME is already installed.${NC}"
    exit 1
  fi
}

# Process to install needed parameters in the system.
function prepare_system() {
  echo
  echo -e " Preparing the VPS to fully setup ${GREEN}$COIN_NAME${NC} ${CYAN}Masternode${NC}"
  apt-get update -y >/dev/null 2>&1
  DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
  DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
  apt-get install -y software-properties-common >/dev/null 2>&1
  echo
  echo -e " Installing required packages, it may take some time to finish.${NC}"
  apt-get update >/dev/null 2>&1
  apt-get install libzmq3-dev net-tools -y >/dev/null 2>&1
  echo
  echo -e " Loading..."
  apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
  build-essential libtool autoconf libssl-dev \
  sudo automake git wget curl bsdmainutils net-tools \
  libminiupnpc-dev libgmp3-dev ufw pkg-config >/dev/null 2>&1

  if [ "$?" -gt "0" ]; then
    echo -e " ${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo
    echo " apt-get update"
    echo " apt-get install -y software-properties-common"
    echo " apt-get update"
    echo " apt-get install -y make software-properties-common build-essential libtool autoconf libssl-dev sudo automake git wget curl bsdmainutils net-tools libminiupnpc-dev libgmp3-dev ufw pkg-config unzip"
    exit 1
  fi
  clear
}
 
# Process to update the wallet.
function update_wallet_process() {
  echo
  echo -e " Updating Wallet Process for ${GREEN}$COIN_NAME${NC}"
  echo
  echo -e " Downloading new daemon from ${GREEN}$COIN_NAME${NC} Github"
  echo
  sleep 2
  mkdir -p $CONFIGFOLDER/wallet_update && cd $CONFIGFOLDER/wallet_update  >/dev/null 2>&1
  wget -q $COIN_TGZ
  7z x -bso0 -bse0 $COIN_ZIP
  echo -e " Stopping all current services related to ${GREEN}$COIN_NAME${NC}"
  echo
  systemctl stop $COIN_NAME.service > /dev/null 2>&1
  sudo killall $COIN_DAEMON > /dev/null 2>&1
  sleep 3
  echo -e " Changing ${GREEN}$COIN_NAME${NC} new daemon in the system"
  echo
  chmod +x $COIN_DAEMON $COIN_CLI
  cp -f $COIN_DAEMON $COIN_CLI $COIN_PATH
  chown $COIN_NAME:users -R $COIN_PATH$COIN_DAEMON
  chown $COIN_NAME:users -R $COIN_PATH$COIN_CLI
  cd ~ >/dev/null 2>&1
  rm -rf $CONFIGFOLDER/wallet_update >/dev/null 2>&1
  echo -e " Reloading ${GREEN}$COIN_NAME${NC} daemon, with new version"
  sleep 2
  reload_service
  clear
  echo -e " New ${GREEN}$COIN_NAME${NC} daemon, now running"
  sleep 2
}

# Process to deliver overview information from the system.
function overview_center() {
  echo
  echo " Searching for wallets installed..."
  echo
  sleep 2
  clear
  header
  echo
  echo -e $ASCII_LINE
  echo -e "\t       $ASCII_L   Overview Center  $ASCII_R"
  echo -e $ASCII_LINE
  echo
  echo -e " System resources overview "
  echo
  echo -e " ${GREEN}System Up Time${NC} $(top -n 1 -b | awk '/^top/{print $5}') days | ${GREEN}Cpu Load${NC} $(top -n 1 -b | grep '%Cpu' | awk '{print $2}')%  "
  total_mem=$(free -h | awk '/^Mem:/{print $2}')
  used_mem=$(free -h | awk '/^Mem:/{print $3}')
  free_mem=$(free -h | awk '/^Mem:/{print $4}')
  cache_mem=$(free -h | awk '/^Mem:/{print $6}')
  percentage_used=$(awk -v used="$used_mem" -v total="$total_mem" 'BEGIN { printf "%.1f", (used/total) * 100 }')
  echo -e " ${GREEN}Total disk space${NC}  $(df -h -t ext4 --total | awk '/total/ {print $2 " (" $5 " in use)"}')"
  echo -e " ${GREEN}Total RAM memory${NC} $total_mem (${percentage_used}% in use) - ${GREEN}Cache Mem${NC} $cache_mem"
  echo
  echo -e " Wallet intalled overview"  
  echo
  for dir in $(find /home/users \( -name ".azzure" -or -name ".beacon" -or -name ".birake" -or -name ".cryptoflow" -or -name ".cryptosaga" -or -name ".dashdiamond" -or -name ".eskacoin" -or -name ".flits" -or -name ".jackpot" -or -name ".kyanite" -or -name ".mobic" -or -name ".monk" -or -name ".oneworld" -or -name ".peony" -or -name ".sapphire" -or -name ".suvereno" -or -name ".ultraclear" \) -type d)
  do
    if [ -e "$dir/activemasternode.conf" ]; then
          var_overview
      EXPLORER1=https://explorer.decenomy.net/api/v2/$TICKER1/status
      EXPLORER_BLOCK1=$(curl -s $EXPLORER1 | jq -r '.response.daemon_bestblockheight')
      EXPLORER_HASH1=$(curl -s $EXPLORER1 | jq -r '.response.daemon_bestblockhash')
      echo -e " "${GREEN}$(basename $dir | cut -c 2-)${NC}
      echo -e " Masternodes:   ${YELLOW}$(su - $COIN_NAME1 -c "$COIN_CLI1 getactivemasternodecount | jq -r '\"total \(.total) | not_capable \(.not_capable) | started \(.started)\"'; exit" | tr -d '"')${NC}"  
      echo -e " Wallet Sync:   ${YELLOW}$(su - $COIN_NAME1 -c "$COIN_CLI1 mnsync status | grep -o ':.*,' | awk -F: '{print $2}' | tr -d ',: ' | awk 'NR==1'; exit")${NC}""  "" Connections: ${YELLOW}$(su - $COIN_NAME1 -c "$COIN_CLI1 getconnectioncount; exit")${NC}  (In: $(su - $COIN_NAME1 -c "$COIN_CLI1 getpeerinfo|grep inbound|grep -c true; exit") | Out: $(su - $COIN_NAME1 -c "$COIN_CLI1 getpeerinfo|grep inbound|grep -c false; exit"))"
      echo -e " Explorer block\t${YELLOW}$EXPLORER_BLOCK1${NC} hash: ${YELLOW}${EXPLORER_HASH1:0:12} ... ${EXPLORER_HASH1: -12}${NC}"
      echo -e " Wallet   block\t${YELLOW}$EXPLORER_BLOCK1${NC} hash: ${YELLOW}$(su - $COIN_NAME1 -c "$COIN_CLI1 getblockhash $EXPLORER_BLOCK1; exit" | cut -c 1-12) ... $(su - $COIN_NAME1 -c "$COIN_CLI1 getblockhash $EXPLORER_BLOCK1; exit" | rev | cut -c 1-12 | rev)${NC}"      
      echo
    fi
  done
  echo
  echo -e " "[1] Reload information
  echo -e " "[2] Clean system cache memory
  echo -e " "[3] Wallets and script update overview
  echo
  echo -e $ASCII_LINE
  echo -e "\t\t  [0]  Go back to previous menu"
  echo -e $ASCII_LINE
  echo
  read -p " Enter the number option: " opt

  while true; do
    case $opt in
      1) clear
         overview_center
      ;;
      2) clear
         sync; echo 1 > /proc/sys/vm/drop_caches
         overview_center
      ;;
      3) clear
         header
         echo
         echo -e $ASCII_LINE
         echo -e "     $ASCII_L   Wallets and script update overview   $ASCII_R"
         echo -e $ASCII_LINE
         echo
         version_wallet_check
         version_script_check
         echo
         echo -e $ASCII_LINE
         echo -e "\t\t     Press enter to go back"
         echo -e $ASCII_LINE
         read -rsn1 key
         if [[ $key == "" ]]; then
         clear
         overview_center
         else
         while true; do
         echo -e "Invalid option. Press enter to go back."
         read -rsn1 -t 3 key
         if [[ $key == "" ]]; then
         clear
         overview_center
         break
         fi
         done
         fi
      ;;
      0) clear
         main_menu
      ;;
      *) clear
         echo -e "Please choose one of the options available "
         echo
         overview_center
      ;;
    esac
    read opt
  done
  clear
}

# Process for Prompting Information About a New Version of the Script.
function version_script_check() {
  LATEST_VERSION=$(curl -s $SCRIPT_GITHUB | grep -oP '(?<="tag_name": ")[^"]+')
    if [ -z "$LATEST_VERSION" ]; then
    echo -e " --- "
    echo
    echo -e " - Unable to retrieve the latest ${GREEN}script version${NC} available on GitHub."
    echo -e "   There have been too many requests made from this machine. "
    echo -e "   Please allow some time before trying again."
    else
  if [ "$SCRIPVERSION" != "$LATEST_VERSION" ]; then
    echo -e " --- "
    echo
    echo -e "${GREEN} - New script version available:${NC} $LATEST_VERSION"
    else
    echo -e " --- "
    echo
    echo -e " - Multinode script is on the latest version available."
  fi
  fi
}

# Process for Prompting Information About a New Version of the installed wallets.
function version_wallet_check() {
    local null=false
    local newversion=false
    for dir in $(find /home/users \( -name ".azzure" -or -name ".beacon" -or -name ".birake" -or -name ".cryptoflow" -or -name ".cryptosaga" -or -name ".dashdiamond" -or -name ".eskacoin" -or -name ".flits" -or -name ".jackpot" -or -name ".kyanite" -or -name ".mobic" -or -name ".monk" -or -name ".oneworld" -or -name ".peony" -or -name ".sapphire" -or -name ".suvereno" -or -name ".ultraclear" \) -type d)
    do
        if [ -e "$dir/activemasternode.conf" ]; then
            var_overview
            GITHUB1="https://api.github.com/repos/decenomy/$TICKER1/releases/latest"
            LATEST_WALLET=$(curl -s "$GITHUB1" | jq -r '.tag_name')
            if [ "$LATEST_WALLET" == "null" ]; then
                null=true
            else
                CURRENT_WALLET=$(su - "$COIN_NAME1" -c "$COIN_CLI1 -version; exit" | awk '/version/{print $NF}' | awk -F '-' '{print $1}')
                if [ "$CURRENT_WALLET" != "$LATEST_WALLET" ]; then
                    echo -e "${GREEN} - New $COIN_NAME1 wallet version available:${NC} $LATEST_WALLET"
                    echo
                    newversion=true
                fi
            fi
        fi
    done
    if [ "$null" = true ]; then    
        echo -e " - Unable to retrieve the latest ${GREEN}wallet version${NC} available on GitHub."
        echo -e "   There have been too many requests made from this machine."
        echo -e "   Please allow some time before trying again."
        echo
    elif [ "$newversion" = false ]; then
        echo -e " - All wallets installed are on the latest version available."
        echo
  fi
}

# Process to upgrade script version.
function upgrade_script() {
  cp decenomy decenomy_old
  rm -rf decenomy
  wget -q $SCRIPT_FILE
  mv decenomy.sh decenomy
  chmod +x decenomy
  exec "$0" "$@"
}

# Process to downgrade script version.
function downgrade_script() {
  rm -rf decenomy
  mv decenomy_old decenomy
  exec "$0" "$@"
}

# Process to delete peers and banlist file and then recreate them again.
function peer_banlist_delete() {
  echo
  echo -e "Peers and banlist files maintenance"
  systemctl stop $COIN_NAME.service
  su - $COIN_NAME -c "rm -rf $CONFIGFOLDER/banlist.dat $CONFIGFOLDER/peers.dat; exit"
  sleep 3
  echo -e "Reloading ${GREEN}$COIN_NAME${NC} daemon..."
  reload_service
  clear
  echo -e "Peers and banlist files recreated"
}

# Process to delete wallet and related user created information.
function del_wallet() {
  purge_old_installation
  rm -rf /home/users/$COIN_NAME
  userdel $COIN_NAME
  main_menu
}

# Process to setup a masternode multinode.
function setup_mn_multinode() {
  get_ip
  create_config_multi
  configure_systemd_multi
  enable_firewall
  bootstrap
  echo -e " Reloading ${GREEN}$COIN_NAME${NC} Service..."
  echo
  reload_service
  sleep 3
  sed -i '1,5d' $CONFIGFOLDER/activemasternode.conf
  clear
  echo
  echo -e " ${GREEN}VPS IP:PORT\t\t ${NC}${RED}$NODEIP:$COIN_PORT${NC}"
  echo
}

# Process to create a user in the system according to the coin selected.
function user_creations() {
  if id $COIN_NAME > /dev/null 2>&1; then
    coin_selected
  else

    #user creation with $HOME predefine
    useradd $COIN_NAME -g users -d /home/users/$COIN_NAME -s /bin/bash
    #$HOME creation with ownership changed to the user
    mkdir -p /home/users/$COIN_NAME && chown $COIN_NAME:users -R /home/users/$COIN_NAME
    user_creations
  fi
}

# Process to check the os version // Only worls with Debian/Linux version.
function os_check() {

  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ $ID == "debian" || $ID == "ubuntu" ]]; then
      echo
      echo -e " This is a Supported Linux distro system "
    else
      echo
      echo " This is a non-suported Linux distro system "
      echo
      echo " Sorry but this script can't work with this configuration "
      exit
    fi
  else
    echo " Unable to determine the Linux distribution "
    echo " This script cannot be used, sorry. "
    exit
  fi
}

function system_script() {
  command -v jq >/dev/null 2>&1 || apt-get install jq -y >/dev/null 2>&1
  command -v p7zip-full >/dev/null 2>&1 || apt install p7zip-full -y >/dev/null 2>&1
  [ -x decenomy.sh ] || (echo " Script permissions have been updated to allow it to be executed as a file" && chmod +x decenomy.sh) && mv decenomy.sh decenomy
}

##### Main #####
clear
echo
echo -e " Opening Decenomy Masternode Script..."
if ! [ -f "decenomy" ]; then
  os_check
  sleep 2
  echo
  echo -e " Preparing for the script ..."
  echo
  system_script
fi
sleep 2
clear
main_menu
