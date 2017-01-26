function Get-Uptime
{	
	[cmdletbinding()]
	[OutputType([string])]
	param (
		# Enter a computer name to check to uptime
		[Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
		[string[]]$ComputerName = $env:COMPUTERNAME		
	)
	
    begin
    {
        $classname = 'Win32_OperatingSystem'
        $cmd = 'Get-CimInstance'
        $wmi = 'Get-WmiObject'
        if (-not (Get-Command -Name $cmd -ErrorAction SilentlyContinue))
        {
            $cmd = $wmi
        }
    }
    process
    {
        foreach ($c in $ComputerName)
        {
            try
            {
                try
                {
    	            $os = & $cmd -ComputerName $c -ClassName $classname -ErrorAction Stop
                }
                catch
                {
                    $os = & $wmi -ComputerName $c -ClassName $classname -ErrorAction Stop
                }
                
                if ($cmd -eq $wmi)
                {
                    $boottime = [System.Management.ManagementDateTimeconverter]::ToDateTime($os.LastBootUpTime)
                }
                else
                {
                    $boottime = $os.LastBootUpTime
                }

                $uptime = (Get-Date) - ($boottime)
                
                switch ($uptime.TotalMinutes)
                {
                    {[int]$_ -in 20..60 }
                    {
                        'Uptime for {0} is {1:n2} minutes' -f $c,$uptime.TotalMinutes
                    }
                    {[int]$_ -in 60..1440}
                    {
                        'Uptime for {0} is {1:n1} hors' -f $c,$uptime.TotalHours
                    }
                    default
                    {
                        'Uptime for {0} is {1:0} days' -f $c,$uptime.TotalDays
                    }
                }
            }
            catch
            {
                Write-Warning -Message ('Unable to get uptime for {0} - {1}' -f $c, $_.Exception.Message)
            }
        }
    }
}