---
title: GitLab CI
category: CI / CD
layout: 2017/sheet
updated: 2018-10-28
description: ""
intro: >
    The benefits of Continuous Integration are huge when automation plays an integral part of your workflow. GitLab comes with built-in Continuous Integration, Continuous Deployment, and Continuous Delivery support to build, test, and deploy your application.
---

## GitLab Configuration file


### Global

```yml
image: docker:stable
services:
  - docker:dind

stages:
  - build
  - test
  - release
  - deploy

variables:
  DOCKER_HOST: tcp://docker:2375
  DOCKER_DRIVER: overlay2
  CONTAINER_TEST_IMAGE: registry.example.com/my-group/my-project/my-image:$CI_COMMIT_REF_SLUG
  CONTAINER_RELEASE_IMAGE: registry.example.com/my-group/my-project/my-image:latest

before_script:
  - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN registry.example.com

build:
  stage: build
  script:
    - docker build --pull -t $CONTAINER_TEST_IMAGE .
    - docker push $CONTAINER_TEST_IMAGE

test1:
  stage: test
  script:
    - docker pull $CONTAINER_TEST_IMAGE
    - docker run $CONTAINER_TEST_IMAGE /script/to/run/tests

test2:
  stage: test
  script:
    - docker pull $CONTAINER_TEST_IMAGE
    - docker run $CONTAINER_TEST_IMAGE /script/to/run/another/test

release-image:
  stage: release
  script:
    - docker pull $CONTAINER_TEST_IMAGE
    - docker tag $CONTAINER_TEST_IMAGE $CONTAINER_RELEASE_IMAGE
    - docker push $CONTAINER_RELEASE_IMAGE
  only:
    - master

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  only:
    - master
```

### Golang

```yml
image: golang:latest

variables:
  # Please edit to your GitLab project
  REPO_NAME: gitlab.com/namespace/project

# The problem is that to be able to use go get, one needs to put
# the repository in the $GOPATH. So for example if your gitlab domain
# is gitlab.com, and that your repository is namespace/project, and
# the default GOPATH being /go, then you'd need to have your
# repository in /go/src/gitlab.com/namespace/project
# Thus, making a symbolic link corrects this.
before_script:
  - mkdir -p $GOPATH/src/$(dirname $REPO_NAME)
  - ln -svf $CI_PROJECT_DIR $GOPATH/src/$REPO_NAME
  - cd $GOPATH/src/$REPO_NAME

stages:
    - test
    - build

format:
    stage: test
    script:
      - go fmt $(go list ./... | grep -v /vendor/)
      - go vet $(go list ./... | grep -v /vendor/)
      - go test -race $(go list ./... | grep -v /vendor/)

compile:
    stage: build
    script:
      - go build -race -ldflags "-extldflags '-static'" -o $CI_PROJECT_DIR/mybinary
    artifacts:
      paths:
        - mybinary
```

### NodeJS

```yml
# Official framework image. Look for the different tagged releases at:
# https://hub.docker.com/r/library/node/tags/
image: node:latest

# Pick zero or more services to be used on all builds.
# Only needed when using a docker container to run your tests in.
# Check out: http://docs.gitlab.com/ce/ci/docker/using_docker_images.html#what-is-a-service
services:
  - mysql:latest
  - redis:latest
  - postgres:latest

# This folder is cached between builds
# http://docs.gitlab.com/ce/ci/yaml/README.html#cache
cache:
  paths:
  - node_modules/

test_async:
  script:
   - npm install
   - node ./specs/start.js ./specs/async.spec.js

test_db:
  script:
   - npm install
   - node ./specs/start.js ./specs/db-postgres.spec.js
```

## Environment Variables
{: .-one-column}

| Variable                       | GitLab | Runner | Description                                                                                                                                                                                                                                                                               |
|--------------------------------|--------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **ARTIFACT_DOWNLOAD_ATTEMPTS** | 8.15   | 1.9    | Number of attempts to download artifacts running a job                                                                                                                                                                                                                                    |
| **CI**                         | all    | 0.4    | Mark that job is executed in CI environment                                                                                                                                                                                                                                               |
| **CI_COMMIT_REF_NAME**         | 9.0    | all    | The branch or tag name for which project is built                                                                                                                                                                                                                                         |
| **CI_COMMIT_REF_SLUG**         | 9.0    | all    | `$CI_COMMIT_REF_NAME` lowercased, shortened to 63 bytes, and with everything except `0-9` and `a-z` replaced with `-`. No leading / trailing `-`. Use in URLs, host names and domain names.                                                                                               |
| **CI_COMMIT_SHA**              | 9.0    | all    | The commit revision for which project is built                                                                                                                                                                                                                                            |
| **CI_COMMIT_BEFORE_SHA**       | 11.2   | all    | The previous latest commit present on a branch before a push request.                                                                                                                                                                                                                     |
| **CI_COMMIT_TAG**              | 9.0    | 0.5    | The commit tag name. Present only when building tags.                                                                                                                                                                                                                                     |
| **CI_COMMIT_MESSAGE**          | 10.8   | all    | The full commit message.                                                                                                                                                                                                                                                                  |
| **CI_COMMIT_TITLE**            | 10.8   | all    | The title of the commit - the full first line of the message                                                                                                                                                                                                                              |
| **CI_COMMIT_DESCRIPTION**      | 10.8   | all    | The description of the commit: the message without first line, if the title is shorter than 100 characters; full message in other case.                                                                                                                                                   |
| **CI_CONFIG_PATH**             | 9.4    | 0.5    | The path to CI config file. Defaults to `.gitlab-ci.yml`                                                                                                                                                                                                                                  |
| **CI_DEBUG_TRACE**             | all    | 1.7    | Whether [debug tracing](#debug-tracing) is enabled                                                                                                                                                                                                                                        |
| **CI_DEPLOY_USER**             | 10.8   | all    | Authentication username of the [GitLab Deploy Token][gitlab-deploy-token], only present if the Project has one related.                                                                                                                                                                   |
| **CI_DEPLOY_PASSWORD**         | 10.8   | all    | Authentication password of the [GitLab Deploy Token][gitlab-deploy-token], only present if the Project has one related.                                                                                                                                                                   |
| **CI_DISPOSABLE_ENVIRONMENT**  | all    | 10.1   | Marks that the job is executed in a disposable environment (something that is created only for this job and disposed of/destroyed after the execution - all executors except `shell` and `ssh`). If the environment is disposable, it is set to true, otherwise it is not defined at all. |
| **CI_ENVIRONMENT_NAME**        | 8.15   | all    | The name of the environment for this job                                                                                                                                                                                                                                                  |
| **CI_ENVIRONMENT_SLUG**        | 8.15   | all    | A simplified version of the environment name, suitable for inclusion in DNS, URLs, Kubernetes labels, etc.                                                                                                                                                                                |
| **CI_ENVIRONMENT_URL**         | 9.3    | all    | The URL of the environment for this job                                                                                                                                                                                                                                                   |
| **CI_JOB_ID**                  | 9.0    | all    | The unique id of the current job that GitLab CI uses internally                                                                                                                                                                                                                           |
| **CI_JOB_MANUAL**              | 8.12   | all    | The flag to indicate that job was manually started                                                                                                                                                                                                                                        |
| **CI_JOB_NAME**                | 9.0    | 0.5    | The name of the job as defined in `.gitlab-ci.yml`                                                                                                                                                                                                                                        |
| **CI_JOB_STAGE**               | 9.0    | 0.5    | The name of the stage as defined in `.gitlab-ci.yml`                                                                                                                                                                                                                                      |
| **CI_JOB_TOKEN**               | 9.0    | 1.2    | Token used for authenticating with the [GitLab Container Registry][registry] and downloading [dependent repositories][dependent-repositories]                                                                                                                                             |
| **CI_JOB_URL**                 | 11.1   | 0.5    | Job details URL                                                                                                                                                                                                                                                                           |
| **CI_REPOSITORY_URL**          | 9.0    | all    | The URL to clone the Git repository                                                                                                                                                                                                                                                       |
| **CI_RUNNER_DESCRIPTION**      | 8.10   | 0.5    | The description of the runner as saved in GitLab                                                                                                                                                                                                                                          |
| **CI_RUNNER_ID**               | 8.10   | 0.5    | The unique id of runner being used                                                                                                                                                                                                                                                        |
| **CI_RUNNER_TAGS**             | 8.10   | 0.5    | The defined runner tags                                                                                                                                                                                                                                                                   |
| **CI_RUNNER_VERSION**          | all    | 10.6   | GitLab Runner version that is executing the current job                                                                                                                                                                                                                                   |
| **CI_RUNNER_REVISION**         | all    | 10.6   | GitLab Runner revision that is executing the current job                                                                                                                                                                                                                                  |
| **CI_RUNNER_EXECUTABLE_ARCH**  | all    | 10.6   | The OS/architecture of the GitLab Runner executable (note that this is not necessarily the same as the environment of the executor)                                                                                                                                                       |
| **CI_PIPELINE_ID**             | 8.10   | 0.5    | The unique id of the current pipeline that GitLab CI uses internally                                                                                                                                                                                                                      |
| **CI_PIPELINE_IID**            | 11.0   | all    | The unique id of the current pipeline scoped to project                                                                                                                                                                                                                                   |
| **CI_PIPELINE_TRIGGERED**      | all    | all    | The flag to indicate that job was [triggered]                                                                                                                                                                                                                                             |
| **CI_PIPELINE_SOURCE**         | 10.0   | all    | Indicates how the pipeline was triggered. Possible options are: `push`, `web`, `trigger`, `schedule`, `api`, and `pipeline`. For pipelines created before GitLab 9.5, this will show as `unknown`                                                                                         |
| **CI_PROJECT_DIR**             | all    | all    | The full path where the repository is cloned and where the job is run                                                                                                                                                                                                                     |
| **CI_PROJECT_ID**              | all    | all    | The unique id of the current project that GitLab CI uses internally                                                                                                                                                                                                                       |
| **CI_PROJECT_NAME**            | 8.10   | 0.5    | The project name that is currently being built (actually it is project folder name)                                                                                                                                                                                                       |
| **CI_PROJECT_NAMESPACE**       | 8.10   | 0.5    | The project namespace (username or groupname) that is currently being built                                                                                                                                                                                                               |
| **CI_PROJECT_PATH**            | 8.10   | 0.5    | The namespace with project name                                                                                                                                                                                                                                                           |
| **CI_PROJECT_PATH_SLUG**       | 9.3    | all    | `$CI_PROJECT_PATH` lowercased and with everything except `0-9` and `a-z` replaced with `-`. Use in URLs and domain names.                                                                                                                                                                 |
| **CI_PIPELINE_URL**            | 11.1   | 0.5    | Pipeline details URL                                                                                                                                                                                                                                                                      |
| **CI_PROJECT_URL**             | 8.10   | 0.5    | The HTTP address to access project                                                                                                                                                                                                                                                        |
| **CI_PROJECT_VISIBILITY**      | 10.3   | all    | The project visibility (internal, private, public)                                                                                                                                                                                                                                        |
| **CI_REGISTRY**                | 8.10   | 0.5    | If the Container Registry is enabled it returns the address of GitLab's Container Registry                                                                                                                                                                                                |
| **CI_REGISTRY_IMAGE**          | 8.10   | 0.5    | If the Container Registry is enabled for the project it returns the address of the registry tied to the specific project                                                                                                                                                                  |
| **CI_REGISTRY_PASSWORD**       | 9.0    | all    | The password to use to push containers to the GitLab Container Registry                                                                                                                                                                                                                   |
| **CI_REGISTRY_USER**           | 9.0    | all    | The username to use to push containers to the GitLab Container Registry                                                                                                                                                                                                                   |
| **CI_SERVER**                  | all    | all    | Mark that job is executed in CI environment                                                                                                                                                                                                                                               |
| **CI_SERVER_NAME**             | all    | all    | The name of CI server that is used to coordinate jobs                                                                                                                                                                                                                                     |
| **CI_SERVER_REVISION**         | all    | all    | GitLab revision that is used to schedule jobs                                                                                                                                                                                                                                             |
| **CI_SERVER_VERSION**          | all    | all    | GitLab version that is used to schedule jobs                                                                                                                                                                                                                                              |
| **CI_SERVER_VERSION_MAJOR**    | 11.4   | all    | GitLab version major component                                                                                                                                                                                                                                                            |
| **CI_SERVER_VERSION_MINOR**    | 11.4   | all    | GitLab version minor component                                                                                                                                                                                                                                                            |
| **CI_SERVER_VERSION_PATCH**    | 11.4   | all    | GitLab version patch component                                                                                                                                                                                                                                                            |
| **CI_SHARED_ENVIRONMENT**      | all    | 10.1   | Marks that the job is executed in a shared environment (something that is persisted across CI invocations like `shell` or `ssh` executor). If the environment is shared, it is set to true, otherwise it is not defined at all.                                                           |
| **GET_SOURCES_ATTEMPTS**       | 8.15   | 1.9    | Number of attempts to fetch sources running a job                                                                                                                                                                                                                                         |
| **GITLAB_CI**                  | all    | all    | Mark that job is executed in GitLab CI environment                                                                                                                                                                                                                                        |
| **GITLAB_USER_EMAIL**          | 8.12   | all    | The email of the user who started the job                                                                                                                                                                                                                                                 |
| **GITLAB_USER_ID**             | 8.12   | all    | The id of the user who started the job                                                                                                                                                                                                                                                    |
| **GITLAB_USER_LOGIN**          | 10.0   | all    | The login username of the user who started the job                                                                                                                                                                                                                                        |
| **GITLAB_USER_NAME**           | 10.0   | all    | The real name of the user who started the job                                                                                                                                                                                                                                             |
| **RESTORE_CACHE_ATTEMPTS**     | 8.15   | 1.9    | Number of attempts to restore the cache running a job                                                                                                                                                                                                                                     |


## References
{: .-one-column}

* <https://docs.gitlab.com/ee/ci/examples/README.html>
* <https://docs.gitlab.com/ee/ci/variables/>
* <https://gitlab.com/gitlab-org/gitlab-ce/tree/master/lib/gitlab/ci/templates>