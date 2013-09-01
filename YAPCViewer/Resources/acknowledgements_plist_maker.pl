#!perl
use strict;
use warnings;
use FindBin;

my $input = shift || "$FindBin::Bin/Acknowledgement.txt";
my $output = "$FindBin::Bin/Settings.bundle/Acknowledgements.plist";

open my $rfh, '<', $input or die "cannot open $input: $!";
my $license = do { local $/; <$rfh> };
close $rfh;

my $template = do { local $/; <DATA> };

my $plist = sprintf($template, $license);

open my $wfh, '>', $output or die "cannot open $output: $!";
print {$wfh} $plist;
close $wfh;

=head1 NAME

acknowledgements_plist_maker.pl - create License on Settings.bundle

=head1 SYNOPSIS

  perl acknowledgements_plist_maker.pl

=head1 SEE ALSO

http://stackoverflow.com/questions/6428353/best-way-to-add-license-section-to-ios-settings-bundle

=head1 COPYRIGHT

Copyright 2013 monmon.

=head1 AUTHOR

monmon

=cut

__DATA__
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>StringsTable</key>
        <string>Acknowledgements</string>
        <key>PreferenceSpecifiers</key>
        <array>
                <dict>
                        <key>Type</key>
                        <string>PSGroupSpecifier</string>
                        <key>Title</key>
                        <string>%s</string>
                </dict>
        </array>
</dict>
</plist>
