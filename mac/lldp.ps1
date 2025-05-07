#!/usr/local/bin/pwsh
Write-Output "Waiting for LLDP packet..."

$lldp=(tcpdump -i en0 ether proto 0x88cc -v -c 1 2>&1)
$systemName=($lldp | grep "System Name" | awk -F: '{print $2}') -replace " ",""
$systemIP=($lldp | grep "Management Address" | grep -E '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | awk -F: '{print $2}') -replace " ",""
$PVID=($lldp | grep "PVID" | awk -F: '{print $2}') -replace " ",""


function get-portline{
$lineno=0
foreach($line in $lldp){
    $lineno++
    if ($line -like "*Port ID*"){
        if($line -like "*:*"){
            return $lineno-1
        }
        return $lineno
    }

}
}
$portline=get-portline
$port=($lldp[$portline] | awk -F: '{print $2}') -replace " ",""




Write-Output "Switch Name: $systemName"
Write-Output "Switch IP: $systemIP"
Write-Output "Switch Port: $port"
Write-Output "Switch Vlan: $PVID"% 
