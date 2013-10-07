Overview
========

The Kolab server is built out of the best available Free and Open Source software components, most if not all of which are available through the Linux distribution of your preference. However, such Linux distribution may not be as up-to-date as one might wish for the Kolab Groupware to provide the latest and greatest functionality, or may simply have a different update policy from what is typically acceptable for a Groupware environment.

The Kolab server consist of the following 6 components, which can be distributed among several systems. Each of those components can be installed using the provided meta-package.

Components
----------

To install all components on a single system, a kolab meta-package is available, pulling in all other packages and dependencies.

IMAP

    The IMAP server component of Kolab Groupware, including a daemon which synchronizes user accounts from LDAP with IMAP mailboxes.

    To install the IMAP component, use the kolab-imap meta-package. This meta-package pulls in cyrus-imapd and kolab-server.

LDAP

    The LDAP directory server component is used for user and group information, authentication and authorization.

    To install the LDAP component, use the kolab-ldap meta-package. This meta-package pulls in 389-ds and dependencies, and kolab-schema, the package containing the Kolab LDAP Schema extensions.

MTA

    The MTA, including spam-filter, virus-scanner, Kolab SMTP Access Policy and the Kolab content-filter.

    To install the MTA component, use the kolab-mta meta-package, which installs Postfix, Amavisd, SpamAssassin, ClamAV, postfix-kolab and Wallace.

Web Administration Panel

    The Kolab web-based administration panel and API.

    To install the Web Administration Panel and API, use the kolab-webadmin package.

Web Client

    The web-based client for Kolab, based on Roundcube.

    To install the Kolab web-client, use the kolab-webclient meta-package. This meta-package pulls in Roundcube, the default MySQL database driver packages, and the Kolab plugins for Roundcube.

Databases

    The database component, shared between the Kolab Web Administration Panel, the Web Client, and the MTAs.

    No meta-package for this component exists, as the default choice for a MySQL server is contained within a single package throughout the supported platforms.

