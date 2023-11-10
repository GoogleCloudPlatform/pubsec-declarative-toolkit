#!/bin/bash

# script to run YAML validation in CI environment
# it may eventually be used to run and control different validations (hydrate, unit test, gatekeeper, etc.)

# Bash safeties: exit on error, pipelines can't hide errors
set -o errexit
set -o pipefail

# check if a new git commit should be created and pushed when diff in hydrated configs are detected
if [[ "${ENABLE_PUSH_ON_DIFF}" == "true" ]] ; then

    # set the branch name, it's stored in different env. variables in Azure DevOps and GitHub (and during Pull Requests)
    # AzDO PR
    if [[ "${BUILD_REASON}" == "PullRequest" && "${SYSTEM_PULLREQUEST_SOURCEBRANCH}" != "" ]] ; then
        # the PR source branch is formatted as 'refs/heads/branch-name', the command below removes the starting 'refs/heads/'
        export BRANCH_NAME_TO_UPDATE="${SYSTEM_PULLREQUEST_SOURCEBRANCH//'refs/heads/'/}"
    # AzDO default
    elif [[ "${BUILD_SOURCEBRANCHNAME}" != "" ]] ; then
        export BRANCH_NAME_TO_UPDATE="${BUILD_SOURCEBRANCHNAME}"
    # GitHub PR
    elif [[ "${GITHUB_EVENT_NAME}" == "pull_request" && "${GITHUB_HEAD_REF}" != "" ]] ; then
        export BRANCH_NAME_TO_UPDATE="${GITHUB_HEAD_REF}"
    # GitHub default
    elif [[ "${GITHUB_REF_NAME}" != "" ]] ; then
        export BRANCH_NAME_TO_UPDATE="${GITHUB_REF_NAME}"
    else
        echo "Can't determine the branch name."
    fi

    # if a branch name was found, set the required git configs for adding a commit, fetch all branches
    # TODO: future improvement, accept email/name as variables, possibly git creds as well (could be in scripts/common if tagging requires the same)
    if [[ "${BRANCH_NAME_TO_UPDATE}" != "" ]] ; then
        git config --global user.email "hydrate-script@example.com"
        git config --global user.name "hydrate-script"
        git fetch --recurse-submodules=no
    fi
fi

bash tools/scripts/kpt/hydrate.sh


# ###### for future use if using dev container ######
# # if RUN_WITH_DOCKER is true, run with the docker image passed in DOCKER_IMAGE
# # TODO: set default image if DOCKER_IMAGE not defined
# if [[ "${RUN_WITH_DOCKER}" == "true" ]] ; then
#     docker run \
#         --volume /var/run/docker.sock:/var/run/docker.sock \
#         --volume $PWD:/workspace \
#         --workdir /workspace \
#         --user $(id -u):$(id -g) \
#         --env VALIDATE_YAML_KUBEVAL \
#         --env VALIDATE_YAML_NOMOS \
#         ${DOCKER_IMAGE} \
#         bash tools/scripts/kpt/hydrate.sh
# else
#     bash tools/scripts/kpt/hydrate.sh
# fi
