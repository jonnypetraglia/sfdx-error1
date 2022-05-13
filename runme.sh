## Create packages
sfdx force:package:create -n Foo -r Foo -t Unlocked
sfdx force:package:create -n Bar -r Bar -t Unlocked

## Create some Foo versions
sfdx force:package:version:create -p Foo -x --wait 9001
sfdx force:package:version:create -p Foo -x --wait 9001

sfdx force:package:version:list -p Foo
# === Package Versions [2]
# Package Name  Namespace  Version Name  Version  Subscriber Package Version Id  Alias  Installation Key  Released  Validation Skipped  Ancestor  Ancestor Version  Branch
# ────────────  ─────────  ────────────  ───────  ─────────────────────────────  ─────  ────────────────  ────────  ──────────────────  ────────  ────────────────  ──────
# Foo                      1.0.0         1.0.0.1  04t3n000000ZnCrAAK                    false             false     false               N/A       N/A
# Foo                      1.0.0         1.0.0.2  04t3n000000ZnCwAAK                    false             false     false               N/A       N/A

## Delete the latest versions
sfdx force:package:version:delete -p 04t3n000000ZnCwAAK --noprompt
# Successfully deleted the package version. 04t3n000000ZnCwAAK

sfdx force:package:version:list -p Foo
# === Package Versions [1]
# Package Name  Namespace  Version Name  Version  Subscriber Package Version Id  Alias        Installation Key  Released  Validation Skipped  Ancestor  Ancestor Version  Branch
# ────────────  ─────────  ────────────  ───────  ─────────────────────────────  ───────────  ────────────────  ────────  ──────────────────  ────────  ────────────────  ──────
# Foo                      1.0.0         1.0.0.1  04t3n000000ZnCrAAK             Foo@1.0.0-1  false             false     false               N/A       N/A


echo 'Please run the delete the `force:package:version:delete` with the appropriate Foo 04t version.'
echo 'Then run `sfdx force:package:version:create -p Bar -x`'
exit

## Command to run and output:
sfdx force:package:version:create -p Bar -x --wait 9001
# Dependency on package Foo was resolved to version number 1.0.0.2, branch null, 04t3n000000ZnCwAAK.
# WARNING: versionName is blank in sfdx-project.json, so it will be set to this default value based on the versionNumber: 1.0.0
# Request in progress. Sleeping 30 seconds. Will wait a total of 540060 more seconds before timing out. Current Status='Initializing'
# Request in progress. Sleeping 30 seconds. Will wait a total of 540030 more seconds before timing out. Current Status='Verifying dependencies'
# Request in progress. Sleeping 30 seconds. Will wait a total of 540000 more seconds before timing out. Current Status='Verifying dependencies'
# ERROR running force:package:version:create:  An error occurred while trying to install a package dependency, ID 04t3n000000ZnCw: The AppExchange package has been deprecated and can no longer be installed.
#         Please try installing a newer version, or contact the package owner directly to resolve.
