#!/bin/bash
init_deploy_dir() {
  cp public/ .deploy_git/ -rf
}

setup_git() {
  git init
  git config --global user.email "keepgoingwm@gmail.com"
  git config --global user.name "keepgoingwm"
}

commit_files() {
  if [ $TRAVIS_EVENT_TYPE != "pull_request" ]; then
    if [ $TRAVIS_BRANCH == "master" ]; then
      echo "Committing to master branch..."
      # git checkout master
      git add *
      if [ $TRAVIS_EVENT_TYPE == "cron" ]; then
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER [cron]"
      elif [ $TRAVIS_EVENT_TYPE == "api" ]; then
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER [custom]"
      else
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
      fi
    fi
  fi
}

push_files() {
  if [ $TRAVIS_EVENT_TYPE != "pull_request" ]; then
    if [ $TRAVIS_BRANCH == "master" ]; then
      echo "Pushing to master branch..."
      git push --force --quiet "https://${GH_TOKEN}@github.com/keepgoingwm/keepgoingwm.github.io.git" master > /dev/null 2>&1
    fi
  fi
}

init_deploy_dir
cd .deploy_git
setup_git
commit_files
push_files
