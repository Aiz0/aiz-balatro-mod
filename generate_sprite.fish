#!/bin/fish
set script_dir (status dirname)
set atlas_dir $script_dir/assets/2x
set tmp_dir /tmp/balatro-textures
set texture_dir $script_dir/site/src/assets

mkdir $tmp_dir
# make 2x pngs from aseprite files
for file in $script_dir/assets/*.aseprite
    set png_file (basename $file .aseprite).png
    aseprite -b $file --scale 2 --save-as $tmp_dir/$png_file
end
set textures $tmp_dir/*.png
set jokers (string match -r -e 'j_\d\d?' $textures)
set jokers_soul (string match -r -e 'j_s_\d\d?' $textures)
# create the 2x atlases
montage $jokers -tile 6x4 -geometry 100%x100% -background none $atlas_dir/jokers.png
montage $jokers_soul -tile 3x2 -geometry 100%x100% -background none $atlas_dir/jokers_soul.png
# create the 1x atlases
for file in $atlas_dir/*.png
    set filename (basename $file)
    magick $file -scale 50%x50% $script_dir/assets/1x/$filename
end

for file in $textures
    set new_filename (string replace -r '[\d.]+_' '' (basename $file))
    mv $file $texture_dir/$new_filename
end
