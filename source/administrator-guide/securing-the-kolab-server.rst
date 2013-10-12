=========================
Securing the Kolab Server
=========================

This chapter outlines the recommendations for further securing your Kolab
Groupware server.

.. WARNING::

    Further securing your Kolab Groupware server may kick you off of mainstream
    supply channels for further updates possibly including security fixes.

    Additionally, it may also not be helpful at all, and provide a false sense
    of security to you and your users.

    Before considering to follow any of the following recommendations, carefully
    consider the implications of missing a security update because there is not
    enough time to subscribe, pay attention and follow up.

Your Jurisdiction
=================

Unless you are yourself some or the other form of authority, no level of
protection can protect you against the recognized authorities.

Our societies are, in principle, subject to the rule of law -- even if that same
law allows the authorities to break the law but not break the law [#]_, and
terrorize foreign and domestic populations [#]_, either with or without
reasonable suspicion, with or without disclosure, and/or with or without
meaningful judicial review.

Similar legislation may apply to your jurisdiction, but it is not just your own
jurisdiction that matters.

Privileged Information in Transit
=================================

Some authorities have passed laws that allow them to stop and search otherwise
innocent people when in transit through certain areas, seizing materials they
may have on them, and detaining the individual for questioning [#]_.

It is sometimes considered a criminal offence for such individual to not
cooperate with the interview(er(s)). So, should a laptop or data carrier you
have on you contain privileged information, you may be obliged to disclose your
means of protecting that data, or be found uncooperative.

The case for system administrators goes further, as -- as a part of their
profession -- they have access to information that is mostly private, sometimes
sensitive, but otherwise still not their own.

You would want to prevent one of your system administrators being forced into
the awkward disposition of needing to choose between logging into your systems
to retrieve the data requested, and jail.

Using Forward Secrecy
=====================

Forward Secrecy, also known as :term:`Perfect Forward Secrecy` although never
actually perfect, uses additional cryptographic measures to prevent a particular
TLS session's key derived from a set of public and private keys is not
compromised should one of the private keys be compromised in the future.

The most commonly used ciphers are based on ephemeral Diffie-Hellman (EDH),
allowing two parties to anonymously agree upon a shared secret for the session
keys, over the not yet secured communication channel.

For a Kolab Groupware environment, Forward Secrecy can be enabled using newer
versions of software packages than are otherwise available to mainstream
Enterprise Linux distributions.

, but not
**enforced** on all layers of communication;

*   Communications over HTTPS can be secured, but some browsers do not have the
    required level of encryption capabilities.

*   Communications over IMAP+TLS can be secured, but again depending on the
    client encryption capabilities, this may or may not include Forward Secrecy.

*   Communications with the MTA/MSA can be secured, but is once more dependent
    on the client encryption capabilities for the inclusion of Forward Secrecy.

Most of your clients however will have the appropriate capabilities, except for
Internet Explorer versions 6 and 8 on Windows XP.

The real problematic area is in communications between your SMTP servers, and
those of the rest of the world.

In real life, not many parties purchase an SSL certificate issued by a trusted
third party. Additionally, in recent months, it has come to light that most
of those trusted third parties can only be trusted as much as the authorities of
their domicile and in jurisdictions they operate in.

As such, to accept TLS encryption offered using a self-signed or falsified SSL
certificate under the assumption it actually secures anything is a misinformed
conclusion. To only accept valid TLS encryption SSL

.. admin-securing_kolab-openssl:

OpenSSL 1.0.1 or newer
======================

*   When permitted, use the Non-USA version of OpenSSL
*   Enable Ecliptic Curve encryption

Apache httpd 2.4
================

Apache httpd 2.4 needs to be compiled using :ref:`_admin-securing_kolab-openssl`
as described.

.. parsed-literal::

    SSLEngine On
    SSLProtocol all -SSLv2 -SSLv3
    SSLHonorCipherOrder on
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 \
        EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 \
        EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"


.. rubric:: Footnotes

.. [#] http://en.wikipedia.org/wiki/PRISM_%28surveillance_program%29
.. [#] http://www.theguardian.com/world/2013/aug/18/glenn-greenwald-guardian-partner-detained-heathrow
.. [#] http://www.independent.co.uk/life-style/gadgets-and-tech/uk-police-authorised-to-seize-mobile-data-at-the-border-without-reasonable-suspicion-8708920.html
