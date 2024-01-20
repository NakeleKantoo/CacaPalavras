#!/bin/bash

zip -r "temp.zip" *
mv temp.zip $RANDOM.love
kdeconnect-cli --share *.love -n LeonnaCel
sleep 2
rm *.love
