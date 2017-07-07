# ----- http://search.cpan.org/~exiftool/Image-ExifTool-10.55/lib/Image/ExifTool.pod

use Image::ExifTool qw(:Public);

# ---- Simple procedural usage ----

# Get hash of meta information tag names/values from an image
$info = ImageInfo('P20.jpg');

foreach (sort keys %$info) {
    print "$_ => $$info{$_}\n";
}