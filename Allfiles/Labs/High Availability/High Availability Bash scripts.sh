#change dp300storage to a unique account name. You can only use lowercase letters and numbers
az storage account create -n dp300storage -g dp300lab07 --kind StorageV2 -l eastus2 

#Change the value behind -g to the resource group 
#retain the output of this command for the next statement

az storage account keys list -g DP-300-Lab02dp300lab07 -n dp300storage 

#This creates container for backups. Use the key from the above step to replace "storage_key"
az storage container create --name "backups" --account-name "dp300storage" --account-key "storage_key" --fail-on-exist 

#To further verify the container backups has been created, execute this command
#Replace storage_key and the account name with the name and keys created above
az storage container list --account-name "dp300storage" --account-key "storage_key" 

#Change dp300storage to the storage account name you created above, storage_key to the key generated above, and date_in_the_future to a time later than now. 
#date_in_the_future must be in UTC. An example is 2020-012-31T00:00Z which translates to expiring at December 31, 2020 at midnight.  
 
az storage container generate-sas -n "backups" --account-name "dp300storage" --account-key "storage_key" --permissions "rwdl" --expiry "date_in_the_future" -o tsv 

#Copy the output of this command as it will used in the next task