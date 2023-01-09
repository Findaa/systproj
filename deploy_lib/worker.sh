#!/bin/bash

WORKDIR="./work"
export LINODE_CLI_TOKEN="949505f61e40135f06bf04fe99c699d15b008f8ca2a6e430d437fd3b752735ab"

. deploy_lib/LocalActions.sh
. deploy_lib/CloudActions.sh
. deploy_lib/DatabaseManager.sh
. deploy_lib/Log.sh

main() {
  appUser=$(whoami)
  inf "APP START" "App started by ${appUser}"

  PS3='Please enter your choice: '
  options=("Create kube host" "Create cluster" "Delete host" "Delete cluster" "List nodes" "Quit" "testOption")
  select opt in "${options[@]}"; do
    case $opt in
    "Create kube host")
      kubeHostCreate
      databaseUpdate
      optionsPrint
      ;;
    "Create cluster")
      echo "TODO"
      databaseUpdate
      optionsPrint
      ;;
    "Delete host")
      kubeHostDestroy
      databaseUpdate
      optionsPrint
      ;;
    "Delete cluster")
      echo "you chose choice $REPLY which is $opt"
      ;;
    "List nodes")
      fetchNodesFormatted
      databaseUpdate
      optionsPrint
      ;;
    "Quit")
      break
      exit 420
      ;;
    "testOption")
      inf 'TEST' $(pwd)
      sshCommand='cd ../tmp && ls'
      sshConnector 'terraformHost' $sshCommand
      ;;
    *) echo "invalid option $REPLY"
      ;;
    esac
  done
}

optionsPrint() {
  echo "\n1.) Create kube host 2.) Create cluster 3.) Delete host 4.) Delete cluster 5.) List nodes 6.) Quit"
}

databaseUpdate() {
  if [ $(basename "`pwd`") == "work" ]; then
    upsertNodeDb
  else
    err "database update" "Can not find a database directory. Does work folder exist?"
    echo $(pwd)
  fi
}

main
