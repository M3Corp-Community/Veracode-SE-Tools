param (
        [parameter(position=0,Mandatory=$True)]
        $nomeTime
    )

# Configura a ferramenta para uso
$pastaVeracode = "D:\Veracode" # O caminho da pasta onde tem as ferramentas da Veracode
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaVeracode")

# Recebe a lista de usuarios 
[xml]$filtroUsuarios = $(VeracodeAPI.exe -action GetUserList -teams "$nomeTime")
$listaUsuarios = $filtroUsuarios.userlist.users.usernames
$listaUsuarios = $listaUsuarios.Split(",")

# Faz o bloqueio das contas que estavam no time
foreach ($usuario in $listaUsuarios) {
    try {
        # Desativa o login
        VeracodeAPI.exe -action updateuser -username "$usuario" -loginenabled False
        # Log de retorno e criação dos usuarios
        Write-Host "Bloqueado Usuario: $usuario"
    }
    catch {
        # Recebendo o erro e exibindo ele, parando a execução
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        # Mostra uma mensagem personalizada
        Write-Host "Erro ao bloquear o usuario: $usuario"
        Write-Host "$ErrorMessage"
    }
}
