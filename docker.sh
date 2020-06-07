docker images --format "{{.ID}}\t{{.Repository}}\t{{.Size}}" | awk '{sub(/GB/, "", $3)}1' | awk '{$3=($3 ~ /MB/) ? $3 : $3*1000"MB"}1' | sort -k 3 -h