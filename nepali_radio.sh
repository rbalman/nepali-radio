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

function play_radio {

    radio_station_link=$(get_radio_station_link $radio_station_number)
    echo "playing $radio_station_link" && sleep 2
    mplayer $radio_station_link

}

function print_files {

cat -n $RADIO_FEED

}

## Echos the list
get_radio_links
parse_the_links
print_files


while true
do
    echo -n "Station:Number ~> " ; read radio_station_number

    case $radio_station_number in
	[0-9]*) play_radio $radio_station_number
		;;
	quit|exit|q) echo "exiting.." && exit 0
	        ;;
	h|help) echo "not much to help"
		;;
	* ) echo "Invalid Entry"
	        ;;
    esac
    
done


