#!/bin/bash

# this script is called from pipelines to validate a proper semantic version on the first line of 'VERSION.txt'
# it does NOT support a 'v' prefix (v0.0.0)
# it optionally checks that an entry is included in 'CHANGELOG.md'

# PowerShell's built-in [semver] type is used to perform a greater than operation
# a bash equivalent function would need to be created if PowerShell is not available

# Bash safeties: exit on error, pipelines can't hide errors
set -o errexit
set -o pipefail

# get the directory of this script and source print-colors.sh for better readability of the script's outputs
SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source-path=scripts/cicd # tell shellcheck where to look
source "${SCRIPT_ROOT}/../common/print-colors.sh"

releaseVersion="$(head -1 VERSION.txt)"

##########
# validate tag syntax
print_info "Validating semantic version syntax in VERSION.txt ..."
SEMVER_PATTERN='^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
# use perl-regexp for compatibility with '\d'
if echo "${releaseVersion}" | grep --perl-regexp --quiet "${SEMVER_PATTERN}" ; then
    print_success "'$releaseVersion' is a valid semantic release version number."
else
    print_error "'$releaseVersion' is not a valid semantic release version number. \n \
    refer to https://semver.org/ for valid pattern, using the 2nd regular expression at the bottom of the page."
    exit 1
fi

##########
# validate no tag duplication
print_info "Checking if the git tag already exists for release version ..."
# the expected return code if the tag doesn't exit is 2
# save non-zero exit codes in a temporary variable to avoid the entire script from failing
rc=0
git ls-remote --tags --exit-code origin "refs/tags/${releaseVersion}" || rc=$?
if [[ $rc -eq 2 ]] ; then
    print_success "'$releaseVersion' git tag does not exist."
else
    print_error "'$releaseVersion' git tag already exists or repo could not be reached.  \n \
    Please check and update VERSION.txt"
    exit 1
fi

##########
# validate tag increment
print_info "Checking if the release version is newer than the latest existing tag version ..."
git fetch --tags --recurse-submodules=no

# ensure a properly formatted tag exists before performing comparison
if git tag | grep --perl-regexp --quiet "${SEMVER_PATTERN}" ; then

    # using powershell's built-in [semver] type to perform the greater than operation
    # save non-zero exit codes in a temporary variable to avoid the entire script from failing
    # shellcheck disable=SC2086 # double quote suggestion for ${SEMVER_PATTERN}
    currentLatestVersion="$(git tag | grep --perl-regexp ${SEMVER_PATTERN} | sort --reverse --version-sort | head -1)"
    rc=0
    pwsh -Command "if (-not ([semver]\"$releaseVersion\" -gt [semver]\"$currentLatestVersion\") ) {exit 1}" || rc=$?
    if [[ $rc -eq 0 ]] ; then
        print_success "'$releaseVersion' is greater than latest existing tag '$currentLatestVersion'."
    else
        print_error "'$releaseVersion' is not greater than latest existing tag '$currentLatestVersion'."
        exit 1
    fi
else
    print_success "'$releaseVersion' will be the first release version. A properly formatted tag does not currently exist."
fi

##########
# validate changelog, unless the 'VALIDATE_CHANGELOG' env. variable is set to false
if [[ "${VALIDATE_CHANGELOG}" != "false" ]] ; then
    print_info "Checking if release version is referenced in CHANGELOG.md ..."

    if grep --fixed-strings --quiet "[${releaseVersion}]" CHANGELOG.md ; then
        print_success "'[$releaseVersion]' is included in CHANGELOG.md."
    else
        print_error "'[$releaseVersion]' is not found in CHANGELOG.md.  \n \
        Please make sure the CHANGELOG.md is updated with the released changes."
        exit 1
    fi
fi

##########
# validate when tag is created
print_info "Checking if the tag should be created (when pipeline is running through CI on push to main trigger) ..."

# Azure DevOps and GitHub runners have environment variables to check specific run conditions
# a tag should not be created if it runs from a PR or if it runs manually

if [[ "${BUILD_SOURCEBRANCHNAME}" == "main" ]] && [[ "${BUILD_REASON}" == "IndividualCI" || "${BUILD_REASON}" == "BatchedCI" ]] ; then
  echo -e "Creating and pushing tag to Azure DevOps repo ...\n"
  git tag "${releaseVersion}"
  git push origin tag "${releaseVersion}"

elif [[ "${GITHUB_REF_NAME}" == "main" && "${GITHUB_EVENT_NAME}" == "push" ]] ; then
  echo -e "Creating and pushing tag to GitHub repo ...\n"
  git tag "${releaseVersion}"
  git push origin tag "${releaseVersion}"

else
  echo -e "A tag will not be created yet. The pipeline is either running from a PR or manually.\n"
fi
