# You must stage sysmon.exe and elnao-sysmonconfig-export.xml in C:\Program Files\elnao-Files\ before running this script
# I use a GPO to do this. 

$ErrorActionPreference= 'silentlycontinue'
foreach($computer in (get-content .\adworkstations.txt)){
   if (test-connection "$computer" -Count 2) {
     Invoke-command -computername $computer -scriptblock { 

       $SysmonSystemVersion = sysmon | Select-String -pattern "v\d\d"
       $SysmonVersionToBeInstalled = "v10.42"
       
       if ($SysmonSystemVersion -like "*$SysmonVersionToBeInstalled*"){
         Write-Host "Current version already installed on $Env:Computername"}
       else {
         sysmon -u; cd 'C:\Program Files\elnao-Files\'; .\Sysmon.exe -accepteula -i .\elnao-sysmonconfig-export.xml}
      } 
     }
   else {
     Write-Warning "unable to connect to '$computer' - $(Get-Date)"
   }
}
