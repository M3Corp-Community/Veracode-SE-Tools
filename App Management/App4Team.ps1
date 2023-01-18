# Recebe o caminho do txt, onde deve ter um nome de App por linha
# O nome da empresa vai ser usado para buscar pelo mesmo formato que criamos os times
# É preciso que o time já exista
param (
        [parameter(position=0,Mandatory=$True)]
        $nomeEmpresa,
        [parameter(position=1,Mandatory=$True)]
        $caminhoListaApps
    )


# Configura a ferramenta para uso
$pastaVeracode = "D:\Veracode" # O caminho da pasta onde tem as ferramentas da Veracode
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pastaVeracode")

# Faz a configuracao do ambiente da POV
$empresa = "POV_$nomeEmpresa"

# Faz a criação dos usuarios conforme lista
$listaApp = Get-Content -Path $caminhoListaApps
foreach ($nomeApp in $listaApp) {
    try {
        # Cria um novo App
        VeracodeAPI.exe -action createapp -appname "$nomeApp" -criticality "VeryHigh" -teams "$empresa"
        # Log de retorno e criação dos Apps
        Write-Host "App: $nomeApp - Empresa: $empresa"
    }
    catch {
         # Recebendo o erro e exibindo ele, parando a execução
         $ErrorMessage = $_.Exception.Message # Recebe o erro
         # Mostra uma mensagem personalizada
         Write-Host "Erro ao criar o App: $nomeApp"
         Write-Host "$ErrorMessage"
    }
    
}