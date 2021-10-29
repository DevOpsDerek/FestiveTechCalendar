$resourceGroupName = $OctopusParameters["Azure.ResourceGroup.Name"]
$resourceGroupLocation = $OctopusParameters["Azure.Location.Abbr"]

Try {
	Get-AzureRmResourceGroup -Name $resourceGroupName
    $createResourceGroup = $false
} Catch {
	$createResourceGroup = $true
}

if ($createResourceGroup -eq $true){
	New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
