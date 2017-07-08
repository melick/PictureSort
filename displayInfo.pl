#!/usr/bin/perl

# ----- http://www.dagolden.com/index.php/1508/sorting-photos-by-timestamp-with-perl/
#
#       Lyle Melick - lyle@melick.net
#       Create date: 2017-07-07
#
my $Revision = '$WCMIXED?[$WCRANGE$]:v$WCREV$$ $WCMODS?with local mods:$';$Revision =~ s/\A\s+//;$Revision =~ s/\s+\z//;
my $BuildDate = '$WCDATE=%Y-%b-%d %I:%M:%S%p$';$BuildDate =~ s/\A\s+//;$BuildDate =~ s/\s+\z//;
#
# ----- http://search.cpan.org/~exiftool/Image-ExifTool-10.55/lib/Image/ExifTool.pod
# /usr/bin/perl /home/melick/PictureSort/displayInfo.pl

use Image::ExifTool qw(:Public);

# ---- Simple procedural usage ----

# Get hash of meta information tag names/values from an image
$info = ImageInfo('displayInfo.pl');

foreach (sort keys %$info) {
    print "$_ => $$info{$_}\n";
}