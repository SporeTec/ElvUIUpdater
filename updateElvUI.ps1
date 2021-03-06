$versionOLD=0

#Exit if the config file isn't there
if (-Not (Test-Path -Path '.\wowpath.cfg')) {
    msg console /server:localhost "Your wowpath.cfg isn't there SUKA!"
    exit
}

$WOWPath = Get-Content '.\wowpath.cfg' -Raw
#Exit if the Path to WOW doesnt exist
if (-Not (Test-Path -Path $WOWPath)){
    msg console /server:localhost "Ding Dong your wowpath is wrong!"
    exit
}

#If ElvUI is installed check the toc file for the installed version number
if (Test-Path -Path $WOWPath/ElvUI/ElvUI.toc){
    $versionOLD = Select-String -Path $WOWPath'\ElvUI\ElvUI.toc' -Pattern 'Version\: ([0-9]+.[0-9]+)' -AllMatches | % { $_.Matches.Groups[1] } | % { $_.Value }
}

Invoke-WebRequest "https://www.tukui.org/download.php?ui=elvui#version" -OutFile elvui.html
if($error){
	msg console /server:localhost "Error appeared, try again"
    Remove-Item -Path '.\elvui.html'
    exit
}

$version = Select-String -Path '.\elvui.html' -Pattern '<b class="Premium">([0-9]+.[0-9]+)</b>' -AllMatches | % { $_.Matches.Groups[1] } | % { $_.Value }
if($error){
	msg console /server:localhost "Error appeared, try again"
	Remove-Item -Path '.\tmpfile'
	exit
}

if($versionOLD -lt $version){
    if (-Not (Test-Path -Path "elvui-$version.zip")){
        Invoke-WebRequest "https://www.tukui.org/downloads/elvui-$version.zip" -OutFile "elvui-$version.zip"
        if($error){
            msg console /server:localhost "Error appeared, try again"
            Remove-Item -Path 'elvui-'+$version+'.zip'
            exit
        }
    }
    Expand-Archive -Path ".\elvui-$version.zip" -DestinationPath $WOWPath -Force
    if($error){
        msg console /server:localhost "Error appeared, try again"
        Remove-Item -Path "elvui-$version.zip"
        exit
    }
    msg console /server:localhost "Installed ElvUI version "$version" succesfully"
    exit
} else{
    msg console /server:localhost "Newest ElvUI version is already downloaded and installed BLYAT!"
}