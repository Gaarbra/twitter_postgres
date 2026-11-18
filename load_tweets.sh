#!/bin/sh

DENORMALIZED_PORT=11133
NORMALIZED_PORT=21133

files='
test-data.zip
'

echo 'load normalized'
for file in $files; do
    python3 load_tweets.py --db=postgresql+psycopg2://postgres:pass@localhost:$NORMALIZED_PORT/ --inputs "$file"
done

echo 'load denormalized'
for file in $files; do
    unzip -p "$file" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:$DENORMALIZED_PORT/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done
