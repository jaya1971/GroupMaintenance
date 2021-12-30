<# 
.SYNOPSIS
    Script to monitor the addition and removal of members of a specific group and take action.
    Schedule this script on a task scheduler server to run in incremental time

.INPUTS
    Modify the $Group and $GroupPath variable 
.OUTPUTS

.NOTES
    Author:         Alex Jaya
    Creation Date:  08/06/2021
    Modified Date:  08/12/2021

.EXAMPLE

#>
Import-Module ActiveDirectory

$Group = 'NAMEOFGROUP'
$GroupPath = 'PATH'
$Previous ="$GroupPath\PreviousMonitor.csv"
$currentMembers = Get-AdGroupMember -Identity $Group | Select-Object samaccountname
$previousMembers = import-csv -Path $Previous | Select-Object samaccountname

#Detect deleted members
$RemoveUsers = $previousMembers | Where-Object -FilterScript{$_.samaccountname -notin $currentMembers.samaccountname} | Select-Object -ExpandProperty samaccountname

#Detect new members
$AddUsers = $currentMembers | Where-Object -FilterScript{$_.samaccountname -notin $previousMembers.samaccountname} | Select-Object -ExpandProperty samaccountname

Get-AdGroupMember -Identity $Group | Select-Object samaccountname | Export-Csv -Path $Previous -Encoding UTF8 -NoTypeInformation

#-Take Action Here-------

#Action on New Users
if($AddUsers){
    foreach($user in $AddUsers){
        #Action
    }
}


#Action on Removed Users
if($RemoveUsers){
    foreach($user in $RemoveUsers){
        #Action
    }
}
