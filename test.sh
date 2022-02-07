#!/bin/bash
module_name='orbs-workflow-subm'
submodule_url='git@github.com:RHEMS-Japan/orbs-workflow-subm.git'
CIRCLE_BRANCH=beta
if [ -e ".gitmodules" ]; then
      echo -e "already exists .gitmodule\n"
      # pathsにpathを全て取り込む
      paths=$(echo $(grep "path=*" .gitmodules | awk '{print $3}' ))
      # 指定のモジュール名が存在するか
      branch_name=""
      if [[ $paths =~ $module_name ]]; then
          echo $module_name
          # 指定のモジュール名のpathが何行目か
          N=$(grep -n "path = $module_name" .gitmodules | sed -e 's/:.*//g')
          echo $N
          return
          # 指定のモジュールのブランチ名の取得
          branch_name=$(awk "NR==$N+2" .gitmodules | awk '{print $3}')
          echo $branch_name
          # 現在のブランチ名と異なったら
          if [ $branch_name != ${CIRCLE_BRANCH} ]; then
              # 一旦deinitして設定し直す
              git submodule deinit -f $module_name
              git rm -f $module_name
              git submodule add --quiet --force -b ${CIRCLE_BRANCH} ${submodule_url}
          fi
      else
        echo -e "no setting in .gitmodule\n"
        git submodule add --quiet --force -b ${CIRCLE_BRANCH} ${submodule_url}
      fi
  # .gitmodulesが存在しなかったら
  else
    echo -e "no exists .gitmodule\n"
    git submodule add --quiet --force -b ${CIRCLE_BRANCH} ${submodule_url}
  fi