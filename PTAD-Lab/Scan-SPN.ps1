$spnList = cat spn-list.txt

$adsiEntryObj = New-Object -TypeName System.DirectoryServices.DirectoryEntry
$adsiSearcherObj = New-Object -TypeName System.DirectoryServices.DirectorySearcher

$adsiSearcherObj.SearchRoot = $adsiEntryObj

foreach ($spn in $spnList) {
    
    $adsiSearcherObj.filter = "serviceprincipalname=$spn"
    $results = $adsiSearcherObj.findall()
    if ($results.count -gt 0 ) {
        "`n`nSPN found: $spn"
        "====================================================="
        foreach ($result in $results) {
            
            "samAccountName: " + $result.Properties.samaccountname
            "servicePrincipalName: " + $result.Properties.serviceprincipalname
            "ADSPath: " + $result.Properties.adspath
            "Object Category: " + $result.Properties.objectcategory
            "---------------------------------------------------`n"
        }
    }
}
