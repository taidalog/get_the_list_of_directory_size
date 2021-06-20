$measureDirectoryModuleName = "get_the_list_of_directory_size.psm1"
$measureDirectoryModulePath = Join-Path $PSScriptRoot $measureDirectoryModuleName

Import-Module $measureDirectoryModulePath -Force

$csvFilePrefix = "DirectorySizes_"
$datetimeFormat = "yyyy-MM-dd_HH-mm-ss"
$csvExtension = ".csv"
$csvPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "$($csvFilePrefix)$((Get-Date).ToString($datetimeFormat))$($csvExtension)"

[long]$n = 0

foreach ($a in $args) {
    $directorySizes = Get-ChildItem -LiteralPath $a -Recurse -Directory | Measure-Directory

    foreach ($ds in $directorySizes) {
        [long]$lengthTotal = 0
        $subDirectoriesAndItself = @($directorySizes | Where-Object {$_.FullName -match "$([regex]::Escape($ds.FullName))(\\.+)?"})

        if ($subDirectoriesAndItself.Length -gt 0) {
            $lengthTotal = ($subDirectoriesAndItself | Measure-Object -Property Length -Sum).Sum
        }

        $ds | Select-Object `
            @{label="Length"; expression={$_.Length}},
            @{label="LengthMB"; expression={$_.LengthMB}},
            @{label="LengthGB"; expression={$_.LengthGB}},
            @{label="LengthTotal"; expression={$lengthTotal}},
            @{label="DirectoryCount"; expression={$subDirectoriesAndItself.Length}},
            @{label="FullName"; expression={$_.FullName}} | 
            Export-Csv -Path $csvPath -Encoding utf8 -Append -NoTypeInformation
        
        $n++
        
        $writeProgressParameters = @{
            Activity = "Measureing Directory Size..."
            Status = ([string]::Format("{0,8} directories", $n))
            Id = 0
            PercentComplete = -1
        }

        Write-Progress @writeProgressParameters
    }
}

Pause