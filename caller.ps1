$measureDirectoryModuleName = "get_the_list_of_directory_size.psm1"
$measureDirectoryModulePath = Join-Path $PSScriptRoot $measureDirectoryModuleName

Import-Module $measureDirectoryModulePath -Force

$csvFilePrefix = "DirectorySizes_"
$datetimeFormat = "yyyy-MM-dd_HH-mm-ss"
$csvExtension = ".csv"
$csvPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "$($csvFilePrefix)$((Get-Date).ToString($datetimeFormat))$($csvExtension)"

foreach ($a in $args) {
    Get-ChildItem -LiteralPath $a -Recurse -Directory | Measure-Directory | Export-Csv -Path $csvPath -Encoding utf8 -Append -NoTypeInformation
}

Pause