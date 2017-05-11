#!/bin/bash

RADIO_FEED=$HOME/.radio-feed
RADIO_FEED_XML=$RADIO_FEED.xml

## GET RADIO LINK
function get_radio_links {

    echo "curling the feeds"
    curl -so $RADIO_FEED_XML 'http://radio.nepal.fm/radio-feed/'

}


function parse_the_links {

    echo "parsing the xml feeds"
    awk -F '[<>]' '/location/{print $3}' $RADIO_FEED_XML > $RADIO_FEED

}


function get_radio_station_link {

    line_number=${1:-1}
    sed -n "$line_number"p $RADIO_FEED

}

## Echos the list

get_radio_links
parse_the_links

i=0;
while read -r line
do
    i=$((i + 1))
    echo $i.$line
    
done < $RADIO_FEED

while true
do
    echo -n "staion:number ~>" ; read radio_station_number
    radio_station_link=$(get_radio_station_link $radio_station_number)
    echo "playing $radio_station_link" && sleep 2
    
    mplayer $radio_station_link
done
