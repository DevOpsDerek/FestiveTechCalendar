# Force use of TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define parameters
$baseUrl = $OctopusParameters['Global.Base.Url']
$apiKey = $OctopusParameters['Global.Api.Key']
$spaceId = $OctopusParameters['Octopus.Space.Id']
$spaceName = $OctopusParameters['Octopus.Space.Name']
$environmentName = $OctopusParameters['Octopus.Environment.Name']
$name = $OctopusParameters['Project.ProductService.Name']

# Get worker
$machine = (Invoke-RestMethod -Method Get -Uri "$baseUrl/api/$spaceId/machines/all" -Headers @{"X-Octopus-ApiKey"="$apiKey"}).Items | Where-Object {$_.Name -eq "$name"}

# Build payload
$jsonPayload = @{
	Name = "Health"
    Description = "Check $spaceName-$environmentName health"
    Arguments = @{
    	Timeout = "00:05:00"
        MachineIds = @(
        	$machine.Id
        )
    OnlyTestConnection = "false"
    }
    SpaceId = "$spaceId"
}

# Execute health check
Invoke-RestMethod -Method Post -Uri "$baseUrl/api/tasks" -Body ($jsonPayload | ConvertTo-Json -Depth 10) -Headers @{"X-Octopus-ApiKey"="$apiKey"}

#/api/{baseSpaceId}/workerpools/{id}/workers
