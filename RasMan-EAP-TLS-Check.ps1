###############################################################################################################
#
# ABOUT THIS PROGRAM
#
#   RasMan-EAP-TLS-Check.ps1
#   https://github.com/Headbolt/RasMan-EAP-TLS
#
#  This script was designed to Check specific registry values
#  and then exit with an appropriate Exit code.
#
#  Intended use is in Microsoft Endpoint Manager, as the "Check" half of a Proactive Remediation Script
#  The "Remediate" half is found here https://github.com/Headbolt/RasMan-EAP-TLS
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
$SystemKeyCheck=(Get-Item $SystemKey).property # Grab values from key
$SystemValueCheck=(select-string -pattern "\b$Value\b" -InputObject $SystemKeyCheck) # Grab desired value from key
#
if ([string]::IsNullOrEmpty($SystemValueCheck)) # Check value exists 
{
	Write-Host "$SystemKey\$Value Does not exist"
	Exit 1 # Value does not exist, exit with failure code
}
else
{
	Write-Host "$SystemKey\$Value exists"
	$SystemDataCheck=((Get-ItemProperty -Path $SystemKey -Name $Value).$Value) # Grab value data
	#
	Write-Host "$SystemKey\$Value should be $Data and is $SystemDataCheck"
	if ( $SystemDataCheck -ne $Data) # Check value data
	{
		Exit 1 # Value data is incorrect, exit with failure code 
	}
}
 Exit 0 # All value data is correct, exit with success code 
