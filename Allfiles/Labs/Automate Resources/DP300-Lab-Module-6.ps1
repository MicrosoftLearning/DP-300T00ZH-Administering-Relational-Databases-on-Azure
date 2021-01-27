$AzureSQLServerName = " "
$AzureDatabase = "sample-db-with-tde"
$Cred = Get-AutomationPSCredential -Name "SQLUser"
$SQLOutput = $(Invoke-Sqlcmd -ServerInstance $AzureSQLServerName `
    -Username $Cred.Username -Password $Cred.GetNetworkCredential().Password `
    -Database $AzureDatabase -Query "EXEC dbo.usp_AdaptiveIndexDefrag" -Verbose) 

Write-Output $SQLOutput
