#!/bin/bash

echo -e "\n============================"
echo -e "   config pack & Validate"
echo -e "============================\n"
circleci orb pack --skip-update-check src > orb.yml
circleci orb --skip-update-check validate orb.yml
echo -e "\n============================"
echo -e "  CircleCI config Validate"
echo -e "============================\n"
circleci config --skip-update-check validate
echo -e "\n"