Function Get-Uptime
{
	[CmdletBinding()]
	[OutputType([System.TimeSpan])]
	Param
	(
		[Parameter(
            Mandatory = $false,
	        Position = 0
        )]
        [ValidateNotNullOrEmpty()]
		[String[]]
        $ComputerName
	)
	
    $params = @{
        Class = 'Win32_OperatingSystem'
    }
    if ($ComputerName) {
        $params.ComputerName = $ComputerName
    }

	$os = Get-WmiObject @params
	
    (Get-Date) - ($os.ConvertTodateTime($os.LastBootUpTime))
		
<#
.SYNOPSIS
Gets the uptime for one or more computers.

.PARAMETER ComputerName
The name(s) of the computer(s) for which uptime is needed. If not specified, the local computer is checked.

.LINK
https://github.com/itadder/Get-Uptime

#>
}
