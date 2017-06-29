#!c:/perl/bin/perl

use Math::Random();

$testing = 0;

print "\nCopywrite June 2007 Kenton Erb\n\n";
print "Just enter the desired numbers and go.\n";
print "Type exit to quit.\n\n";
print "For fun type a very large number.\n";


STARTOVER:

$die_hold=6;
$count_hold=3;

AGAIN:

print "\nEnter Die Face Count: [$die_hold] ";
$die = <STDIN>;   # Set how many sides to the die
if($die =~ /exit/i){exit}
print "\nEnter the number of die to roll: [$count_hold] ";
$count = <STDIN>; # Set how many die to roll
print "\n";
if($count =~ /exit/i){exit}


# RemoVe garbage
$die =~ s/[^0-9]//g;
$count =~ s/[^0-9]//g;

# Look for rediculas numbers
unless($testing){
if (($die >= 1000000) and ($die <= 1000000000000)) { print "We don't have enough time to wait for that one. Pick a more reasonable number.\n"; goto STARTOVER}
elsif ($die >= 1000000000001) {print "This computer (and you for that matter) would be dust before \
it could calculate that one!\nPick a more reasonable number.\n"; goto STARTOVER}
if (($count >= 1000000001) and ($count <= 1000000000000)) { print "We don't have enough time to wait for that one. Pick a more reasonable number.\n"; goto AGAIN}
elsif ($count >= 1000000000001) {print "This computer (and you for that matter) would be dust before \
it could calculate that one!\nPick a more reasonable number.\n"; goto AGAIN}
}

# If nothing (or garbage) was passed to STDIN use last or default Value
unless($die){$die = $die_hold}
unless($count){$count = $count_hold}

$die = $die * 1;
$count = $count * 1;

$die_hold = $die; # get rid of leading zeros
$count_hold = $count;  # get rid of leading zeros
# Roll die for count and collect in array @x
for ($x = 1; $x <= $count ; $x++){
	$roll = int(rand $die) + 1; # $roll is now an integer between 1 and $die
	$x[$roll] += 1; # collect results in array @x
	$total += $roll;  # Collect a total
}
system("cls");
print "\nRoll = D$die X $count.         Total = $total.\n";
print "*" x 40,"\n" ;



for($x =1; $x <= $die; $x++) {
	print "\t$x","s x $x[$x]","\n" if($x[$x]) ;
}
print "*" x 40,"\n" ;
$total=0;
undef @x;

goto AGAIN;
