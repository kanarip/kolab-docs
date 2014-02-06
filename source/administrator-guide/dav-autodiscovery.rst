=================================================
Configuring Auto-Discovery for CalDAV and CardDAV
=================================================

In order to simplify the configuration of CalDAV and CalDAV clients, service
discovery can be configured according to `RFC 6764 <http://www.rfc-editor.org/rfc/rfc6764.txt>`_ which suggests means of adding 
DNS records and well-known URIs to the primary domain.


Defining well-known URIs for iRony
==================================

Well-known URIs are used when setting up CalDAV and CardDAV clients to 
automatically detect the service configuration, mainly the server URI. So when 
configuring a CalDAV client for the account ``sample@example.org``, the client 
will take the domain part of the account name and send a HTTP(S) request to ``https://example.org/.well-known/caldav`` which is expected to redirect to the service URL using a HTTP mechanisms, e.g. with a *301 Moved Permanently* response.

The sample Apache config file packaged with iRony already contains rewrite rules
pointing to the /iRony/ path. If the service is installed at a different path, 
adjust the two rewrite rules accordingly:

.. parsed-literal::

    RewriteRule ^\.well-known/caldav   /**<path-to-iRony>**/ [L,R=301]
    RewriteRule ^\.well-known/carddav  /**<path-to-iRony>**/ [L,R=301]


There are good reasons to run the CalDAV and CardDAV service at root level of your web server. Especially to make it work with the Mac OS X 10.6 Addressbook 
this is a must [#]_.

Assuming iRony is set up at root on ``dav.example.org`` the well-known URIs 
have to be configured for the host serving ``example.org`` and redirecting to
the fully qualified location of the iRony service. 

.. parsed-literal::

    RewriteEngine On
    RewriteBase /
    RewriteRule ^\.well-known/caldav   https://dav.example.org/ [L,R=301]
    RewriteRule ^\.well-known/carddav  https://dav.example.org/ [L,R=301]


SRV Service Labels and Service TXT Records
==========================================

Beside the well-known URIs, it's also recommended to add DNS entries for the 
service discovery protocol as described in `RFC 6764 <http://www.rfc-editor.org/rfc/rfc6764.txt>`_, Chapters 3. and 4.


.. rubric:: Footnotes

.. [#] https://code.google.com/p/sabredav/wiki/OSXAddressbook