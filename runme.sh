sfdx force:org:create --apiversion 53.0 --definitionfile config/project-scratch-def.json --durationdays 2 --setdefaultusername
sfdx force:package:install -w 42 -p 04t3n000000lD02AAE
sfdx force:source:deploy -x manifest.xml


