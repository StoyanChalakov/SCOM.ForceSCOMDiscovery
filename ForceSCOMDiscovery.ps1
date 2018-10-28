############################################################################## 
# 
#   ForceSCOMdiscovery.ps1 
# 
#   Original Script by: Bradc
#   Found in the comment section of:
#   https://matthewlong.wordpress.com/2013/01/24/scom-2012-manually-triggering-a-discovery-via-the-scom-console-on-demand-discovery/
##############################################################################

Param (
    [string]$DisplayName,
    [string]$ManagementServer
)

try {
    $Task = Get-SCOMTask -Name Microsoft.SystemCenter.TriggerOnDemandDiscovery
    $Discovery = Get-SCOMDiscovery -DisplayName $DisplayName
    $Override = @{DiscoveryId=$Discovery.Id.ToString();TargetInstanceId=$Discovery.Target.Id.ToString()}
    $Instance = Get-SCOMClass -Name Microsoft.SystemCenter.ManagementServer | Get-SCOMClassInstance | where {$_.Displayname –eq "$ManagementServer"}
    Start-SCOMTask -Task $Task -Instance $Instance -Override $Override
}

catch {
    $ErrorMessage = "Unable to trigger the discovery"
    Write-Verbose "ErrorMessage: $ErrorMessage"
    Throw $ErrorMessage
}

