function Set-Credentials
{

    $Credentials = Get-Credential


    git config --global user.name $Credentials.UserName
    git config --global user.password $Credentials.Password

}