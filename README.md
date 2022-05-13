### Summary

LATEST does not exclude deleted package versions when resolving dependencies.

If the most recently generated version of a package has been deleted, executing `sfdx force:package:version` for another package that refers to LATEST of the aforementioned package will resolve to the deleted version.

### Steps To Reproduce:

**Repository to reproduce:** [[dreamhouse-lwc](https://github.com/dreamhouseapp/dreamhouse-lwc)](https://github.com/jonnypetraglia/sfdx-error1)

Obviously if you run this your 04t IDs will be different.

##### Step 1: Create two packages

```json
    "packageDirectories": [
        {
            "package": "Foo",
            "path": "Foo",
            "versionNumber": "1.0.0.NEXT",
            "default": true
        },
        {
            "package": "Bar",
            "path": "Bar",
            "versionNumber": "1.0.0.NEXT",
            "dependencies": [
                {
                    "package": "Foo",
                    "versionNumber": "1.0.0.LATEST"
                }
            ]
        }
    ],
```

`sfdx force:package:create -n Foo -r Foo -t Unlocked`
`sfdx force:package:create -n Bar -r Bar -t Unlocked`

##### Step 2: Generate a Foo package version twice

`sfdx force:package:version:create -p Foo -x --wait 9001`
`sfdx force:package:version:create -p Foo -x --wait 9001`

>  === Package Versions [2]
> Package Name  Namespace  Version Name  Version  Subscriber Package Version Id  Alias  Installation Key  Released  Validation Skipped  Ancestor  Ancestor Version  Branch
> ────────────  ─────────  ────────────  ───────  ─────────────────────────────  ─────  ────────────────  ────────  ──────────────────  ────────  ────────────────  ──────
> Foo                      1.0.0         1.0.0.1  04t3n000000ZnCrAAK                    false             false     false               N/A       N/A
> Foo                      1.0.0         1.0.0.2  04t3n000000ZnCwAAK                    false             false     false               N/A       N/A


##### Step 3: Delete the latest Foo

`sfdx force:package:version:delete -p 04t3n000000ZnCwAAK --noprompt`

> Successfully deleted the package version. 04t3n000000ZnCwAAK

Confirm it's really gone:

`sfdx force:package:version:list -p Foo`

> === Package Versions [1]
> Package Name  Namespace  Version Name  Version  Subscriber Package Version Id  Alias        Installation Key  Released  Validation Skipped  Ancestor  Ancestor Version  Branch
> ────────────  ─────────  ────────────  ───────  ─────────────────────────────  ───────────  ────────────────  ────────  ──────────────────  ────────  ────────────────  ──────
> Foo                      1.0.0         1.0.0.1  04t3n000000ZnCrAAK             Foo@1.0.0-1  false             false     false               N/A       N/A

##### Step 4: Attempt to create Bar package version

`sfdx force:package:version:create -p Bar -x --wait 9001`

> Dependency on package Foo was resolved to version number 1.0.0.2, branch null, 04t3n000000ZnCwAAK.
> WARNING: versionName is blank in sfdx-project.json, so it will be set to this default value based on the versionNumber: 1.0.0
> Request in progress. Sleeping 30 seconds. Will wait a total of 540060 more seconds before timing out. Current Status='Initializing'
> Request in progress. Sleeping 30 seconds. Will wait a total of 540030 more seconds before timing out. Current Status='Verifying dependencies'
> Request in progress. Sleeping 30 seconds. Will wait a total of 540000 more seconds before timing out. Current Status='Verifying dependencies'
> ERROR running force:package:version:create:  An error occurred while trying to install a package dependency, ID 04t3n000000ZnCw: The AppExchange package has been deprecated and can no longer be installed.
>         Please try installing a newer version, or contact the package owner directly to resolve.



### Expected result

Depend on the latest *non-deleted* version, i.e. 1.0.0.1

> Dependency on package Foo was resolved to version number 1.0.0.1, branch null, 04t3n000000ZnCrAAK.

### Actual result

Depends on the latest version, even if it has been deleted, i.e. 1.0.0.2

### System Information

```json
{
        "cliVersion": "sfdx-cli/7.150.0",
        "architecture": "win32-x64",
        "nodeVersion": "node-v17.8.0",
        "pluginVersions": [
                "@oclif/plugin-autocomplete 0.3.0 (core)",
                "@oclif/plugin-commands 1.3.0 (core)",
                "@oclif/plugin-help 3.3.1 (core)",
                "@oclif/plugin-not-found 1.2.6 (core)",
                "@oclif/plugin-plugins 1.10.11 (core)",
                "@oclif/plugin-update 1.5.0 (core)",
                "@oclif/plugin-warn-if-update-available 1.7.3 (core)",
                "@oclif/plugin-which 1.0.4 (core)",
                "@salesforce/sfdx-diff 0.0.6",
                "@salesforce/sfdx-plugin-lwc-test 0.1.7 (core)",
                "alias 2.0.0 (core)",
                "apex 0.11.0 (core)",
                "auth 2.0.2 (core)",
                "community 1.1.4 (core)",
                "config 1.4.6 (core)",
                "custom-metadata 1.1.0 (core)",
                "data 0.6.15 (core)",
                "generator 2.0.0 (core)",
                "info 2.0.0 (core)",
                "limits 2.0.0 (core)",
                "mo-dx-plugin 0.3.2",
                "org 1.12.1 (core)",
                "plugin-lightning-testing-service 1.0.1",
                "salesforce-alm 54.3.0 (core)",
                "schema 2.1.0 (core)",
                "sfdx-cli 7.150.0 (core)",
                "sfdx-git-delta 4.12.1",
                "sfdx-git-packager 0.3.3",
                "sfdx-isdot 4.0.0",
                "sfdx-jayree 4.3.10",
                "├─ @jayree/sfdx-plugin-prettier 1.1.4",
                "└─ @jayree/sfdx-plugin-manifest 2.2.0",
                "signups 1.0.0 (core)",
                "source 1.9.7 (core)",
                "telemetry 1.4.0 (core)",
                "templates 54.6.0 (core)",
                "texei-sfdx-plugin 1.14.4",
                "trust 1.1.0 (core)",
                "user 1.7.1 (core)"
        ],
        "osVersion": "Windows_NT 10.0.19042"
}
```

### Additional information

Passing --dev-debug shows that the following SOQL query is run via the Tooling API:

`SELECT MAX(BuildNumber) FROM Package2Version WHERE Package2Id = '0Ho3n000000KyjzCAC' AND MajorVersion = 1 AND MinorVersion = 0 AND PatchVersion = 0 AND Branch = null`

Unless there's some reason to not, simply appending ` AND IsDeprecated = false` to the end would fix it.
