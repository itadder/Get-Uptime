Function Get-uptime
{
	
	[CmdletBinding()]
	[OutputType([int])]
	Param
	(
		# Param1 help description
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[string[]]$ComputerName
		
	)
	
	if ($ComputerName -ne $null)
	{
		
		
		
		# Try one or more commands
		try
		{
			$os = Get-wmiobject -ComputerName $ComputerName win32_operatingsystem -ErrorAction stop
			$uptime = (get-date) - ($os.ConvertTodateTime($os.lastbootuptime))
			$display = $uptime.days
			write-output $display
		}
		# Catch specific types of exceptions thrown by one of those commands
        catch {
            Write-Warning "Machine $Computername is offline" -ForegroundColor Yellow -BackgroundColor Black
        }

	}
	
	
	else
	{
		
		$os = Get-wmiobject win32_operatingsystem
		$uptime = (get-date) - ($os.ConvertTodateTime($os.lastbootuptime))
		$display = $uptime.days
		write-output $display
		
		
	}
}
