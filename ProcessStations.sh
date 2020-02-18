#!/bin/bash

#part 1 identify and separate out stations with elevations greater that 200 ft

if [ -d "./HigherElevation" ]
then 
	echo "Directory HIgherElevation already exists"
else
	mkdir ./HigherElevation
fi

for file in ./StationData/*
do 
	b=`basename "$file"`
	if
	grep 'Altitude: [>200]' $file
	then cp ./StationData/$b ./HigherElevation/$b
	fi
done

#part 2: Plot the location of all stations, indicating higher elevation stations
awk '/Longitude/ {print -1 * $NF}' StationData/Station_*.txt > Long.list
awk '/Latitude/ {print -1 * $NF}' StationData/Station_*.txt > Lat.list
awk '/Longitude/ {print -1 * $NF}' HigherElevation/Station_*.txt > LongHE.list
awk '/Latitude/ {print -1 * $NF}' HigherElevation/Station_*.txt > LatHE.list
paste Long.list Lat.list > AllStation.xy
paste LongHE.list LatHE.list > HEStation.xy


module load  gmt
gmt pscoast -JU16/4i -R-93/-86/36/43 -B2f0.5 -Ia/blue -Na/orange -P -K -V > SoilMoistureStations.ps
gmt psxy AllStation.xy -J -R -Sc0.15 -Gblack -K -O -V >> SoilMoistureStations.ps
gmt psxy HEStation.xy -J -R -Sc0.10 -Gred -O -V >> SoilMoistureStations.ps

#gv SoilMoistureStations.ps & 

#part 3: Convert figure into other image formats

ps2epsi SoilMoistureStations.ps [ SoilMoistureStations.epsi ]

convert -density 150x150  SoilMoistureStations.epsi SoilMoistureStations.tiff 


