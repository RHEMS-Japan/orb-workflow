if [ -n ${MODULE_NAME} ]; then
  module_name=$(eval echo ${MODULE_NAME})
  commit_message="$(eval echo ${COMMIT_MESSAGE}): ${module_name}"
  reponame=$(echo $CIRCLE_REPOSITORY_URL | awk -F "/" '{ print $NF }' | awk -F "." '{ print $(NF-1) }')
  submodule_url=$(echo ${CIRCLE_REPOSITORY_URL} | sed "s/${reponame}/${module_name}/")

  _key=$(echo ${SUBM_FINGER_PRINT} | sed -e 's/://g')
  export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa_${_key}"
  git config --global user.email "submodule.updater@rhems-japan.co.jp"
  git config --global user.name "submodule-updater"

  git submodule add --quiet --force -b ${CIRCLE_BRANCH} ${submodule_url}

  git submodule update --init --remote --recursive ${module_name}
  git status

  git checkout ${CIRCLE_BRANCH}
  _key=$(echo ${MASTER_FINGER_PRINT} | sed -e 's/://g')
  export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa_${_key}"
  git branch --set-upstream-to=origin/${CIRCLE_BRANCH} ${CIRCLE_BRANCH}
  git pull
  git commit -a -m "${commit_message}" || true
  git push -u origin ${CIRCLE_BRANCH}
  else
  echo "target not found."
fi
