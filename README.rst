Overview
========

This repository contains:

1) Profile hooks in hooks/

   Since TKLBAM 1.4, profile level hooks are supported.  These are
   TKLBAM hooks that live inside the profile. They work just like the
   hooks in /etc/tklbam/hooks.d except that they need to be
   cryptographically signed by the TurnKey release key for security
   reasons.

   The idea is to use this to build up a library of hooks that are
   useful during migration (e.g., stopping/starting services to prevent
   serialization issues, tweaking a configuration file or upgrading a
   database schema, etc.)

   We don't use this enough yet, but the infrastructure is already
   there.

2) Path includes/excludes configurations in the top-level

   These are the plain text top-level configuration files which we use
   to determine which paths to index when TKLBAM profiles are generated.
   Most of them are empty.

   In a nutshell, these configurations are a list of filesystem paths to
   scan for changes.

   Each TurnKey app has its own configuration file that includes or
   excludes filesystem paths that we don't scan for changes in the "core"
   profile. In other words, all configurations inherit from "core".
   
   If the "core" configuration is sufficient, then the app-specific
   configuration will be empty. Most of them are empty.

What paths are we scanning changes to?
======================================

As per the embedded documentation from tklbam internal create-profile
command::

    In principle, we want to track changes to the user-servicable,
    customizable parts of the filesystem (e.g., /etc /root /home /var
    /usr/local /var /opt /srv) while ignoring changes in areas maintained by
    the package management system.  The "Filesystem Hierarchy Standard"
    describes the Linux filesystem structure.

    Why not backup everything?

    TKLBAM was originaly designed to make it easy for users to only backup the
    delta (I.e., changes) from a fixed installation base (I.e., an appliance). In
    this usage scenario, less is more.

    By default we only backup your data and configurations, plus a list of new
    packages you've installed. Later when you restore these will be overlaid on top
    of the new appliance's filesystem and the package management system will be
    asked to install the missing packages.

    By contrast, If you backup the entire filesystem TKLBAM won't be able to help
    you migrate your data and configurations to a newer version of an appliance.
    The restore will just run everything over. At best you'll end up with the old
    appliance in a new location. But more likely you'll end up mixing the old and
    new filesystems and break the package management system.

For more detail::

    $ tklbam internal create-profile --help
    What is a backup profile?

    A backup profile is used to calculate the list of system changes that need to
    be backed up (e.g., new files and packages). It typically describes the
    installation state of the system and includes 3 files:

    * dirindex.conf: list of filesystem paths to scan for changes
    * dirindex: index of timestamps, ownership and permissions for dirindex.conf paths
    * packages: list of currently installed packages.

    [ .. snip ..]

