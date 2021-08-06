<# 
.SYNOPSIS
    Script to monitor the addition and removal of members of a specific group and take action.
    Schedule this script on a task scheduler server to run in incremental time

.INPUTS
    Modify the $Group and $GroupPath variable 
.OUTPUTS
    DelGroupMembers.csv and NewGroupMembers.csv will be used when modifying the PNE attribute
    You will have to configure the variables for path and csv names

.NOTES
    Author:         Alex Jaya
    Creation Date:  08/06/2021

.EXAMPLE

#>
Import-Module ActiveDirectory

$Group = 'NAMEOFGROUP'
$GroupPath = 'PATH'
$Previous ="$GroupPath\PreviousMonitor.csv"
$current ="$GroupPath\CurrentMonitor.csv"

#Detect deleted members
Get-AdGroupMember -Identity $Group | Select-Object samaccountname |export-csv -Path $current -Encoding UTF8 -NoTypeInformation
$currentMembers = Get-AdGroupMember -Identity $Group | Select-Object -ExpandProperty samaccountname
import-csv -path $Previous | Where-Object {$Currentmembers -notcontains $_.samaccountname} | Export-Csv "$GroupPath\DelGroupMembers.csv" -NoTypeInformation

#Detect new members
$previousMembers = import-csv -Path $Previous | Select-Object -ExpandProperty samaccountname
import-csv -path $Current | Where-Object {$Previousmembers -notcontains $_.samaccountname} | Export-Csv "$GroupPath\NewGroupMembers.csv" -NoTypeInformation

Get-AdGroupMember -Identity $Group | Select-Object samaccountname | Export-Csv -Path $Previous -Encoding UTF8 -NoTypeInformation

#-Take Action Here

#Action on New Users
$NewUsers = Import-Csv "$GroupPath\NewGroupmembers.csv" -Delimiter ","
foreach($user in $NewUsers){
    #Action
}

#Action on Removed Users
$RemovedUsers = Import-Csv "$GroupPath\DelGroupmembers.csv" -Delimiter ","
foreach($user in $RemovedUsers){
    #Action
}
