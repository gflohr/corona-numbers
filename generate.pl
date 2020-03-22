#! /usr/bin/env perl

use strict;

use File::Basename qw(dirname);
use File::Path qw(make_path);
use Text::CSV;
use YAML::XS;

sub read_data;
sub read_data_file;
sub is_leap_year;
sub write_country;
sub write_province;
sub write_file;

my $lingua = 'en';
my @linguas = qw(de);
my $wd = dirname __FILE__;
my $outdir = "$wd/files";

my @types = qw(confirmed deaths recovered);

my %countries;
my %data = map { $_ => read_data_file $_} @types;
foreach my $type (keys %data) {
	foreach my $country (keys %{$data{$type}}) {
		foreach my $province (keys %{$data{$type}->{$country}}) {
			$countries{$country}->{$province} = $data{$type}->{$country}->{$province};
		}
	}
}

foreach my $country (keys %countries) {
	write_country $country, $countries{$country};
}

sub read_data_file {
	my ($type) = @_;

	my $filename = "$wd/$type.csv";

	my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
	open my $fh, '<:encoding(utf8)', $filename or die "filename: $!";
	my $first_row = $csv->getline($fh);
	die "$filename: huh???" if $first_row->[0] ne 'Province/State';
	die "$filename: huh???" if $first_row->[1] ne 'Country/Region';
	die "$filename: huh???" if $first_row->[2] ne 'Lat';
	die "$filename: huh???" if $first_row->[3] ne 'Long';

	my @dates;

	for (my $i = 4; $i < @{$first_row}; ++$i) {
		die "$filename: first_row[$i]: $first_row->[$i]"
		    if $first_row->[$i] !~ m{^([1-9][0-9]*)/([1-9][0-9]*)/([1-9][0-9]*)$};
		push @dates, { d => $1, m => $2, y => $3 + 2000 };
	}

	my %countries;
	while (my $row = $csv->getline ($fh)) {
		my ($province, $country) = @$row;
		$province = '_total' if !length $province;

		my @data;
		for (my $i = 4; $i < @{$first_row}; ++$i) {
			push @data, $row->[$i];
		}
		$countries{$country}->{$province} = \@data;
	}

	close $fh;

	return \%countries;
}

sub is_leap_year {
	my ($year) = @_;

	return 0 == $year % 4 and 0 != $year % 100 or 0 == $year % 400;
}

sub write_country {
	my ($country, $data) = @_;

	foreach my $province (keys %$data) {
		write_province $country, $province, $data->{$province};
	}
}

sub write_province {
	my ($country, $province, $data) = @_;

	my ($fcountry, $fprovince) = map { s/[^_a-z]/-/g; $_ } map { lc $_ } ($country, $province);

	my $outbase = "$outdir/$lingua/$fcountry";
	$outbase .= "/$fprovince" if $province ne '_total';

	my %stash = (
		title => $country,
	);
	$stash{province} = $province if $province ne '_total';

	my $yaml = YAML::XS::Dump(\%stash) . "---\n";

	my $md_file = "$outbase.md";

	write_file $md_file, $yaml;
}

sub write_file {
	my ($path, $data) = @_;

	my $dir = dirname $path;
	make_path $dir if !-e $dir;

	open my $fh, '>:encoding(utf8)', $path
		or die "cannot open '$path' for writing: $!";
	$fh->print($data) or die "cannot write '$path': $!";
	$fh->close or die "cannot close '$path': $!";
	
	return 1;
}