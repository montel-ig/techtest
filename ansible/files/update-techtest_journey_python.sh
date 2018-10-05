#!/bin/bash

WD=$PWD/techtest_journey_python

cd $WD

# pull all the branches
for b in `git branch -r | grep -v -- '->'`; do
    echo "getting branch $b";
    git branch --track ${b##origin/} $b;
    echo "pulling branch $b";
    git checkout ${b##origin/};
    git pull;
done

# take the branch with the latest commit
LATEST_BRANCH=$(git branch --sort=committerdate --format="%(refname:short)" | tail -n1)
echo "branch with latest commit $LATEST_BRANCH"
git checkout $LATEST_BRANCH
git reset --hard origin/$LATEST_BRANCH

# direct installation
echo "Installing dependencies"
pip3 install -r requirements.txt
systemctl restart techtest_journey_python
echo "Build barebones done"

# docker installation
docker rmi --force techtest_journey_python
docker kill ttjp
docker rm --force ttjp
docker build . --tag techtest_journey_python
docker run -d -p 9876:7890 --name ttjp -v /root/dockerized_planets.json:/planets.json \
    -e DATA_FILE=/planets.json techtest_journey_python

echo "Build all done"
