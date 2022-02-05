#!/usr/bin/env bash
execute_key="0"
ignore_key="0"
clear_key="0"
temp_key="0"
bin_key="0"
dir_key="0"
all_key="0"
ac_key="0"
p_key="0"
for option in $@; do
	if [[ "$dir_key" == "1" ]]; then
		dir=$option
		dir_key="0"
    elif [[ "$bin_key" == "1" ]]; then
		bin=$option
		bin_key="0"
	fi
	case $option in
	"-f")
		dir_key="1"     ;;
	"-i")
		ignore_key="1"  ;;
	"-b")
		bin_key="1"     ;;
	"-a")
		all_key="1"		;;
	"-p")
		p_key="1"		;;
	"-e")
		execute_key="1"	;;
	"-t")
		temp_key="1"	;;
	"-C")
		ac_key="1"		;;
	"-c")
		clear_key="1"	;;
	esac
	if [[ "$ignore_key" == "1" ]]; then
		ignore="1"
		ignore_key="0"
	elif [[ "$p_key" == "1" ]]; then
		p="1"
		p_key="0"
	elif [[ "$all_key" == "1" ]]; then
		all="1"
		all_key="0"
	elif [[ "$execute_key" == "1" ]]; then
		execute="1"
		execute_key="0"
	elif [[ "$temp_key" == "1" ]]; then
		temp="1"
		temp_key="0"
	elif [[ "$clear_key" == "1" ]]; then
		clear="1"
		clear_key="0"
	elif [[ "$ac_key" == "1" ]]; then
		ac="1"
		ac_key="0"
	fi
done
if [[ ! $bin ]]; then
	bin="/bin/g++"
fi 
if [[ ! -f $bin ]]; then
	echo "[ERRO] O arquivo '$bin' não foi encontrado."
	exit
fi
if [[ ! $ignore && -d ".obj" ]]; then
	echo "[ERRO] Já existe um diretório chamado '.obj' no diretório atual. Use a opção '-i' para ignorar isso."
	exit
fi
if [[ ! $dir ]]; then
	echo "[ERRO] O diretório não foi espécificado."
	echo "		Como usar: $0 -f <dir>"
	exit
fi
if [[ ! -d $dir ]]; then
	echo "[ERRO] O diretório espéficado ( $dir ) não existe."
	exit
fi
if [[ ! -d ".obj" ]]; then
	mkdir ".obj"
fi
if [[ $ac ]]; then
	for file in $(echo $dir*); do 
		if [[ ! $clear ]]; then 
			echo "[AVISO] Copiando '$file' para '.obj/'"
		fi
		cp -r $file .obj
	done
fi
for file in $(find $dir -type f -exec echo "{}" \;); do
	if [[ $file == $0 ]]; then
		continue
	elif [[ $( basename $file | rev | cut -d "." -f1 | rev ) != "cpp" && $( basename $file | rev | cut -d "." -f1 | rev ) != "h" && $( basename $file | rev | cut -d "." -f1 | rev ) != "c" && ! $all ]]; then
		continue
	fi
	if [[ $(echo $(basename $file) | cut -d "." -f2) == "h" ]]; then
		if [[ ! $clear ]]; then
			echo "[AVISO] Copiando '$file' para '.obj/"$(basename $file)"'..."
		fi
		cp $file ".obj/"
		continue
	fi
	new_filename=$(echo $(basename $file)".o")
	if [[ ! $clear ]]; then
		echo "[AVISO] Compilando $file..."
	fi
	$bin -c $file -o ".obj/"$new_filename
done
all_files=""
for file in .obj/*; do
	all_files="$all_files $file"
done
if [[ ! $temp ]]; then
	echo -n ">> Nome do arquivo de saida: "
	read output
else
	output="TEMP_FILE_E"
fi 
if [[ ! $clear ]]; then
	echo "[AVISO] Linkando arquivos..."
fi
$bin $all_files -o $output
if [[ ! $p ]]; then
	if [[ ! $clear ]]; then
		echo "[AVISO] Removendo o diretório '.obj/'..."
	fi
	rm -r .obj/
fi
if [[ $execute ]]; then
	if [[ ! $clear ]]; then
		echo "[AVISO] Executando o programa..."
	fi
	./$output
fi
if [[ $temp ]]; then
	if [[ ! $clear ]]; then
		echo "[AVISO] Removendo o programa..."
	fi
	rm -f $output
fi
