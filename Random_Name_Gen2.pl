#!C:\perl\bin\perl.exe

# Based on Random_dice.pl
# Choose how man syllables the name should have
# Randomization of letters and vowels are combined as each syllable builds.
# Resulting name is saved in file if yes is chosen, otherwise it is discarded.

sub Help {
if ((($ARGV[0] =~ /help|[?]|[a-z]+/i) or ($ARGV[1] =~ /help|[?]|[a-z]+/i)) or ($ARGV[2]) or ($help)){
	print "\nUsage is: Random_name.exe <Increase chance of compound vowels> <increase chance of compound consonants>\n";
	print "\t\tWhere first and second arguments are numbers between 0 and 10.\n";
	print "\t\tThe larger the number the more occurrences of compounds you will see.\n";
	print "\t\tPlay with these values to get the desired results.\n\n";
	print "\nThe syllable count is a minimum.  meaning:\n\tthe occurrence of leading and trailing vowels is randomized.\n";
	print "\tLow syllable counts seem to produce better results and counts above 5 seem ridiculous.\n\n";

	exit unless $help;
}
}
$syllables_hold = 2;
$help=0;
&Help;
print "\nCopywrite Kenton Erb June 2007.\n\n";
print "This program concatinates all saved names to the file Random_names.txt.\n";
print "Type help for more info.\n";
print "Enjoy!\n\n";
sleep 5;


use Math::Random;
&Settings;

sub Settings {


if($help){
	&Help;
	$help=0;
	print "Do you want to change your settings? [y|n]: ";
	chomp($answer = <STDIN>);
	if($answer =~ /y/i){
		print "Enter a number between 0 and 10 to change the probability of compound vowels: ";
		chomp($ARGV[0] = <STDIN>);
		print "\nEnter a number between 0 and 10 to change the probability of compound consonants: ";
		chomp($ARGV[1] = <STDIN>);
		print "\n";
		print "\nEnter the number of syllables you desire your name to have: [$syllables] ";
		$syllables = <STDIN>;  # Set how many syllables
		chomp($syllables);

		# Remove garbage
		$syllables =~ s/[^0-9]//g;

		# Look for rediculas numbers
		if ($syllables >= 16) {
			print "We don't have the time or energy to learn to pronounce a name like that. Pick a more reasonable number of syllables.\n";
			goto STARTOVER;
			}


		# If nothing (or garbage) was passed to STDIN use last or default value
		unless($syllables){$syllables = $syllables_hold}
		$syllables_hold = $syllables;
		system("cls");
	}else{
	system("cls");
	#just keep going!
	}
}

if(($ARGV[0] > 10) or ($ARGV[1] > 10)){
	print "There are arguments greater than 10.\n....These numbers will be treated as 10.\n";
}
if($ARGV[0] > 11){
	$ARGV[0] = 10;
}

if($ARGV[1] >=10){
	$ARGV[1] = 30;
}elsif($ARGV[1] >=9){
	$ARGV[1] = 20;
}elsif($ARGV[1] >=7){
	$ARGV[1] = 15;
}elsif($ARGV[1] >=5){
	$ARGV[1] = 10;
}elsif($ARGV[1] >=3){
	$ARGV[1] = 5 ;
}elsif($ARGV[1] <= 0){
	$ARGV[1] = 0 ;
}

#print "$ARGV[0] and $ARGV[1]\n";
# Increase this number to increase the likelihood that a compound consonant is used
$overcount=4 + $ARGV[1]; # gives a 20% chance that a compound consonant is used
# Increase this number to increase the likelyhood that a compound vowel is used.
$overcount2=3 + $ARGV[0]; # gives a 45/65 chance for compound vowels

} # end of Settings

#
# vowels
@vowels = qw{a e i o u};
@cvowels = qw{ae ai ao au ay ea ei eo eu y ey ia ie io iu iy oa oe oi ou oy ua ue ui uo iou ee oo};
@simp_conts = qw{b c d f g h j k l m n p r s t v w x y z};

$vowel_count=(@vowels);# equal to the number of vowels;
$cvowel_count=(@cvowels);# equal to the number of cvowels;
$simp_count=(@simp_conts);#equal to the number of consonants
$overcount += $simp_count; # our number for randomizing the use of compound consonants
$overcount2 += $vowel_count;
#print "my vowel count is $vowel_count\n";
#print "my consonant count is $consonant_count\n";

STARTOVER:

$syllables=2;
$syllables_hold=2;

AGAIN:
undef @myname;
$first=1;



&Add_vowel;

# Roll die for count and collect in array @x
for ($x = 1; $x <= $syllables ; $x++){

		&Add_cons;
		&Add_vowel;
}


#******* Print to file **********

KEEP:
system("cls") unless $first;
print "Do you want to keep the name: ";
print "'",@myname,"' ";
$keep = <STDIN>;
chomp($keep);
#print "$overcount\n";
#print "$overcount2\n";


if(($keep eq "y") or ($keep eq "Y")){
	open(LOG, ">>Random_names.txt") or die "Can't open file: $!\n";
	print LOG @myname,"\n";
	close(LOG);
	$add_vowel = 100;
	goto AGAIN;
}elsif(($keep eq "n") or ($keep eq "N")){
	$add_vowel = 100;
	goto AGAIN;
}elsif($keep =~ /exit/i){
	print "\nGood bye!\n";
	sleep 3;
	exit;
}elsif($keep =~ /help/i){
	$help=1;
	&Settings;
	goto KEEP;
}elsif($keep !~ /^[nNyY]$/){
	print "Type either Y for Yes or N for No as your choice.\n";
	sleep 3;
	goto KEEP;
}else{
print "we got here and something is not right!\n";
sleep 10;
$add_vowel = 100; #reset for randomization

goto AGAIN;
}

#******* End of Print to file *************



#******* Sub Routines ********
sub Add_cons {

	if($x != $syllables){
		$roll = int(rand $overcount);

		if($roll <= $simp_count){ # equal is used because we have not yet deleted 1 from $roll
			# This is a true simple consonant
			push @myname, $simp_conts[$roll -1]; # print first part of this syllable
		}else{	# else we use a compound consonant

		# here we randomize the building of a compound consonant
		for ($i=1; $i <= 2; $i++){
			$roll = int(rand $simp_count) - 1; # we must reroll a random number
			push @myname, $simp_conts[$roll]; # print first part of this syllable
			}
		}
	}else{	# we always want to use a simple consonant on the last syllable.
		$roll = int(rand $simp_count) - 1; # pick from our array of consonants
		push @myname, $simp_conts[$roll]; # print first part of this syllable
	}

}

sub Add_vowel {

	$add_vowel = 100;  # ensures a vowel is printed except for the last syllable.

	if(($x == $syllables) or ($first)){
		$first=0;
		$add_vowel=int(rand 100);
	}

	$roll = int(rand $overcount2) ;

	if($add_vowel >50){
		if ($roll <= $vowel_count){
			push @myname, $vowels[$roll -1]; # print second part of this syllable
		}else{  #we reroll for this
			$roll = int(rand $cvowel_count) - 1; # pick from our array of cvowels
			push @myname, $cvowels[$roll]; # print second part of this syllable
		}
	}
}

#******* End of Sub Routines ********
