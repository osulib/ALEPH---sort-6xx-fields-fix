#!/exlibris/aleph/a22_1/product/bin/perl
#fix for Aleph20-23, intended for tab_fix, INS section
#
#It sorts Marc fields within the group of 6xx fields (six-hundred fields) by their code and indicators. This is not currently done by Aleph standad fix fix_doc_sort 
# see https://knowledge.exlibrisgroup.com/Aleph/Knowledge_Articles/Sort_Order_of_5XX%2C_6XX%2C_7XX%2C_8XX_Fields_in_catalog_record
#It needs the 6xx fields to be grouped together, so it is recommended to run it after the fix_doc_sort
#Made by Matyas F. Bajger, Moravian-Silesian Research Library in Ostrava, www.svkos.cz, 20180504
#
#Cf. instuctions on wiki @ https://github.com/matyasbajger/ALEPH---sort-6xx-fields-fix/

use strict; 
use warnings;
use utf8;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");
use POSIX qw/strftime/;
use Data::Dumper; 
use Switch;
use Env;

my $logFile=$ENV{'alephe_scratch'}."mvk_sort_6xx_fields.log";
my $bibBase='MVK01';
my $recordSysNo='';
my @fields6xx;

sub printSortedArray2Lines { 
   my @array = @{$_[0]};
   return 0 if (scalar @array == 0);
#following line would sort also by subnfield content
   #@array = sort(@array);
#sort by field core incl. indicators only
   @array = sort { substr($a,0,5) cmp substr($b,0,5) } @array;
   foreach (@array) { print "$_\n"; }
   #logIt
   open ( LOGFILE, ">>$logFile" );
   my $timestamp = strftime "%Y%m%d-%H:%M:%S", localtime;
   print LOGFILE "$timestamp - $recordSysNo record, its 6xx have been sorted.\n";
   close (LOGFILE);
   return 1;
   }

while (<>) { # read lines from BIB record, one by one, and create an array containf the record
   my $line=$_;
   $line =~ s/^\s+|\s+$//g;
   if ( $line eq '' ) {
      if (scalar @fields6xx > 0) { printSortedArray2Lines (\@fields6xx); }
      last;
      }
   if ( not ($line =~ m/^$bibBase/) ) { 
      #check, if field is 6xx. If so, the field is added to array for later sorting
      if ( $_ =~ m/^6/ ) { push (@fields6xx, $line); }
      #otherwise: if the array with 6xx is not empty, it is sorted and added to the record. All other fields are printed - ledt as they were.
      else {
         if (scalar @fields6xx > 0) {
            printSortedArray2Lines (\@fields6xx); 
            @fields6xx = ();
            }
         print "$line\n";
         } 
      }
   else {
      $recordSysNo=$line;
      }
   }
