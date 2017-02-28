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
mvn clean install
```

## Run Tests
```
mvn test -B
```

## Development

FIXME: Top level directory ... blah blah


Subdirectories:

### upstream-wayback-core

In order to create the final swap war file to deploy to a remote VM, we must ensure the java class loader won't have to choose between two versions of a class.

We do this by REMOVING from the upstream IIPC wayback-core jar any class present in swap wayback-core code.

```
cd upstream-wayback-core
mvn clean install
```

creates a jar file `upstream-wayback-core/target/openwayback-core-modified-[version].jar` identical to the IIPC openwayback-core jar, but without the Stanford modified classes in wayback-core.  It also installs said jar in the local maven repository (in `~/.m2/repository`) so it can be used by other `modules`, such as `wayback-core`.

#### When making changes to wayback-core, be sure to update `assembly/distribution.xml`

We must specify which classes to remove from the IIPC openwayback-core-modified.jar file by adding them to the `exclude` list in `upstream-wayback-core/assembly/distribution.xml`:

```
<assembly>
...
  <fileSets>
    <fileSet>
      ...
      <excludes>
        <exclude>**/ArchivalUrlSAXRewriteReplayRenderer.class</exclude>
        <exclude>**/ToolBarData.class</exclude>
      </excludes>
      ...
```

This is how the maven-assembly-plugin will know what to exclude from `upstream-wayback-core/target/openwayback-core-modified-[version].jar`


### wayback-core

This contains only those classes with Stanford modifications, and any additional classes needed for testing.  The maven build

```
cd wayback-core
mvn clean install
```

creates a jar file: `wayback-core/target/swap-wayback-core-[version].jar` which only contains
our locally modified classes.

There may be some WARNING messages from maven;  these can be ignored.  ERROR messages would be a problem.

#### When making changes to wayback-core files, be sure to update `upstream-wayback-core/assembly/distribution.xml`

We must specify which classes to remove from the IIPC openwayback-core-modified.jar file by adding them to the `exclude` list in `upstream-wayback-core/assembly/distribution.xml`.  See above (under upstream-wayback-core).


### wayback-webapp

This contains only those files with Stanford modifications;  we build a war file using the WAR overlay approach (see https://github.com/iipc/openwayback/wiki/Creating-a-WAR-overlay and https://maven.apache.org/plugins/maven-war-plugin/overlays.html).

As with IIPC openwayback, maven builds a war file.

```
cd wayback-webapp
mvn clean war:war  # actual goal, executed as part of package
mvn clean install  # installs it in local repo for sibling builds to find
```

creates a war file in `wayback-webapp/target/swap-[version].war`.  This contains Stanford's modified webapp files and all additional upstream dependencies for the war file EXCEPT for wayback-core files.  We must add the wayback-core files in ourselves to get our local modifications.

#### To make changes to wayback-webapp ...

FIXME:  blah blah



### wayback-cdx-server

Stanford puppet deploys the cdx-server war file, so this is a way for our maven build to create one.  (TODO: possibly just download the artifact from a maven repo?).  

```
cd wayback-cdx-server
mvn clean package
```

creates a jar file `wayback-cdx-server/target/openwaybck-cdx-server-[version].war` which can be deployed by puppet.  Currently we do this via a jenkins build.  (FIXME:  add details about jenkins)


###  dist or top level build or ... FIXME:

FIXME:  blah blah

```
cd dist
mvn clean dependency:unpack assembly:single
```

takes the war file from `wayback-webapp/target/swap-[version].war` and adds in `wayback-core/target/swap-wayback-core-[version].jar` and `openwayback-core/target/openwayback-core-modified-[version].jar`.  This war file is a deployable artifact that contains Stanford modifications to the upstream IIPC openwayback code.
