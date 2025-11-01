# 🛠️ Otimizador do Sistema (Windows)

Um script em Batch (.bat) para otimizar o desempenho do Windows, limpar arquivos temporários, gerenciar aplicativos de segundo plano, configurar o plano de energia, testar desempenho e atualizar todos os softwares instalados automaticamente via Winget.

## Features
- Desativa serviços do Windows que podem reduzir desempenho (SysMain, WinSAT)
- Configura automaticamente o plano de energia para Alto Desempenho
- Limpa arquivos temporários do usuário e do sistema
- Gerencia aplicativos de segundo plano (ativar/desativar)
- Testa desempenho do PC usando WinSAT
- Atualiza automaticamente todos os programas instalados via Winget
- Gera log detalhado das atualizações (update_log.txt)
- Possibilidade de execução completa (“Otimizacao Completa”) com todas as funções juntas

## How It Works
- Script em Batch (.bat) rodando com privilégios administrativos
- Usa cmd.exe e PowerShell para executar tarefas específicas:
  - sc e taskkill para serviços do Windows
  - powercfg para configurar plano de energia
  - reg add para ativar/desativar aplicativos de segundo plano
  - winget para atualizar softwares
- Estrutura de funções silenciosas (_silent) para otimização completa sem prompts desnecessários
- Geração de log automático das atualizações para auditoria

## Getting Started
1. Baixe o arquivo windows_otimizador_br.bat
2. Clique com o botão direito → Executar como administrador

## Menu Options
1. Desativar SysMain
2. Desativar WinSAT
3. Ativar plano de energia Alto Desempenho
4. Limpar arquivos temporários
5. Otimizacao Completa
6. Teste de desempenho PC
7. Ativar/Desativar apps de segundo plano
8. Atualizar softwares via Winget
9. Executar script online (⚠️ atenção: este item é opcional e deve ser usado com responsabilidade)
0. Sair

## Notes
- Recomendado para Windows 10/11
- Winget deve estar instalado para a opção de atualização funcionar corretamente
- Arquivo de log das atualizações é salvo no mesmo diretório do script (update_log.txt)
- É recomendável executar como administrador para evitar erros de permissão

## License
MIT License

## Author
Celmar Pereira de Andrade
- GitHub: https://github.com/CelmarPA
- LinkedIn: https://linkedin.com/in/celmar-pereira-de-andrade-039830181

## Feedback
Contribuições, sugestões e melhorias são bem-vindas!
