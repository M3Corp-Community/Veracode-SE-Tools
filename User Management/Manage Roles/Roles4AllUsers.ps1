# Configura a ferramenta para uso
$pastaVeracode = "D:\Veracode" # O caminho da pasta onde tem as ferramentas da Veracode
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaVeracode")

# Configurações
$roles = "Greenlight IDE User,Security Insights,Reviewer,Submitter"

# Recebe a lista de usuarios 
[xml]$filtroUsuarios = $(VeracodeAPI.exe -action GetUserList)
$listaUsuarios = $filtroUsuarios.userlist.users.usernames
$listaUsuarios = $listaUsuarios.Split(",")

# Atribui o conjunto de roles para todos os usuarios no Tenant
foreach ($usuario in $listaUsuarios) {
    try {
        # Atribui o conjunto de roles
        VeracodeAPI.exe -action updateuser -username "$usuario" -roles $roles
        # Log de retorno e criação dos usuarios
        Write-Host "Atribuido ao Usuario: $usuario"
    }
    catch {
        # Recebendo o erro e exibindo ele, parando a execução
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        # Mostra uma mensagem personalizada
        Write-Host "Erro ao configurar o usuario: $usuario"
        Write-Host "$ErrorMessage"
    }
}