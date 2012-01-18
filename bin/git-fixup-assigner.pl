#!/usr/bin/env perl

use warnings;
use strict;

sub parse_hunk_header {
        my ($line) = @_;
        my ($o_ofs, $o_cnt, $n_ofs, $n_cnt) =
            $line =~ /^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@/;
        $o_cnt = 1 unless defined $o_cnt;
        $n_cnt = 1 unless defined $n_cnt;
        return ($o_ofs, $o_cnt, $n_ofs, $n_cnt);
}

sub find_commit {
   my ($file, $begin, $end) = @_;
   my $blame;
   open($blame, '-|', 'git', '--no-pager', 'blame', 'HEAD', "-L$begin,$end", $file) or die;
   my %candidate;
   while (<$blame>) {
      $candidate{$1} += 1 if /^([0-9a-f]+)/;
   }
   close $blame or die;
   my @sorted = sort { $candidate{$b} <=> $candidate{$a} } keys %candidate;
   if (1 < scalar @sorted) {
      print STDERR "ambiguous split $file:$begin..$end\n";
      foreach my $c (@sorted) {
         print STDERR "\t$candidate{$c}\t$c\n";
      }
   }
   return $sorted[0];
}

my $diff;
open($diff, '-|', 'git', '--no-pager', 'diff', '-U1') or die;

my %by_commit;
my @cur_hunk = ();
my $cur_commit;
my ($filename, $prefilename, $postfilename);

while (<$diff>) {
        if (m{^diff --git ./(.*) ./\1$}) {
      if (@cur_hunk) {
         push @{$by_commit{$cur_commit}{$filename}}, @cur_hunk;
         @cur_hunk = ();
      }
      $filename = $1;
                $prefilename = "./" . $1;
                $postfilename = "./" . $1;
   } elsif (m{^index}) {
      # ignore
        } elsif (m{^new file}) {
      $prefilename = '/dev/null';
        } elsif (m{^delete file}) {
      $postfilename = '/dev/null';
        } elsif (m{^--- $prefilename$}) {
        } elsif (m{^\+\+\+ $postfilename$}) {
        } elsif (m{^@@ }) {
      if (@cur_hunk) {
         push @{$by_commit{$cur_commit}{$filename}}, @cur_hunk;
         @cur_hunk = ();
      }
      push @cur_hunk, $_;
      die "I don't handle this diff" if ($prefilename ne $postfilename);
                my ($o_ofs, $o_cnt, $n_ofs, $n_cnt)
                        = parse_hunk_header($_);
                my $o_end = $o_ofs + $o_cnt - 1;
      $cur_commit = find_commit($filename, $o_ofs, $o_end);
        } elsif (m{^[-+ \\]}) {
      push @cur_hunk, $_;
   } else {
      die "unhandled diff line: '$_'";
   }
}

close $diff or die;

if (@cur_hunk) {
   push @{$by_commit{$cur_commit}{$filename}}, @cur_hunk;
   @cur_hunk = ();
}

print "#!/bin/sh\n\n";

foreach my $commit (keys %by_commit) {
   print "git apply --cached <<\\EOF\n";
   foreach my $filename (keys %{$by_commit{$commit}}) {
      print "diff --git a/$filename b/$filename\n";
      print "--- a/$filename\n";
      print "+++ b/$filename\n";
      print @{$by_commit{$commit}{$filename}};
   }
   print "EOF\n\n";
   print "git commit --fixup $commit\n\n";
}

