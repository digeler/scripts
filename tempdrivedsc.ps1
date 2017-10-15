configuration MoveAzureTempDrive
{
    param(
        [Parameter(Mandatory)] 
        [string]$TempDriveLetter
    )

    Import-DscResource -ModuleName MoveAzureTempDrive, xComputerManagement

    Node localhost 
    {

       LocalConfigurationManager 
       {
           RebootNodeIfNeeded = $True
       }      
               
        Script DisablePageFile
        {
        
            GetScript  = { @{ Result = "" } }
            TestScript = { 
               $pf=gwmi win32_pagefilesetting
               #There's no page file so okay to enable on the new drive
               if ($pf -eq $null)
               {
                    return $true
               }
               #Page file is still on the D drive
               if ($pf.Name.ToLower().Contains('d:'))
               {
                    return $false
               }

               else
               {
                    return $true
               }
            
            }
            SetScript  = {
                #Change temp drive and Page file Location 
                gwmi win32_pagefilesetting
                $pf=gwmi win32_pagefilesetting
                $pf.Delete()
                Restart-Computer -Force
            }
           
        }

       MoveAzureTempDrive MoveAzureTempDrive
       {
           TempDriveLetter = $TempDriveLetter           
       }
      
    }
}

configuration MoveAzureTempDrive
{
    param(
        [Parameter(Mandatory)] 
        [string]$TempDriveLetter
    )

    Import-DscResource -ModuleName MoveAzureTempDrive, xComputerManagement

    Node localhost 
    {

       LocalConfigurationManager 
       {
           RebootNodeIfNeeded = $True
       }      
               
        Script DisablePageFile
        {
        
            GetScript  = { @{ Result = "" } }
            TestScript = { 
               $pf=gwmi win32_pagefilesetting
               #There's no page file so okay to enable on the new drive
               if ($pf -eq $null)
               {
                    return $true
               }
               #Page file is still on the D drive
               if ($pf.Name.ToLower().Contains('d:'))
               {
                    return $false
               }

               else
               {
                    return $true
               }
            
            }
            SetScript  = {
                #Change temp drive and Page file Location 
                gwmi win32_pagefilesetting
                $pf=gwmi win32_pagefilesetting
                $pf.Delete()
                Restart-Computer -Force
            }
           
        }

       MoveAzureTempDrive MoveAzureTempDrive
       {
           TempDriveLetter = $TempDriveLetter           
       }
      
    }
}


#######in template #########

                                        {
                                            "properties": {
                                                "publisher": "Microsoft.Powershell",
                                                "type": "DSC",
                                                "typeHandlerVersion": "2.9",
                                                "autoUpgradeMinorVersion": true,
                                                "settings": {
                                                    "configuration": {
                                                        "url": "https://camusextscripts.blob.core.windows.net/scripts/MoveAzureTempDrive.ps1.zip",
                                                        "wmfVersion": "latest",
                                                        "script": "MoveAzureTempDrive.ps1",
                                                        "Function": "MoveAzureTempDrive"
                                                    },
                                                    "configurationArguments": {
                                                        "TempDriveLetter": "Z"
                                                    }
                                                },
                                                "forceUpdateTag": "1.0"
                                            },
                                            "name": "Microsoft.Powershell.DSC"
                                        },
