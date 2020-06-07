docker images --format "{{.ID}}\t{{.Repository}}\t{{.Size}}" | awk '{sub(/GB/, "", $3)}1' | awk '{$3=($3 ~ /MB/) ? $3 : $3*1000"MB"}1' | sort -k 3 -h

dexec() {
    docker exec -ti $(docker ps --filter "name=$1" | awk 'NR>1{print $1}') sh
}

dvolumes() {
    docker volume ls --filter "driver=local" --format '{{.Driver}} {{.Name}} {{.Labels}}' | less
}

dlogs () {
    date_old=$(date --rfc-3339=seconds -d "$1"| sed 's/ /T/' | cut -f1 -d"+")
    date_now=$(date --rfc-3339=seconds | sed 's/ /T/' | cut -f1 -d"+")
    docker logs 050e94357f7d --details --since=$(echo $date_old) --until=$(echo $date_now)
}