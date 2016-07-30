#!/bin/sh

query=$1

jq=/usr/local/bin/jq

if [[ $query != "" ]];then
    api_result=$(curl --silent -G "http://fanyi.youdao.com/openapi.do?keyfrom=alfred-llm-0858&key=425214878&type=data&doctype=json&version=1.1&" --data-urlencode "q=$query")
    translation=$(echo $api_result | $jq ".translation | join(\"; \")")
    basic_explains=$(echo $api_result | $jq ".basic.explains | join(\"#\")")
    web_kv=$(echo $api_result | $jq "[.web[] | {\"key\": .key, \"value\": .value
        | join(\"; \")} | .key + \": \" + .value] | join(\"#\")")
fi

rt="<item uid=\"\" arg=\"\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle> </item>"

translation=$(echo "$translation" | sed -e 's/ //g' -e 's/^"//g' -e 's/"$//g')
basic_explains=$(echo "$basic_explains" | sed -e 's/^"//g' -e 's/"$//g')
web_kv=$(echo "$web_kv" | sed -e 's/^"//g' -e 's/"$//g')

echo "<?xml version=\"1.0\"?> <items>"

for p in $translation
do
    echo $(printf "$rt" "$p" "youdao translation")
done

OLD_IFS=$IFS
IFS=#

for p in $basic_explains
do
    echo $(printf "$rt" "$p" "youdao dict")
done

for p in $web_kv
do
    echo $(printf "$rt" "$p" "web translation")
done

IFS=$OLD_IFS
echo "</items>"
