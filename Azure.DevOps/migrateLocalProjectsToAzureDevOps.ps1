az login --allow-no-subscriptions

Get-ChildItem -Recurse -Directory | ForEach-Object {

	cd $_.Name
	
	az devops project create --name $_.Name --source-control git --visibility private --detect true --organization https://dev.azure.com/{organization}/
	
	git init
	git add .
	git commit -a -m "Initial commit"
	git remote add origin (az repos list --project $_.Name --org https://dev.azure.com/{organization}/ --query [0].webUrl)
	git push -u origin master
	
	cd ..

}