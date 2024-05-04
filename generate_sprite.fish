#!/bin/fish
for file in assets/*.aseprite
    set slug (basename $file .aseprite)
    aseprite -b $file --save-as assets/1x/$slug.png
    aseprite -b $file --scale 2 --save-as assets/2x/$slug.png
end
