#region functions
Function check-YN {
    [CmdletBinding()]
    Param (
        [parameter(ValueFromPipeline,Position=0)]
        [String[]]
        $value,
        $originalQuestion="Please answer Y or N"
    )
    $isValidAnswer = @("true","false","yes","no", "y", "n", "Y","N", "YES", "NO", "TRUE", "FALSE") -contains $value 
    if($isValidAnswer)
    {
         $result =  @("true","yes", "y", "Y", "YES") -contains $value 
         Write-debug "$value is valid answer: $isValidAnswer"
         Write-Output ([System.Convert]::ToBoolean($result))
    }
    else
    {
         do{
              $value = read-host "try again. $originalQuestion :"
              $isValidAnswer = @("true","false","yes","no", "y", "n", "Y","N", "YES", "NO", "TRUE", "FALSE") -contains $value 
              Write-debug "$value is valid answer: $isValidAnswer"
         }
         while($isValidAnswer -eq $false)
         $result =  @("true","yes", "y", "Y", "YES") -contains $value 
         Write-Output ([System.Convert]::ToBoolean($result))
    }
}
#endregion




write-host "Do you wish to install and use chocolatey package installer?:"-ForegroundColor Cyan
write-host "Y or N: " -ForegroundColor Cyan -NoNewline
$global:chocoInstall =  read-host | check-YN 
if($chocoInstall -eq $true)
{
    #install the chocolatey package manager by first setting execution policy to bypass
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    # install docker desktop
    choco install docker-desktop -y;
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -ErrorAction SilentlyContinue
}
else {
    write-host "WARNING: You selected not to use chocolatey. This means you MUST have docker desktop installed. press enter to contine" -ForegroundColor DarkYellow
    read-host

}

if((docker ps 2>&1) -match '^(?!error)'){
    write-host "running docker compose!" -foregroundcolor green
    docker-compose up --build -d
    Clear-Host
    write-host "Do you wish to install SQL Server Management Studio?:"-ForegroundColor Cyan
    write-host "Y or N: " -ForegroundColor Cyan -NoNewline
    $ssmsInstall =  read-host | check-YN 
    if($ssmsInstall -eq $true)
    {
        write-host "Installing SQL Server Management Studio (SSMS)" -ForegroundColor Yellow
        (choco install sql-server-management-studio -y) -and  (Clear-Host) -and (write-host "SSMS installed successfully!" -ForegroundColor Green)
    }

 }
 else {
    Write-Host "Docker is either not installed or NOT running." -ForegroundColor Red
 }



    
