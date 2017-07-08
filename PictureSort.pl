#!/usr/bin/perl

# ----- http://www.dagolden.com/index.php/1508/sorting-photos-by-timestamp-with-perl/
#
#       Lyle Melick - lyle@melick.net
#       Create date: 2017-07-07
#
my $Revision = '$WCMIXED?[$WCRANGE$]:v$WCREV$$ $WCMODS?with local mods:$';$Revision =~ s/\A\s+//;$Revision =~ s/\s+\z//;
my $BuildDate = '$WCDATE=%Y-%b-%d %I:%M:%S%p$';$BuildDate =~ s/\A\s+//;$BuildDate =~ s/\s+\z//;
#
# /usr/bin/perl /home/melick/PictureSort/PictureSort.pl --inputDir input --verbose


my $which_db = 'PictureSort';

use 5.010;

use strict;
#use warnings;
use autodie;


# ----- handle input parameters
use Getopt::Long;
my $InputDir;
my $debug;
my $verbose;
GetOptions ("inputDir=s" => \$InputDir, # string
            "debug"      => \$debug,    # flag
            "verbose"    => \$verbose ) # flag
or die("Error in command line arguments\n");
printf "i [%s], d [%s], v [%s]\n", $InputDir, $debug, $verbose if $debug;

# ----- Date & Time setups
use DateTime;
my $TodaysDate = DateTime->now;
my $Now = join(' ', $TodaysDate->ymd, $TodaysDate->hms);
printf "[%s] [%s : %s]\n", $Now, $TodaysDate->ymd, $TodaysDate->hms if $verbose;

my $julian_day = $TodaysDate->day_of_year();
my $month = $TodaysDate->month(); my $day = $TodaysDate->day(); my $year = $TodaysDate->year(); my $weekday = $TodaysDate->day_name();
printf "j:%s, m:%s, d:%s, y:%s, w:%s\n", $julian_day, $month,$day,$year,$weekday if $verbose;


# ----- database handle
#use Melick::dbLib qw(connection ckObject $SQL_Database $SQL_Schema);
#my $dbh = &connection($which_db);
#printf "dbh: [%s]\n", $dbh if $verbose;


# ----- Misc Variable Setups
use File::Basename;
my($ScriptName, $DIR, $suffix) = fileparse($0);
printf "ScriptName [%s], DIR [%s] suffix [%s]\n", $ScriptName, $DIR, $suffix if $verbose;



# ----- let's get bizzy
use File::Find;
find(\&sort_picture, $InputDir);


# ----- put your toys away little Johnny
#$dbh->disconnect or warn "Error disconnecting: $DBI::errstr\n";


# ----- HC SVNT DRACONES -----
=begin GHOSTCODE
=end GHOSTCODE
=cut

sub sort_picture {

    next if $File::Find::dir eq $DIR;

    # ----- modules in the subroutine
    use Digest::MD5 'md5_hex';
    use File::Copy qw(copy);
    use File::Path qw(make_path);
    use Image::ExifTool 'ImageInfo';
    use Path::Class;

    # ----- file name including path
    printf "FFd:%s:\n", $File::Find::dir if $verbose;
    printf "FFd:%s:\n", $File::Find::dir if -d;

    # ----- file name including path
    printf "FFn:%s:\n", $File::Find::name if $verbose;
    printf "FFn:%s:\n", $File::Find::name if !(-d);

    # ----- file name
    my $file = $_;
    printf "f:%s:\n", $file if $verbose;


    # ----- pull out the exif info
    my $exif = Image::ExifTool->new;
    $exif->ExtractInfo($File::Find::name);


    # ----- get the date [ DateTimeOriginal | DateAcquired ]
    my $date = $exif->GetValue('DateTimeOriginal', 'PrintConv');
    if (defined $date) {
        printf "pulled date from DateTimeOriginal.\n" if $verbose;
    } else {
        # ----- try again with DateAcquired
        $date = $exif->GetValue('DateAcquired', 'PrintConv');
        if (defined $date) {
            printf "pulled date from DateAcquired.\n" if $verbose;
        }
    }
    next unless defined $date;  # -----skip file if DateTimeOriginal is not in the file (skips non-image files as well)
    $date =~ tr[ :][T-];

    # split off just the date for the subdir name
    my $subdir = substr($date,0,10);
    printf "subdir: [%s]\n", $subdir if $verbose;


    # ----- get the MD5 hash
    my $digest = md5_hex($File::Find::name);
    $digest = substr($digest,0,7);


    # ----- build new file name
    my $new_name = "$DIR$subdir\/$date-$digest.jpg";
    my $new_dir  = "$DIR$subdir";


    # ----- create a new subdirectory for the date if necessary
    my @created = make_path($new_dir, {
      verbose => 1,
      mode => 0700,
    });


    # ----- rename the file.  Caution - the sharpest edge is here...
    unless ( $File::Find::name eq $new_name ) {
        copy $File::Find::name => $new_name;
        say "copied $File::Find::name => $new_name";
    }


}
