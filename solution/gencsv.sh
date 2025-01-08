if [ $# -ne 2 ]; then
    echo "Usage: ./gencsv.sh <start_index> <end_index>"
    exit 1
fi

start=$1
end=$2

if [ $start -ge $end ]; then
    echo "Start index must be less than end index."
    exit 1
fi

> inputFile
for i in $(seq $start $end); do
    echo "$i, $((RANDOM % 1000))" >> inputFile
done

