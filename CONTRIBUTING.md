# How to Contribute

We'd love to accept your patches and contributions to this project. There are
just a few small guidelines you need to follow.

## Contributor License Agreement

Contributions to this project must be accompanied by a Contributor License
Agreement (CLA). You (or your employer) retain the copyright to your
contribution; this simply gives us permission to use and redistribute your
contributions as part of the project. Head over to
<https://cla.developers.google.com/> to see your current agreements on file or
to sign a new one.

You generally only need to submit a CLA once, so if you've already submitted one
(even if it was for a different project), you probably don't need to do it
again.

## Code Reviews

All submissions, including submissions by project members, require review. We
use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/articles/about-pull-requests/) for more
information on using pull requests.

## KPT Packages

In order to maintain consistency accross kpt packages, we strive to maintain the following standards.

### Generic

1. Google's License text is included at the beginning of each resource file
1. Avoid blank lines
1. `metadata.name` include the `project-id` prefix only when K8S uniqueness is required
1. `spec.resourceID` include the `project-id` prefix only when GCP uniqueness is required
1. Resource's fields/subfields are ordered as per resource's schema
1. Resource's reference should use `name` instead of `external` as much as possible

### Comments

1. A comment line is included prior to every resources definition
1. The resource description field has the same information as the comment line at the beginning of the resource definition
1. Avoid comments on same line as a field
1. `kpt-merge` comment should be removed
1. Include a comment for every setter in `setters.yaml`

### Annotations

1. Include

    - `depends-on` for every resource

1. Remove :

    - `cnrm.cloud.google.com/blueprint: 'kpt-fn'`

### Markdown

1. `readme.md` is generated using the command below. Replace `REPO_PACKAGE_DIR` and `LOCAL_PACKAGE_DIR` accordingly.

    ```shell
    REPO_URL=https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/REPO_PACKAGE_DIR
    kpt fn eval -i generate-kpt-pkg-docs:unstable --mount type=bind,src="LOCAL_PACKAGE_DIR",dst="/tmp",rw=true -- readme-path=/tmp/README.md repo-path=$REPO_URL
    ```

1. `securitycontrols.md` is included in the package (where applicable)
1. Avoid images in documentation to maintain small sized packages

### Quality Assurance

1. Package can successfully be deployed in a GCP environment
1. Package can successfully be removed from a GCP environment
1. Config Connector, Config Controller, ConfigSync and Policy Controller logs are not showing any errors when deploying or removing the package

## Community Guidelines

This project follows
[Google's Open Source Community Guidelines](https://opensource.google/conduct/).
