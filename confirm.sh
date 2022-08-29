#!/bin/bash

module_name=orbs-workflow-subm
paths=$(echo $(grep "path=*" .gitmodules | awk '{print $3}'))
echo $paths

# echo '---'
# for path in $paths; do
#   if [[ $module_name = $path ]]; then
#     new_module_name=$path
#   fi
# done
# echo '---'


N=$(grep -n -e "path = ${module_name}"$ .gitmodules | sed -e 's/:.*//g')
# N=$(grep -n "path = $new_module_name" .gitmodules | sed -e 's/:.*//g')
echo $N
branch_name=$(awk "NR==$N+2" .gitmodules | awk '{print $3}')
echo $branch_name