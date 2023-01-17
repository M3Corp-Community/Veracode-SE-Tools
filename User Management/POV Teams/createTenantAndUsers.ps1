# Recebe o caminho do CSV, que precisa estar no formado:
# Nome, Sobrenome, Email
param (
        [parameter(position=0,Mandatory=$True)]
        $nomeEmpresa,
        [parameter(position=1,Mandatory=$True)]
        $caminhoListaUsuarios
    )


# Configurações
$roles = "Greenlight IDE User,Security Insights,Reviewer,Submitter"

# Faz a configuracao do ambiente da POV
$empresa = "Partner_$nomeEmpresa"
VeracodeAPI.exe -action createteam -teamname $empresa

# Faz a configuracao do Header
$Header = 'Nome', 'Sobrenome', 'Email'

# Faz a criação dos usuarios conforme lista
$listaUsuarios = Import-Csv -Path $caminhoListaUsuarios -Header $Header -Delimiter ","
foreach ($usuario in $listaUsuarios) {
    try {
        # Faz o tratamento das informações
        $nome = $usuario.Nome
        $sobrenome = $usuario.Sobrenome
        $email = $usuario.Email

        # Cria um novo usuario
        VeracodeAPI.exe -action createuser -firstname "$nome" -lastname "$sobrenome" -emailaddress "$email" -roles $roles -teams $empresa
        # Log de retorno e criação dos usuarios
        Write-Host "Usuario: $nome $sobrenome"
        Write-Host "Email: $email - Empresa: $empresa"
    }
    catch {
         # Recebendo o erro e exibindo ele, parando a execução
         $ErrorMessage = $_.Exception.Message # Recebe o erro
         # Mostra uma mensagem personalizada
         Write-Host "Erro ao criar o usuario: $nome $sobrenome"
         Write-Host "$ErrorMessage"
    }
    
}