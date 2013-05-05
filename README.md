littlestar
==========

The star has to collect balloons (full of helium, which stars need), and avoid clouds which obscure them.

The dog needs to collect bones and avoid TBD.  

Balloons may sometimes carry special bones, so when they are collected the bone drops to the ground to be collected by the dog, and then some special balloons may be tied to the ground by bones, and when the dog collects the bone the balloon is released so the star can get it (maybe those are special powerups).

Since Processing stupidly doesn't provide nearest neighbor interpolation of scaled graphics (last I checked), the images are manually scaled up to look properly pixelated with image-magick convert:

convert dog.png -filter Point -resize 400& dog_px.png
