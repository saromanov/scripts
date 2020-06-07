
# docker images отсортированный по размеру образа
dimsorted(){
    docker images --format "{{.ID}}\t{{.Repository}}\t{{.Size}}" | awk '{sub(/GB/, "", $3)}1' | awk '{$3=($3 ~ /MB/) ? $3 : $3*1000"MB"}1' | sort -k 3 -h
}

# вход в контейнер по его имени
# dexec redis
dexec() {
    docker exec -ti $(docker ps --filter "name=$1" | awk 'NR>1{print $1}') sh
}

# Показ списка Volumes по имени драйвера
# dvolumes local
dvolumes() {
    docker volume ls --filter "driver=$1" --format '{{.Driver}} {{.Name}} {{.Labels}}' | less
}

# Возвращает логи из контейнера по date range
# date range использует формат команды date
# dlogs_out redis "-1 days"
# возвращает логи, которые были в контейнеры со вчерашнего дня до текущего момента
dlogsrange () {
    date_old=$(date --rfc-3339=seconds -d "$2"| sed 's/ /T/' | cut -f1 -d"+")
    date_now=$(date --rfc-3339=seconds | sed 's/ /T/' | cut -f1 -d"+")
    docker logs $(docker ps --filter "name=$1" | awk 'NR>1{print $1}') --details --since=$(echo $date_old) --until=$(echo $date_now)
}

# Колоризированный вывод json
dinspect () {
    docker inspect $1 | jq
}