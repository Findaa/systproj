#!/bin/bash

fetchNodesPlaintext() {
  linode-cli linodes list --text
}

fetchNodesFormatted() {
  linode-cli linodes list
}

fetchNodesJson() {
  linode-cli linodes list --json --pretty
}

upsertNodeDb() {
  cat /dev/null > db/db.txt
  fetchNodesPlaintext > db/db.txt
  fetchNodesJson > db/db.json
  cd db
  cp db.txt db.csv

#  Linux version
#  sed -i "s/[[:blank:]]\{1,\}/ /g" db.csv
#  OSX version
  sed -i '' 's/[[:blank:]]\{1,\}/;/g' db.csv

  inf "database\tf" "Database updated successfully"
  cd ..
}

getNodeIpByName() {
 python3 ./deploy_lib/py_lib/getIpByName.py $1
}

databaseUpdate() {
  if [ $(basename "`pwd`") == "work" ]; then
    upsertNodeDb
  else
    err "database\t" "Can not update database files. Check if work folder exists."
    echo $(pwd)
  fi
}
