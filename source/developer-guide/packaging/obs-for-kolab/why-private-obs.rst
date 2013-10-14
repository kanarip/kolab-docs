.. _dev-packaging-why_private_obs:

===============================
Why Run a Private OBS Instance?
===============================

One of the most frequently asked questions, even before we ever started
implementing the use of OBS, is why we would run a private instance.

We're Upstream, not the Build Service
=====================================

The Kolab community on `kolab.org <http://kolab.org>`_ and its patron
`Kolab Systems <https://kolabsys.com>`_ are upstream for the Kolab Groupware
solution.

In the public OBS, the release management aspects of a *3.0 stable release*
versus a *3.1 development release* are reflected poorly, if at all, and the
projects related to the OBS projects are **out of mainstream** [#]_, and have
not yet been submitted back upstream.

Update Repositories
===================

Kolab Groupware requires the updates released for a certain platform to be
released, as both such updates repositories may contain new packages required
for Kolab, or may include new versions of software that require our packages to
be rebuild against them.

3rd Party and Additional Software Repositories
==============================================

Kolab Groupware holds a natural need for 3rd party or additional software
repositories as well, for our software glues all of these pieces together. For
Enterprise Linux 6, we require
`Extra Packages for Enterprise Linux <http://fedoraproject.org/wiki/EPEL>`_ by
the Fedora Project, for Ubuntu we require packages from it's *universe*
software repository, and for openSUSE we require packages from a third party
repository such as `server:php:applications
<https://build.opensuse.org/project/show/server:php:applications>`_.

Repository and Build Target Configuration
=========================================

Kolab Systems heavily relies on the expertise of its in-house packagers, all of
whom very experienced with Fedora and Enterprise Linux packaging. For inclusion
of the packaging work into upstream distributions, certain conditions known as
Packaging Guidelines need to be met -- and they need to be met across
distributions.

We therefore have Enterprise Linux 6 as our current reference platform for a
community Kolab Groupware installation, and need the build systems we use for
Kolab Groupware in general, to reflect the Enterprise Linux build system as
closely as possible.

This has proven to not always be the case for the public OBS.

Download-on-Demand, Storage and Mirroring
=========================================

Because of the aforementioned problems, we're almost forced to run a private OBS
instance already. This introduces other problems, related to a feature called
*Download-on-Demand* appearing to not work, and storage restrictions.

Kolab Systems maintains a full mirror of operating system release trees and
their updates, additional software and 3rd party repositories for automated
deployment to systems in order to be able to assure the Kolab Groupware quality,
and continue development.

This mirror extends to a data volume of about 900 GB easily. This may not seem
a lot of storage, but it is currently shared between a variety of services and
applications, and would need to be duplicated for OBS specifically.

Kolab Systems therefore maintains a set of patches against OBS that enable it to
share the data from its existing location.

.. rubric:: Footnotes

.. [#] https://build.opensuse.org/package/show/server:Kolab:UNSTABLE/kolab-scripts
