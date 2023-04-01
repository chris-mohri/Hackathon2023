# SteelHacks2023
Brendon Lee and Christopher Mohri

##SpotHole
This IOS app prototype seeks to minimize the number of pothole accidents by providing an easy-to-use, hands-free application that displays and follows the user's location on the map, automatically detects the rumble caused by driving over a pothole, logs the latitude and longitude of the user's current location, and places a marker on the map to warn future drivers of the recorded pothole. 

##The Idea

As you drive, the vehicle will experience natural vibrations that should remain relatively constant when driving on even roads, which can be tracked by any IOS device's built-in seismometer. This seismometer should then be able to detect any irregularity in the average vibration intensity, lending to the idea that the vehicle had driven over a pothole. In this prototype, the vibration detection algorithm was substituded by the shake-gesture due to XCode Simulator limitations. As a proof of concept, the prototype successfully tracked the user's location, detected simulated shaking, and placed a marker on the map in real-time. 

![Screenshot](SpotHole_example.png)
