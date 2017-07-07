#!/usr/bin/env perl
# ----- http://www.dagolden.com/index.php/1508/sorting-photos-by-timestamp-with-perl/

use 5.010;
use strict;
use warnings;
use autodie;
use Digest::MD5 'md5_hex';
use Image::ExifTool 'ImageInfo';
use Path::Class;
 
for my $f ( dir()->children ) {
  next if $f->is_dir;
  my $exif = Image::ExifTool->new;
  $exif->ExtractInfo($f->stringify);
  my $date = $exif->GetValue('DateTimeOriginal', 'PrintConv');
  next unless defined $date;
  $date =~ tr[ :][T-];
  my $digest = md5_hex($f->slurp);
  $digest = substr($digest,0,7);
  my $new_name = "$date-$digest.jpg";
  unless ( $f->basename eq $new_name ) {
    rename $f => $new_name;
    say "renamed $f => $new_name";
  }
}