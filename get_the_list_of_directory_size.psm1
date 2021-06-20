Set-StrictMode -Version Latest

function Measure-Directory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Path",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string[]]
        $Path
    )
    
    begin {
        
    }
    
    process {
        foreach ($p in $Path) {
            $convertedPath = Convert-Path $p
            Write-Verbose $convertedPath

            $childItems = @(Get-ChildItem -LiteralPath $convertedPath -Force -File)

            [long]$totalLength = 0
            
            if ($childItems.Length -gt 0) {
                $totalLength = ($childItems | Measure-Object -Property Length -Sum).Sum
            }
            
            [PSCustomObject]@{
                Length = $totalLength
                LengthMB = [Math]::Round($totalLength / 1MB, 2)
                LengthGB = [Math]::Round($totalLength / 1GB, 2)
                Count = $childItems.Length
                FullName = $convertedPath
            }
        }
    }
    
    end {
        
    }
}