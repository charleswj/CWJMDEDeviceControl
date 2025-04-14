$moduleName = $PSScriptRoot.Split('\')[-1]

$srcPath     = "$PSScriptRoot\src"
$publicPath  = "$srcPath\public"
$privatePath = "$srcPath\private"
$classesPath = "$srcPath\classes"

$buildPath  = "$PSScriptRoot\build"
$modulePath = "$buildPath\$moduleName"




task Build {

    if(-not (Test-Path $modulePath))
    {
        New-Item $modulePath -ItemType Directory | Out-Null
    }

    $publicFiles  = Get-ChildItem -Path $publicPath  -Filter *.ps1 -Recurse -Force -File
    $privateFiles = Get-ChildItem -Path $privatePath -Filter *.ps1 -Recurse -Force -File
    $classesFiles = Get-ChildItem -Path $classesPath -Filter *.ps1 -Recurse -Force -File

    $AddContentParams = @{
        Path     = "$modulePath\$moduleName.psm1"
        Encoding = 'utf8'
    }
    
    foreach($file in ($publicFiles+$privateFiles+$classesFiles))
    {
        Add-Content @AddContentParams -Value (Get-Content -Path $file.FullName)
    }

    Copy-Item -Path "$srcPath\$moduleName.psd1" -Destination $modulePath

    $FunctionsToExport = $publicFiles.BaseName | Where-Object{$_ -Match '^[^-]+-[^-]+$'}
    
    ##### temporary to ensure old function names still work #####
    $AliasesToExport = $publicFiles.BaseName | Where-Object{$_ -Match '^[^-]+-[^-]+$'} | Where-Object{$_ -cmatch 'Xml'} | ForEach-Object{$_ -creplace '(.*)Xml(.*)','$1$2Xml'}

    $AddContentParams = @{
        Path     = "$modulePath\$moduleName.psm1"
        Encoding = 'utf8'
    }
    ##### END temporary to ensure old function names still work #####







    ##### Increment version #####
    $versionPath = "$PSScriptRoot\version.txt"

    $version = [version]::Parse((Get-Content -Path $versionPath))
    
    $version = '{0}.{1}.{2}' -f $version.Major,$version.Minor,($version.Build+1)

    Set-Content -Value $version -Path $versionPath -Encoding utf8



    $UpdatePSModuleManifestParams = @{
        Path              = "$modulePath\$moduleName.psd1"
        RootModule        = "$moduleName.psm1"
        ModuleVersion     = $version
        FunctionsToExport = $FunctionsToExport
        AliasesToExport   = $AliasesToExport
    }
    Update-PSModuleManifest @UpdatePSModuleManifestParams
        




}

# # Synopsis: Remove temp files.
task Clean {
    remove $modulePath
    # sleep 5
}


task PublishToPowerShellGallery {        

    $apiKey = Read-Host -Prompt 'Enter PowerShell Gallery API key' -MaskInput

    $PublishModuleParams = @{
        Path        = $modulePath
        NuGetApiKey = $apiKey
        Repository  = 'PSGallery'
        # WhatIf      = $true
    }

    Publish-Module @PublishModuleParams

}


# Synopsis: Build and clean.
# task . Build, Clean
task . Clean, Build
