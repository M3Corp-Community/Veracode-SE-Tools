param (
        [parameter(position=0,Mandatory=$True)]
        $nomeTime
    )

# Configura a ferramenta para uso
$pastaVeracode = "D:\Veracode" # O caminho da pasta onde tem as ferramentas da Veracode
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaVeracode")

# Recebe a lista de usuarios que não podem ser removidos
$usuariosVIP = "","",""

# Recebe a lista de usuarios 
[xml]$filtroUsuarios = $(VeracodeAPI.exe -action GetUserList -teams "$nomeTime")
$listaUsuarios = $filtroUsuarios.userlist.users.usernames
$listaUsuarios = $listaUsuarios.Split(",")

# Faz o bloqueio das contas que estavam no time
foreach ($usuario in $listaUsuarios) {
    try {
        # Valida se é um usuario VIP
        $vipStatus = $usuariosVIP.Contains($usuario)
        if ($vipStatus -eq "False") {
            # Desativa o login
            VeracodeAPI.exe -action deleteuser -username "$usuario"
            # Log de retorno e criação dos usuarios
            Write-Host "Usuario removido: $usuario"
        }
    }
    catch {
        # Recebendo o erro e exibindo ele, parando a execução
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        # Mostra uma mensagem personalizada
        Write-Host "Erro ao remover o usuario: $usuario"
        Write-Host "$ErrorMessage"
    }
}
