#! /usr/bin/env perl

use strict;

use File::Basename qw(dirname);
use File::Path qw(make_path);
use Text::CSV;
use YAML::XS;
use POSIX qw(mktime);

sub read_data;
sub read_data_file;
sub write_country;
sub write_province;
sub write_file;
sub fill_world;
sub get_date_for_day_x;
sub compute_dates;

my $lingua = 'en';
my @linguas = qw(de);
my $wd = dirname __FILE__;
my $outdir = $wd;

my @types = qw(confirmed deaths);
my $start = mktime 0, 0, 12, 22, 0, 2020 - 1900;

my %countries;
my %data = map { $_ => read_data_file $_} @types;

foreach my $type (keys %data) {
	foreach my $country (keys %{$data{$type}}) {
		foreach my $province (keys %{$data{$type}->{$country}}) {
			$countries{$country}->{$province}->{$type} = $data{$type}->{$country}->{$province};
		}
	}
}

fill_world \%countries;
my @dates = compute_dates \%countries;

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
		if ($i == 4) {
			my $date = $first_row->[4];
			die "$filename does not start at 1/22/20" if $date ne '1/22/20';
		}
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

	foreach my $country (keys %countries) {
		if (!exists $countries{$country}->{_total}) {
			my @data;
			foreach my $province (keys %{$countries{$country}}) {
				my $province_data = $countries{$country}->{$province};
				for (my $i; $i < @$province_data; ++$i) {
					$data[$i] += $province_data->[$i];
				}
			}
			$countries{$country}->{_total} = \@data;
		}
	}

	close $fh;

	return \%countries;
}

sub fill_world {
	my ($countries) = @_;

	my %world;

	foreach my $country (keys %{$countries}) {
		my $types = $countries->{$country}->{_total};
		foreach my $type (keys %$types) {
			$world{_total}->{$type} ||= [];

			my $data = $countries->{$country}->{_total}->{$type};
			for (my $i = 0; $i < @{$data}; ++$i) {
				$world{_total}->{$type}->[$i] += $data->[$i]
			}
		}
	}

	$countries->{world} = \%world;

	return 1;
}

sub compute_dates {
	my ($countries) = @_;

	my $data = $countries->{world}->{_total}->{confirmed};
	my @dates;
	for (my $day = 0; $day < @{$data}; ++$day) {
		push @dates, get_date_for_day_x $day;
	}

	return @dates;
}

sub write_country {
	my ($country, $data) = @_;

	foreach my $province (keys %$data) {
		write_province $country, $province, $data->{$province};
	}
}

sub write_province {
	my ($country, $province, $data) = @_;

	my ($fcountry, $fprovince) =
		map { s/[^_a-z]+/-/g; $_ }
		map { lc $_ }
		($country, $province);

	my $outbase = "$outdir/$lingua/$fcountry";
	$outbase .= "/$fprovince" if $province ne '_total';

	my %stash = (
		title => $country,
	);
	$stash{province} = $province if $province ne '_total';

	my @data = map { { timestamp => $_ } } @dates;
	my @types = keys %{$data};
	for (my $i = 0; $i < @data; ++$i) {
		foreach my $type (@types) {
			$data[$i]->{$type} = $data->{$type}->[$i];
		}
	}

	my $confirmed = 0;
	foreach my $set (@data) {
		$set->{new} = $set->{confirmed} - $confirmed;
		$confirmed = $set->{confirmed};
	}
	$stash{data} = \@data;

	my $yaml = YAML::XS::Dump(\%stash) . "---\n";

	my $md_file = "$outbase.md";
	write_file $md_file, $yaml;

	my $master = "/$lingua/$fcountry";
	$master .= "/$fprovince" if $province ne '_total';
	$master .= '.md';
	foreach my $other_lingua (@linguas) {
		$md_file = "$outdir/$other_lingua/$fcountry";
		$md_file .= "/$fprovince" if $province ne '_total';
		$md_file .= '.md';
		$yaml = <<"EOF";
---
master: $master
---
EOF
		write_file $md_file, $yaml;
	}
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

sub get_date_for_day_x {
	my ($x) = @_;

	return $start + $x * 24 * 60 * 60;
}