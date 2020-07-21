try {
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'";
        Start-Process powershell -Verb runAs -ArgumentList $arguments;
        Break;
    }

    $date_now = Get-Date;
    $expiredDate = $date_now.AddYears(2);
    $cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname fuhoCommunity.identityserver.com -notafter $expiredDate;

    $path = 'cert:\localmachine\my\' + $cert.thumbprint;
    $scriptpath = $MyInvocation.MyCommand.Path;
    $currentDir = Split-Path $scriptpath;
    $filePath = [string]$currentDir + '\fuhoCertificate.pfx';
    $cerFilePath = [string]$currentDir + '\fuhoCertificate.cer';
    $password = ConvertTo-SecureString -String 'thanhtran12tuoi!' -Force -AsPlainText;

    Export-Certificate -Cert $path -FilePath $cerFilePath;
    Export-PfxCertificate -Cert $path -FilePath $filePath -Password $password;

    <# Command #>
    echo "-----------------------------------";
    echo "Certificates are created in $currentDir";
    echo "-----------------------------------";
    echo "Use below command for more commands";
    echo "-----------------------------------";
    echo "Get-Command -Module PKI";
    echo "-----------------------------------";

    Read-Host -Prompt "Press [Enter] button to exit";
    exit
}

catch {
    Write-Error $_.Exception.Message
    Read-Host -Prompt "The above error occurred. Press Enter to exit."
}