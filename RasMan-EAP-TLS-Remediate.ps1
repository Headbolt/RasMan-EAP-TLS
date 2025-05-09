###############################################################################################################
#
# ABOUT THIS PROGRAM
#
#   RasMan-EAP-TLS-Remediate.ps1
#   https://github.com/Headbolt/RasMan-EAP-TLS
#
#  This script was designed to Remediate specific registry values
#
#  Intended use is in Microsoft Endpoint Manager, as the "Remediate" half of a Proactive Remediation Script
#  The "Check" half is found here https://github.com/Headbolt/RasMan-EAP-TLS
#
###############################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 09/05/2025
#
#   - 09/05/2025 - V1.0 - Created by Headbolt
#
###############################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################
#
$SystemKey="HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\PPP\EAP\13"
$Value="TlsVersion"
$Data="4032"
#
###############################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################
#
# Begin Processing
#
###############################################################################################################
#
Write-Host ""
$SystemKeyCheck=(Get-Item $SystemKey).property # Grab values from key
$SystemValueCheck=(select-string -pattern "\b$Value\b" -InputObject $SystemKeyCheck) # Grab desired value from key
#
if ([string]::IsNullOrEmpty($SystemValueCheck)) # Check value exists 
{
	Write-Host "$SystemKey\$Value Does not exist"
	Write-Host 'Running Command'
	Write-Host "New-ItemProperty -Path $SystemKey -Name $Value -PropertyType DWORD -Value $Data | Out-Null"
	New-ItemProperty -Path $SystemKey -Name $Value -PropertyType DWORD -Value $Data | Out-Null # Create value
}
else
{
	Write-Host "$SystemKey\$Value exists"
	$SystemDataCheck=((Get-ItemProperty -Path $SystemKey -Name $Value).$Value) # Grab value data
	#
	Write-Host "$SystemKey\$Value should be $Data and is $SystemDataCheck"
	if ( $SystemDataCheck -ne $Data) # Check value data
	{
		Write-Host 'Running Command'
		Write-Host "New-ItemProperty -Path $SystemKey -Name $Value -PropertyType DWORD -Value $Data -Force | Out-Null"
		New-ItemProperty -Path $SystemKey -Name $Value -PropertyType DWORD -Value $Data -Force | Out-Null # Update value
	}
}
