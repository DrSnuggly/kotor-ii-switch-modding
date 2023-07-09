& "./bin/util/Common"

$AssetsDir="./assets"
$PcFolders="$file_list_dir/pc-folders.txt"


Write-Host ""
Write-Host -NoNewLine "Running pre-flight checks... "
# ensure the game folder exists before running the rest of the pre-flight checks
mkdir -p "$GameDir"
Test-Preflight
# ensure resulting folders aren't present
if (Test-Finalized) {
  Write-Host ""
  Write-Error "Cannot initialize a finalized game folder, please restore a backup or archive before continuing. Exiting." \
    | fold -s
  exit 1
}
# ensure requisite folders are present
if (!(Test-Path "$AssetsDir" -PathType Leaf)) {
  Write-Host ""
  Write-Error "$AssetsDir cannot be found. Exiting."
  exit 12
}
# ensure requisite files are present
if (!(Test-Path "$AssetsDir/dialog.tlk" -PathType Leaf)) {
  Write-Host ""
  Write-Error "$AssetsDir/dialog.tlk cannot be found. Exiting."
  exit 22
}
if (!(Test-Path "$AssetsDir/swplayer.ini" -PathType Leaf)) {
  Write-Host ""
  Write-Error "$AssetsDir/swplayer.ini cannot be found. Exiting."
  exit 23
}
Write-Host "Done."


$Confirmation=$Args[0]
while ($true) {
  # skip if the game folder has no contents
  if (!(Get-ChildItem "$GameDir")) { break }

  # prompt for input
  if (!$Confirmation) {
    Write-Host ""
    $Confirmation = Read-Host "Remove existing game folder contents? [y/n]"
  }

  # ensure valid input
  switch ($Confirmation) {
    "y" { $Confirmation = $true; break }
    "n" { $Confirmation = $false; break }
  }
  Write-Warning "Invalid input."
  $Confirmation=$null
}
Write-Host ""

# remove files
if ($Confirmation -and (Test-Path "$GameDir" -PathType Container)) {
  Write-Host -NoNewLine "Removing any existing game folder contents... "
  $Count=0
  Get-ChildItem $GameDir | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force | Out-Null
    $Count++
  }
  Write-Host "Deleted $Count item(s)."
}

Write-Host -NoNewLine "Mirroring PC folder structure... "
$Count=0
New-Item -Path "$GameDir" -ItemType Container -Force
while IFS= read -r $TargetUnprefixedPath; do
  # don't use mkdir -p, so we get an accurate creation $Count
  mkdir "$GameDir/$TargetUnprefixedPath" 2> /dev/null && $Count=$(($Count + 1))
done < "$PcFolders"
Write-Host "Created $Count folder(s)."

Write-Host -NoNewLine "Copying assets... "
$Count=0
Copy-Item -Path "$AssetsDir/dialog.tlk" "$GameDir/dialog.tlk" && $Count++
Copy-Item -Path "$AssetsDir/swplayer.ini" "$GameDir/swplayer.ini" && $Count++
Write-Host "Copied $Count file(s)."


Write-Host ""
Write-Success "Finished!"
