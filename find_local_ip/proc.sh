#!/bin/sh

ip=$(ifconfig | grep inet | egrep -v "inet6|127.0.0.1" | awk '{print $2}')

echo "
<?xml version=\"1.0\"?>
<items>
  <item uid=\"translation\" arg=\"$ip\">
      <title>\"$ip\"</title>
      <icon>$ICON_WEB</icon>
      <subtitle>\"$ip\"</subtitle>
   </item>
</items>"
