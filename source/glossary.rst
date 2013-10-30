========
Glossary
========

.. glossary::

    alias domain
    alias domain name space
    alias domain name spaces

        The intended use of an alias domain name space is to be a largely
        transparent alias domain for users or recipients whom would otherwise
        have an email address in the :term:`parent domain name space` as well.
        In other words, what is a valid local part used with an ``@example.org``
        (the parent domain name space) email address is also considered a valid
        local part when used with an ``@example.net`` (the alias domain name
        space) email address, for both sending and receiving email messages, and
        vice-versa.

        Whether or not an alias domain name space is actually as transparent
        depends on the configuration of the :term:`result attribute`, and
        subsequently, therefore, also the :term:`primary email address` of
        individual recipient entries.

        .. seealso::

            *   :term:`child domain name space`
            *   :term:`parent domain name space`

    authorization realm

        The authorization realm (...)

    child domain
    child domain name space
    child domain name spaces

        A child domain name space is very similar to an alias domain name space,
        in that a child domain name space is **exactly the same**, but for one
        aspect: Hosted Kolab Groupware.

        With Kolab Groupware, :term:`parent domain name spaces` are stored as
        individual LDAP objects, and so are they in Hosted Kolab Groupware
        deployments.

        In hosted environments, however, any :term:`alias domain name spaces`
        needs to be verified the ownership of (just like for the parent domain
        name space), before the alias domain name space is activated.

        When using the LDAP attribute of ``inetDomainStatus`` to track the
        confirmation and activation status of ``domainRelatedObject`` entries,
        alias domain name spaces need to be stored in entirely different LDAP
        entries altogether, and are solely therefore referred to as **child
        domain name spaces**.

    DN
    distinguished name

        .. seealso::

            *   :term:`relative distinguished name`

    domain name space
    domain name spaces

        A domain name space is, among other things, the qualification of a
        recipient's local-part. It is the domain name appended to the local part
        of an email address, the two of them divided by an '@' character (sender
        specified routing notwithstanding).

        Without domain name spaces, user 'john' would only ever know about user
        'jane' if -- pardon my French to those in the know -- if both 'john' and
        'jane' considered eachother local. In other words, if both 'john' and
        'jane' used the same physical *system environment*. As you may be aware,
        the Internet is composed of a quite a few thousands of such system
        environments.

        What *qualifies* users 'john' and 'jane' to all other users on the
        Internet is a *name space*. The name space must be globally unique
        (literally "globally" -- but technically speaking more like
        "universally unique").

        The only name spaces available to Internet registrars and therefore
        service providers and therefore users, are called *domains* -- they are
        composed of a *top-level domain (name space)* such as .org and .com, and
        a name that a service provider would allow you to register with the
        Internet registrar (a NIC) - each domain is therefore at least one but
        possible more *domain name spaces*.

        To further illustrate, you require an Internet registrar to obtain your
        own *domain name* -- unless you are an Internet registrar yourself, of
        course, though you still need one, but it just so happens you are one.

        Once you have registered a domain name (and, contrary to popular belief,
        you don't actually own it, ever) nothing prevents you from creating
        additional domain name spaces within the name space of that domain.

        You could, for example, register ``example.org``, and create a domain
        name space of ``customer1.example.org`` and/or ``family2.example.org``.

        In fact, every :term:`fully qualified domain name` is a domain name
        space in and of its own -- but it identifies on the individual system
        level as opposed to the environment level.

        .. seealso::

            *   :term:`alias domain name space`
            *   :term:`child domain name space`
            *   :term:`parent domain name space`

    domain_base_dn

        The domain base dn is (...)

    domain_name_attribute

        The domain name attribute is (...)

    domain_result_attribute

        The domain result attribute is (...)

    external email address

        An external email address is intended to be additional user information,
        and another means of contacting the user, not unlike a street and postal
        code may be additional, personal information for the user.

        .. seealso::

            *   :ref:`and_ldap_use-of-mailalternateaddress`
            *   :term:`forwarding email address`
            *   :term:`primary email address`
            *   :term:`secondary email address`

    forwarding email address

        A forwarding email address (...)

        .. seealso::

            *   :term:`external email address`
            *   :term:`primary email address`
            *   :term:`secondary email address`

    FQDN
    fully qualified domain name

        A Fully Qualified Domain Name is intended to refer to a single node (or
        "operating system instance", if you will) whether it be traditionally
        physical or virtual, in a manner that is globally ("universally")
        unique.

        As such, it SHOULD be composed of at least three (3) name space segments
        divided by a dot (.) character -- exluding the implicit top-level dot
        (.), even if a domain (system environment) is comprised of a single
        system.

    management domain

        A management domain is (...)

    msa
    Mail Submission Agent

        The Mail Submission Agent (*MSA*) (...)

    mua
    Mail User Agent

        The Mail User Agent (*MUA*) (...)

    parent domain
    parent domain name space
    parent domain name spaces

        A parent domain, or parent domain name space, is a domain entity that
        corresponds to an isolated directory tree. A parent domain may have
        additional aliases, all of which will need to resolve back to the
        directory tree associated with the parent domain.

        Kolab components such as the Kolab daemon, the Kolab SMTP Access Policy
        and the Kolab Web Administration Panel (or actually, its API) make sure
        that the primary email address (which becomes the :term:`authorization
        realm` when the default :term:`result attribute` configuration value of
        ``mail`` is maintained) is within the domain name spaces associated with
        the parent domain (i.e. an :term:`alias domain name space` or
        :term:`child domain name space`).

    Perfect Forward Secrecy

        *Perfect Forward Secrecy* or PFS (...)

    primary domain
    primary domain name space

        A primary domain is (...)

    primary email address

        A primary email address (...)

        .. seealso::

            *   :term:`external email address`
            *   :term:`forwarding email address`
            *   :term:`secondary email address`

    primary hosted domain

        A primary hosted domain is (...)

    recipient policy

        The recipient policy (...)

    relative distinguished name

        A relative distinguished name (...)

    result attribute

        (...)

    root dn

        A root dn

    secondary email address

        A secondary email address (...)

        .. seealso::

            *   :term:`external email address`
            *   :term:`forwarding email address`
            *   :term:`primary email address`
