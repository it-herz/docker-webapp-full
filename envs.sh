IFS=$'\n'
set -f

for v in $(cat /etc/envs)
do
    export $v
done
