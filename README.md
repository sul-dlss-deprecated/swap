## Stanford Web Archiving Portal (SWAP)

[![Build Status](https://travis-ci.org/sul-dlss/swap.svg?branch=master)](https://travis-ci.org/sul-dlss/swap)
[![Coverage Status](https://coveralls.io/repos/github/sul-dlss/swap/badge.svg)](https://coveralls.io/github/sul-dlss/swap)
[![Latest GitHub tagged version](https://badge.fury.io/gh/sul-dlss%swap.svg)](https://badge.fury.io/gh/sul-dlss%2Fswap)

Java application to query and access archived web material. This is the code for the Stanford Web Archiving Portal (SWAP).

Stanford University Libraries overlay of [iipc/openwayback](https://github.com/iipc/openwayback).  (See IIPC wiki [Creating a WAR overlay] https://github.com/iipc/openwayback/wiki/Creating-a-WAR-overlay.)  There are a small number of local modifications to the upstream code:

Rough list of Stanford changes (see also sul-dlss/openwayback):

- earliest year of 1991, not 1996
- add featured sites to home page
- add toolbar (or make it interactive?)
  - interactive
  - hidden by default
- graph changes
  - remove nomonth
- https instead of http for link
- add Google Analytics
- add email for feedback
- escape HTML exception to avoid security threat
- add HTTP headers and DOCType for IE rendering
- month and day in URL to 2 digits (date format changed to allow for GUI goodness)

- style / user interaction
  - colors
  - logos
  - change name (SWAP instead of Wayback)
  - change Wayback Info link
  - bubble calendar?
  - add cookie support for Show-Hide overlay for all the links
  - next/prev remembers user prefs

devopsy:
- run continous integration for OUR build
- get code coverage for OUR build
- update README
- CONTRIBUTING doc


For more documentation on this code, see [the OpenWayback wiki](https://github.com/iipc/openwayback/wiki).

## Deployment

Deployment is via deployment artifacts created at [jenkinsqa](https://jenkinsqa.stanford.edu/job/was-swap/).  These artifacts are deployed to:
- to sul-wayback-xxx VMs by puppet
- was-robot VMs as part of capistrano [deployment tasks in `was_robot_suite`](https://github.com/sul-dlss/was_robot_suite/blob/master/config/deploy.rb#L47-L54). The deployed `was_robot_suite` houses the deployed files in the `jar/openwayback` directory.

## Build
```
mvn install
```

## Run Tests
```
mvn test -B
```
