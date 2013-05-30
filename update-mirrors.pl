#!/usr/bin/perl -w
use warnings;
use strict;
use LWP::Simple;
use LWP;
use Date::Parse;
use Date::Format;

#
# A quick hack by Jacob Appelbaum <jacob@appelbaum.net>
# LWP suggestions by Leigh Honeywell
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
# CHANGELOG
# 20091003 Code changes to elimiate the need for a trailing slash in addresses for script runtime
# 20091004 Code changes to increase out of date tolerance to 48 hours
# 20091028 Code changes to increase timout to 30 seconds (attempting to # resolve "unknown" status')
# 20091028 Code changes to change user agent of script
# 20100807 Remove dead mirrors.

print "Creating LWP agent ($LWP::VERSION)...\n";
my $lua = LWP::UserAgent->new(
    keep_alive => 1,
    timeout => 30,
    agent => "Tor MirrorCheck Agent"
);

sub sanitize {
    my $taintedData = shift;
    my $cleanedData;
    my $whitelist = '-a-zA-Z0-9: +';

    # clean the data, return cleaned data
    $taintedData =~ s/[^$whitelist]//go;
    $cleanedData = $taintedData;

    return $cleanedData;
}

sub FetchDate {
    my $url = shift; # Base url for mirror
    my $trace = "project/trace/www-master.torproject.org"; # this file should always exist
    $url = "$url*/*$trace";

    print "Fetching possible date from: $url\n";

    my $request = new HTTP::Request GET => "$url";
    my $result = $lua->request($request);
    my $code = $result->code();
    print "Result code $code\n";

    if ($result->is_success && $code eq "200"){
       my $taint = $result->content;
       my $content = sanitize($taint);
       if ($content) {

            my $date = str2time($content);

            if ($date) {
                print "We've fetched a date $date.\n";
                return $date;
            } else {
                print "We've haven't fetched a date.\n";
                return "Unknown";
            }

        } else {
            print "Unable to fetch date, empty content returned.\n";
            return "Unknown";
        }

    } else {
       print "Our request failed, we had no result.\n";
       return "Unknown";
    }

    return "Unknown";
}

# This is the list of all known Tor mirrors
# Add new mirrors to the bottom!
my %m = (


        mirror000 => {
            adminContact => "coralcdn.org",
            orgName => "CoralCDN",
            isoCC => "INT",
            subRegion => "",
            region => "INT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Yes",
            httpWebsiteMirror => "http://www.torproject.org.nyud.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.org.nyud.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

        mirror001 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.oignon.net/",
            httpsWebsiteMirror => "https://www.oignon.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.oignon.net/dist/",
            httpsDistMirror => "https://www.oignon.net/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

       mirror003 => {
            adminContact => "citizen428 AT gmail DOT com",
            orgName => "[[:bbs:]]",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.blingblingsquad.net/",
            httpsWebsiteMirror => "https://tor.blingblingsquad.net/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.blingblingsquad.net/dist/",
            httpsDistMirror => "https://tor.blingblingsquad.net/dist/",
            rsyncDistMirror => ""
        },

	    mirror006 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.us/",
            httpsWebsiteMirror => "https://www.torproject.us/",
            rsyncWebsiteMirror => "rsync://rsync.torproject.us/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.us/dist/",
            httpsDistMirror => "https://www.torproject.us/dist/",
            rsyncDistMirror => "rsync://rsync.torproject.us/tor/dist",
            hiddenServiceMirror => ""
        },

       mirror007 => {
            adminContact => "info AT zentrum-der-gesundheit DOT de",
            orgName => "Zentrum der Gesundheit",
            isoCC => "DK",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.idnr.ws/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.idnr.ws/dist/",
            rsyncDistMirror => ""
        },

       mirror008 => {
            adminContact => "root AT amorphis DOT eu",
            orgName => "Amorphis",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.amorphis.eu/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.amorphis.eu/dist/",
            rsyncDistMirror => ""
        },
       mirror010 => {
            adminContact => "webmaster AT ccc DOT de",
            orgName => "CCC",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.ccc.de/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.ccc.de/dist/",
            rsyncDistMirror => ""
        },

       mirror013 => {
	    adminContact => "hostmaster AT zombiewerks DOT com",
            orgName => "TheOnionRouter",
            isoCC => "IS",
            subRegion => "",
            region => "Iceland",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://theonionrouter.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://theonionrouter.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => ""
        },
    mirror014 => {
        adminContact => "tormaster AT xpdm DOT us",
        orgName => "Xpdm",
        isoCC => "US",
        subRegion => "",
        region => "North America",
        ipv4 => "True",
        ipv6 => "False",
        loadBalanced => "Unknown",
        httpWebsiteMirror => "http://torproj.xpdm.us/",
        httpsWebsiteMirror => "https://torproj.xpdm.us/",
        rsyncWebsiteMirror => "",
        ftpWebsiteMirror => "",
        httpDistMirror => "http://torproj.xpdm.us/dist/",
        httpsDistMirror => "https://torproj.xpdm.us/dist/",
        rsyncDistMirror => "",
        hiddenServiceMirror => "http://h3prhz46uktgm4tt.onion/"
        },
     mirror016 => {
            adminContact => "security AT hostoffice DOT hu",
            orgName => "Unknown",
            isoCC => "HU",
            subRegion => "Hungary",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.tor.hu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.tor.hu/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },
   mirror018 => {
            adminContact => "",
            orgName => "chaos darmstadt",
            isoCC => "DE",
            subRegion => "Germany",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

	mirror019 => {
            adminContact => "webmaster AT askapache DOT com",
            orgName => "AskApache",
            isoCC => "US",
            subRegion => "California",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.askapache.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.askapache.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

	mirror020 => {
            adminContact => " mail AT benjamin-meier DOT info ",
            orgName => "beme it",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.beme-it.de/",
            httpsWebsiteMirror => "https://tor.beme-it.de/",
            rsyncWebsiteMirror => "rsync://tor.beme-it.de/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.beme-it.de/dist/",
            httpsDistMirror => "https://tor.beme-it.de/dist/",
            rsyncDistMirror => "rsync://tor.beme-it.de/tor/dist",
            hiddenServiceMirror => ""
        },

        mirror021 => {
            adminContact => "",
            orgName => "India Tor Fans",
            isoCC => "IN",
            subRegion => "",
            region => "IN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.org.in/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.org.in/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

        mirror024 => {
            adminContact => "",
            orgName => "homosu",
            isoCC => "SE",
            subRegion => "",
            region => "SE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.homosu.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.homosu.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

        mirror025 => {
            adminContact => "margus.random at mail.ee",
            orgName => "CyberSIDE",
            isoCC => "EE",
            subRegion => "",
            region => "EE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://cyberside.planet.ee/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://cyberside.net.ee/tor/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => ""
        },

        mirror028 => {
            adminContact => "",
            orgName => "NW Linux",
            isoCC => "US",
            subRegion => "WA",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.nwlinux.us/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync://nwlinux.us/tor-web",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.nwlinux.us/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "rsync://nwlinux.us/tor-dist",
            hiddenServiceMirror => "",
        },
        mirror029 => {
            adminContact => "",
            orgName => "LazyTiger",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.taiga-san.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.taiga-san.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror030 => {
            adminContact => "",
            orgName => "searchprivate",
            isoCC => "US",
            subRegion => "TX",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.searchprivate.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.searchprivate.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror031 => {
            adminContact => "",
            orgName => "cyberarmy",
            isoCC => "AT",
            subRegion => "",
            region => "AT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.cyberarmy.at/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror032 => {
            adminContact => "",
            orgName => "torproject.is",
            isoCC => "IS",
            subRegion => "",
            region => "IS",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.is/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.is/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror033 => {
            adminContact => "",
            orgName => "torservers",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torservers.net/mirrors/torproject.org/",
            httpsWebsiteMirror => "https://www.torservers.net/mirrors/torproject.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torservers.net/mirrors/torproject.org/dist/",
            httpsDistMirror => "https://www.torservers.net/mirrors/torproject.org/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "http://hbpvnydyyjbmhx6b.onion/mirrors/torproject.org/",
        },
        mirror036 => {
            adminContact => "",
            orgName => "",
            isoCC => "NL",
            subRegion => "",
            region => "NL",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "https://www.coevoet.nl/tor/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
      },
        mirror038 => {
            adminContact => "",
            orgName => "",
            isoCC => "LT",
            subRegion => "",
            region => "LT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.vesta.nu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.vesta.nu/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
      },
        mirror045 => {
            adminContact => "",
            orgName => "",
            isoCC => "TN",
            subRegion => "",
            region => "TN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.mirror.tn/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.mirror.tn/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
      },
        mirror045 => {
            adminContact => "",
            orgName => "",
            isoCC => "TN",
            subRegion => "",
            region => "TN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.antagonism.org/",
            httpsWebsiteMirror => "https://torproject.antagonism.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
      },
        mirror048 => {
            adminContact => "",
            orgName => "",
            isoCC => "AT",
            subRegion => "",
            region => "AT",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.dont-know-me.at/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.dont-know-me.at/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror049 => {
            adminContact => "IceBear",
            orgName => "myRL.net",
            isoCC => "IS",
            subRegion => "",
            region => "IS",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.myrl.net/",
            httpsWebsiteMirror => "https://tor.myrl.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.myrl.net/dist/",
            httpsDistMirror => "https://tor.myrl.net/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror050 => {
            adminContact => "",
            orgName => "borgmann.tv",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.borgmann.tv/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.borgmann.tv/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror051 => {
            adminContact => "",
            orgName => "torland",
            isoCC => "GB",
            subRegion => "",
            region => "GB",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.torland.me/torproject.org/",
            httpsWebsiteMirror => "https://mirror.torland.me/torproject.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.torland.me/torproject.org/dist/",
            httpsDistMirror => "https://mirror.torland.me/torproject.org/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror052 => {
            adminContact => "",
            orgName => "spline",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.spline.de/",
            httpsWebsiteMirror => "https://tor.spline.inf.fu-berlin.de/",
            rsyncWebsiteMirror => "rsync://ftp.spline.de/tor",
            ftpWebsiteMirror => "ftp://ftp.spline.de/pub/tor",
            httpDistMirror => "http://tor.spline.de/dist/",
            httpsDistMirror => "https://tor.spline.inf.fu-berlin.de/dist/",
            rsyncDistMirror => "rsync://ftp.spline.de/tor/dist",
            hiddenServiceMirror => "",
        },
        mirror053 => {
            adminContact => "",
            orgName => "",
            isoCC => "AT",
            subRegion => "",
            region => "AT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.ph3x.at/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.ph3x.at/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror054 => {
            adminContact => "",
            orgName => "hessmo",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.hessmo.com/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.hessmo.com/tor/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror058 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.loritsu.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.loritsu.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror060 => {
            adminContact => "",
            orgName => "",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.cryptowars.info/",
            httpsWebsiteMirror => "https://torproject.cryptowars.info/",
            rsyncWebsiteMirror => "rsync://torproject.cryptowars.info/",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.cryptowars.info/dist/",
            httpsDistMirror => "https://torproject.cryptowars.info/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror062 => {
            adminContact => "",
            orgName => "",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.dev-random.de/",
            httpsWebsiteMirror => "https://tor.dev-random.de/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.dev-random.de/dist/",
            httpsDistMirror => "https://tor.dev-random.de/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror063 => {
            adminContact => "",
            orgName => "crazyhaze.de",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.crazyhaze.de/",
            httpsWebsiteMirror => "https://tor.crazyhaze.de/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.crazyhaze.de/dist/",
            httpsDistMirror => "https://tor.crazyhaze.de/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror066 => {
            adminContact => "",
            orgName => "Lightning-bolt.net",
            isoCC => "CZ",
            subRegion => "",
            region => "CZ",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.lightning-bolt.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.lightning-bolt.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror067 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.mirrors.whitedholdings.org/",
            httpsWebsiteMirror => "https://tor.mirrors.whitedholdings.org/",
            rsyncWebsiteMirror => "rsync://mirrors.whitedholdings.org/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.mirrors.whitedholdings.org/dist/",
            httpsDistMirror => "https://tor.mirrors.whitedholdings.org/dist/",
            rsyncDistMirror => "rsync://tor.mirrors.whitedholdings.org/tor-dist",
            hiddenServiceMirror => "",
     },
        mirror069 => {
            adminContact => "",
            orgName => "",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.mirror.chekanov.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.mirror.chekanov.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror072 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.minibofh.org/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.minibofh.org/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror073 => {
            adminContact => "",
            orgName => "",
            isoCC => "UA",
            subRegion => "",
            region => "UA",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torua.reactor-xg.kiev.ua/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torua.reactor-xg.kiev.ua/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror075 => {
            adminContact => "",
            orgName => "me0w.cc",
            isoCC => "RO",
            subRegion => "",
            region => "RO",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.me0w.cc/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.me0w.cc/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror076 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.nametoday.me/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.nametoday.me/tor/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror077 => {
            adminContact => "",
            orgName => "",
            isoCC => "UK",
            subRegion => "",
            region => "UK",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.mage.me.uk/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.mage.me.uk/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror078 => {
            adminContact => "",
            orgName => "",
            isoCC => "CH",
            subRegion => "",
            region => "CH",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.pillo-srv.ch/",
            httpsWebsiteMirror => "https://torproject.pillo-srv.ch/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.pillo-srv.ch/dist/",
            httpsDistMirror => "https://torproject.pillo-srv.ch/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror079 => {
            adminContact => "",
            orgName => "",
            isoCC => "LU",
            subRegion => "",
            region => "LU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.adamas.ai/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.adamas.ai/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror080 => {
            adminContact => "",
            orgName => "",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.c3l.lu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.c3l.lu/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror081 => {
            adminContact => "",
            orgName => "",
            isoCC => "EE",
            subRegion => "",
            region => "EE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.li/",
            httpsWebsiteMirror => "https://tor.li/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.li/dist/",
            httpsDistMirror => "https://tor.li/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror082 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.nametoday.me/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.nametoday.me/tor/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror085 => {
            adminContact => "",
            orgName => "Soviet Anonymous",
            isoCC => "RU",
            subRegion => "",
            region => "RU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://creep.im/tor",
            httpsWebsiteMirror => "https://creep.im/tor",
            rsyncWebsiteMirror => "rsync://creep.im/tor",
            ftpWebsiteMirror => "ftp://creep.im/mirrors/tor",
            httpDistMirror => "http://creep.im/tor/dist/",
            httpsDistMirror => "https://creep.im/tor/dist/",
            rsyncDistMirror => "rsync://creep.im/tor-dist",
            hiddenServiceMirror => "",
    },
        mirror086 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://199.175.55.215/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://199.175.55.215/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror087 => {
            adminContact => "",
            orgName => "",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.linuxlounge.net/",
            httpsWebsiteMirror => "https://tor.linuxlounge.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.linuxlounge.net/dist/",
            httpsDistMirror => "https://tor.linuxlounge.net/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror088 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirrors.go-part.com/tor/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "rsync://mirrors.go-part.com/tor/dist/",
            hiddenServiceMirror => "",
    },
        mirror089 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.netgull.com/torproject/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror090 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.guilhem.org/",
            httpsWebsiteMirror => "https://torproject.guilhem.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.guilhem.org/dist/",
            httpsDistMirror => "https://torproject.guilhem.org/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    },
        mirror091 => {
            adminContact => "",
            orgName => "",
            isoCC => "MX",
            subRegion => "",
            region => "MX",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://fbnaia.homelinux.net/torproject/",
            httpsWebsiteMirror => "https://fbnaia.homelinux.net/torproject/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://fbnaia.homelinux.net/torproject/dist/",
            httpsDistMirror => "https://fbnaia.homelinux.net/torproject//dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
    }
);

my $count = values %m;
print "We have a total of $count mirrors\n";
print "Fetching the last updated date for each mirror.\n";

my $tortime;
$tortime = FetchDate("https://www.torproject.org/");
# Adjust offical Tor time by out-of-date offset: number of days * seconds per day
$tortime -= 1 * 172800;
print "The official time for Tor is $tortime. \n";

foreach my $server ( keys %m ) {

    print "Attempting to fetch from $m{$server}{'orgName'}\n";

    if ($m{$server}{'httpWebsiteMirror'}) {
        print "Attempt to fetch via HTTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpWebsiteMirror'}");
    } elsif ($m{$server}{'httpsWebsiteMirror'}) {
        print "Attempt to fetch via HTTPS.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpsWebsiteMirror'}");
    } elsif ($m{$server}{'ftpWebsiteMirror'}) {
        print "Attempt to fetch via FTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'ftpWebsiteMirror'}");
    } else {
        print "We were unable to fetch or store anything. We still have the following: $m{$server}{'updateDate'}\n";
    }

    print "We fetched and stored the following: $m{$server}{'updateDate'}\n";

 }


print "We sorted the following mirrors by their date of last update: \n";
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     print "\n";
     print "Mirror $m{$server}{'orgName'}: \n";

     foreach my $attrib ( sort keys %{$m{$server}} ) {
        print "$attrib = $m{$server}{$attrib}";
        print "\n";
     };
}

my $outFile = "include/mirrors-table.wmi";
my $html;
open(OUT, "> $outFile") or die "Can't open $outFile: $!";

# Here's where we open a file and print some wml include goodness
# This is storted from last known recent update to unknown update times
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     my $time;
     if ( "$m{$server}{'updateDate'}" ne "Unknown") {
	  if ( $m{$server}{'updateDate'} > $tortime ) {
	    $time = "Up to date";
	  } else { $time = "DO NOT USE. Out of date."; }
     } else { $time = "Unknown"; }
print OUT <<"END";
     \n<tr>\n
         <td>$m{$server}{'isoCC'}</td>\n
         <td>$m{$server}{'orgName'}</td>\n
         <td>$time</td>\n
END

     my %prettyNames = (
                        httpWebsiteMirror => "http",
                        httpsWebsiteMirror => "https",
                        ftpWebsiteMirror => "ftp",
                        rsyncWebsiteMirror => "rsync",
                        httpDistMirror => "http",
                        httpsDistMirror => "https",
                        rsyncDistMirror => "rsync", );

     foreach my $precious ( sort keys %prettyNames )
     {
        if ($m{$server}{"$precious"}) {
            print OUT "    <td><a href=\"" . $m{$server}{$precious} . "\">" .
                      "$prettyNames{$precious}</a></td>\n";
        } else { print OUT "    <td> - </td>\n"; }
     }

     print OUT "</tr>\n";
}

close(OUT);
