#!/bin/sh

# Quick script to parse a CSV file and generate the js array/hash
# used by the tech radar visualisation
# NOTE: Only a POC and not a true CSV parser. 
#       Beware of "," in descriptions (parsing is a simple awk command)

# add the head of the js
cat radar_visualization-header.js

# generate the data by reading 
input="./tech-radar-data.csv"
while IFS= read -r line
do
  LABEL=`echo "$line" | awk -F',' '{print $1}'`
  QUADRANT=`echo "$line" | awk -F',' '{print $2}'`
  RING=`echo "$line" | awk -F',' '{print $3}'`
  MOVED=`echo "$line" | awk -F',' '{print $4}'`
  DESC=`echo "$line" | awk -F',' '{$1=$2=$3=$4=""; print $0}'`
  QUADRANT_NO=1
  RING_NO=1
  MOVED_NO=0

  # skip the header - just contains the column names
  if [ "$LABEL" = "name" ] ; then
    continue
  fi

  case "$QUADRANT" in
    "Techniques" )
        QUADRANT_NO=0 ;;
    "Tooling" )
        QUADRANT_NO=1 ;;
    "Platforms" )
        QUADRANT_NO=2 ;;
    "Language-and-Frameworks" )
        QUADRANT_NO=3 ;;
  esac

  case "$RING" in
    "Adopt" )
        RING_NO=0 ;;
    "Trial" )
        RING_NO=1 ;;
    "Hold" )
        RING_NO=2 ;;
    "Reduce-and-remove" )
        RING_NO=3 ;;
  esac

  case "$MOVED" in
    "UP" )
        MOVED_NO=1 ;;
    "DOWN" )
        MOVED_NO=-1 ;;
    "FALSE" )
        MOVED_NO=0 ;;
  esac

  echo "     {"
  echo "        quadrant: $QUADRANT_NO,"
  echo "        ring: $RING_NO,"
  echo "        label: \"$LABEL\","
  echo "        active: true,"
  echo "        link: \"\","
  echo "        moved: $MOVED_NO"
  echo "      },"
done < "$input"

# add the head of the js
cat radar_visualization-footer.js
