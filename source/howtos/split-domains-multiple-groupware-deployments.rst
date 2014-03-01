========================================================
HOWTO: Split Domains Over Multiple Groupware Deployments
========================================================

This HOWTO addresses using Kolab Groupware in situations where multiple
groupware environments exist.

Such an environment can be heterogeneous, meaning different groupware technology
could be used in the environment.

In the scenario in this HOWTO, we'll have:

*   A :term:`parent domain` of ``example.org``,
*   A user ``john.doe@example.org`` using Kolab Groupware,
*   A user ``joe.sixpack@example.org`` using Microsoft Exchange,
*   A user ``min.imum@example.org`` using Novell Groupwise,
*   A user ``lucy.meier@example.org`` using IBM Lotus Notes.

The Smart Host
==============

Use one or more smart hosts to route traffic.

Multiple smarthosts are only added for capacity -- they must all have the same
configuration to determine which recipient address is to be routed where.

Web Administration Panel
========================

Mail Delivery to Shared Folders
===============================

