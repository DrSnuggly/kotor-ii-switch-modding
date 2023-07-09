# Switch title ID for KotOR II
$TitleId="0100B2C016252000"
# root romfs folder
$GameRootBaseName="romfs"
$GameDir="./$TitleId/$GameRootBaseName"
# where to store backups of the romfs folder
$BackupDir="./$GameRootBaseName.backup"
# directory for the collection of file lists
$FileListDir="./file-lists"

# game override directory
$OverridePrefix="override"
$OverrideDir="$GameDir/$OverridePrefix"

# the Localized English folder as it appears in the Switch-only game folder
$LocalizedPrefix="Localized/English"
$LocalizedDir="$GameDir/$LocalizedPrefix"

# pre-flight checks
function Test-Preflight() {
  # ensure requisite folders are present
  if (!(Test-Path -Path "$GameDir" -PathType Container)){
    Write-Host ""
    Write-Error "$GameDir cannot be found. Exiting."
    exit 10
  }
  if (!(Test-Path -Path "$FileListDir" -PathType Container)) {
    Write-Host ""
    Write-Error "$FileListDir cannot be found. Exiting."
    exit 11
  }
}

# game folder status functions
function Test-Initialized() {
  if (Test-Path -Path "$OverrideDir" -PathType Container) {
    return $true
  }
  return $false
}
function Test-Finalized() {
  if (Test-Path -Path "$LocalizedDir" -PathType Container) {
    return $true
  }
  return $false
}

# other
function Write-Success($Text) {
  Write-Host -ForegroundColor Green $Text
}
