**GPP-AUTO-COMPILE** é uma script escrita em Bash para automatizar a compilação de arquivo C/C++ com header files.

Compilando arquivos em C:

    ./GPP_COMPILE.sh -b "/bin/gcc" -e -f c-project/

Compilando arquivos em C++

    ./GPP_COMPILE.sh -e -f cpp-project/
<br><br>
Opções 
  - **-f** < diretório > // Especifica o diretório do projeto
  - **-i** // Ignora, se o diretório `.obj` já existir
  - **-b** < arquivo > // Especifica o arquivo binário do compilador ( default: /bin/g++ ) 
  - **-a** // Irá tentar compilar todos os arquivos no diretório ( com excerção dos header files )
  - **-p** // Não irá apagar o diretório `.obj` depois que o script terminar de ser executado
  - **-e** // Irá executar automáticamente o arquivo do programa, após a compilação terminar
  - **-t** // Irá apagar o arquivo do programa depois que o script terminar de ser executado
  - **-C** // Irá copiar todo o projeto para a pasta `.obj`
  - **-c** // Não irá exibir mensagens de avisos no output
