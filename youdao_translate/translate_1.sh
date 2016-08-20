# 调用有道http接口进行翻译

set -x

function init() {
    jq=/usr/local/bin/jq
    api="http://fanyi.youdao.com/openapi.do?keyfrom=alfred-llm-0858&key=425214878&type=data&doctype=json&version=1.1&"
    item_format="<item uid=\"\" arg=\"\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle> </item>"
}

function query_api() {
    if [[ $# < 1 ]];then
        echo "Usage: query_api \"word_to_query\", exit 100"
        exit 100
    fi
    content=$(curl --silent -G $api --data-urlencode "q=$1")
}

function parse_content() {
    
    if [[ $# < 1 ]];then
        echo "Usage: parse_result \"api_content\", exit 100"
        exit 100
    fi
    translation=$(echo $1 | $jq ".translation | join(\"# \")" | sed -e 's/^"//g' -e 's/"$//g')
    basic_explains=$(echo $1 | $jq ".basic.explains | join(\"#\")" | sed -e 's/^"//g' -e 's/"$//g')
    web_kv=$(echo $1 | $jq "[.web[] | {\"key\": .key, \"value\": .value | join(\"; \")} | .key + \": \" + .value] | join(\"#\")" | sed -e 's/^"//g' -e 's/"$//g')
    #us_phonetic=$(echo $1 | $jq ".basic | to_entries | .[0].value" | sed 's/ //g')
    phonetic=$(echo $1 | $jq ".basic.phonetic" | sed -e 's/ //g' -e 's/^"//g' -e 's/"$//g')
}

function print_items() {
    if [[ $# != 2 ]];then
        echo "Usage: print_items \"items title\""
        exit 100
    fi
    local items=$1
    local title=$2
    for item in $items
    do
        echo $(printf "$item_format" "$item" "$title")
    done
}

function display() {
    echo "<?xml version=\"1.0\"?> <items>"
    #print_items "$us_phonetic" "us_phonetic"
    print_items "$phonetic" "phonetic"
    echo $IFS
    OLD_IFS=$IFS
    IFS='#'
    print_items "$translation" "youdao translation"
    print_items "$basic_explains" "youdao dict"
    print_items "$web_kv" "web translation"
    IFS=$OLD_IFS
    echo "</items>"
}

function main() {
    init
    query_api "$@"
    parse_content "$content"
    display
}

main "$@"

