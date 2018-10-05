#!/bin/bash

WD=$PWD/techtest_journey_python

cd $WD

# pull all the branches
for b in `git branch -r | grep -v -- '->'`; do
    git branch --track ${b##origin/} $b;
done
# take the branch with the latest commit
LATEST_BRANCH=$(git branch --sort=committerdate --format="%(refname:short)" | tail -n1)
git checkout $LATEST_BRANCH
git pull

# direct installation
pip3 install -r requirements.txt
systemctl restart techtest_journey_python
echo "Build barebones done"

# docker installation
docker build . --tag techtest_journey_python
docker kill ttjp
docker rm ttjp
docker run -p 7899:8000 --name ttjp techtest_journey_python

echo "Build all done"
