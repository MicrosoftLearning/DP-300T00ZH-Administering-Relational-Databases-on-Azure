# Configure Backup to URL - Step 5
###########

az storage account create -n dp300storage -g DP-300-HADR --kind StorageV2 -l eastus2

az storage account keys list -g DP-300-HADR -n dp300storage

# Step 6
########

az storage container create --name "backups" --account-name "dp300storage" --account-key "storage_key" --fail-on-exist

# Step 7
########

az storage container list --account-name "dp300storage" --account-key "storage_key"

# Step 8
########

az storage container generate-sas -n "backups" --account-name "dp300storage" --account-key "storage_key" --permissions "rwdl" --expiry "date_in_the_future" -o tsv

# Back Up WideWorldImporters - Step 7
########

az storage blob list -c "backups" --account-name "dp300storage" --account-key "storage_key"
