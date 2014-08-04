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

        The authorization realm is the target user authorization ID's namespace.

        When, for example, a user *John Doe* logs in with username ``doe`` (the
        "authentication ID"), the original authorization realm (as specified in
        the original username) is ``null``.

        After user login name :term:`canonification` -- a process to translate
        an authentication ID in to an authorization ID -- the resulting
        authorization ID may have become ``john.doe@example.org``.

        The canonification process is important, because it will also be the
        authorization ID that is used to compose the mailbox path to the user's
        INBOX.

        Continuing our example user, the authorization ID having become
        ``john.doe@example.org`` will result in the session using
        ``user/john.doe@example.org`` as the INBOX.

        The **authorization realm** at this point is one of ``example.org``. The
        user will not be able to access any mailboxes outside this authorization
        realm, meaning the user will be unable to access any mailboxes for which
        the mailbox path does not end in ``@example.org``.

    canonification

        Canonification is the process of translating a login username in
        to the targeted value to use throughout the rest of the
        infrastructure.

        Suppose, for example, a user *John Doe <doe@example.org>* has a
        :term:`primary email address` of *doe@example.org*, and a user
        ID of *doe*. Suppose therefore his mailbox is
        ``user/doe@example.org``, and his authorization ID is
        ``doe@example.org``.

        When John logs in however, he may also use one of his secondary
        recipient addresses, such as *john.doe@example.org* or
        *jdoe@example.org*.

        This login username needs to be translated to
        ``doe@example.org`` in order to obtain the correct INBOX, and
        allow applications to consistently retrieve profiles with user
        preferences.

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

        The *distinguished name* is the LDAP terminology for the location of an
        object in a Directory Information Tree hierarchy.

        The LDAP object for a user *John Doe* might have a distinguished name of
        ``uid=doe,ou=People,dc=example,dc=org``.

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

        The domain base dn is the position in a Directory Information Tree's
        hierarchy at which to start searching for domain name spaces.

        .. seealso::

            *   :term:`domain_filter`
            *   :term:`domain_name_attribute`
            *   :term:`domain_result_attribute`
            *   :term:`domain_scope`

    domain_name_attribute

        The domain name attribute is the name of the attribute that holds the
        parent domain name space in LDAP.

        By default, the domain name attribute is ``associateddomain``, for an
        object with object class ``domainrelatedobject``.

        The ``associateddomain`` attribute is specified as *multi-valued* in the
        LDAP schema, and as such may contain one or more values.

        LDAP stores these in order, so that the first associateddomain attribute
        value is also the one that was the first to be added.

        If you had a domain name space of ``example.org``, the LDAP object might
        look as follows:

        .. parsed-literal::

            dn: associateddomain=example.org,cn=kolab,cn=config
            objectclass: top
            objectclass: domainrelatedobject
            associateddomain: example.org

        Then, when one or more :term:`alias domain name spaces` are added for
        ``example.org``, the object may look as follows:

        .. parsed-literal::

            dn: associateddomain=example.org,cn=kolab,cn=config
            objectclass: top
            objectclass: domainrelatedobject
            associateddomain: example.org
            associateddomain: example.nl
            associateddomain: example.de

    domain_result_attribute

        The domain result attribute is used to allow the specification of a
        custom :term:`root dn` for the Directory Information Tree hierarchy
        associated with the domain name space.

        In a default Kolab Groupware installation, when a domain of
        ``example.org`` is added to the environment, a standard translation
        routine is applied to the domain name space to define the associated
        Directory Information Tree hierarchy root, the :term:`root dn`.

        This routine makes ``example.org`` become ``dc=example,dc=org``.

        Existing environments may already have LDAP available to their systems,
        which does not necessarily have a standard root dn for the domain. As
        such, an existing :term:`root dn` for domain ``example.org`` may have a
        dn of ``o=example,c=de``.

        .. parsed-literal::

            dn: associateddomain=example.org,cn=kolab,cn=config
            objectclass: top
            objectclass: domainrelatedobject
            objectclass: inetdomain
            associateddomain: example.org
            inetdomainbasedn: o=example,c=de

    domain_scope

        The domain scope is the level of depth the searches for domain name
        spaces uses, and is one of ``base``, ``one`` or ``sub``.

    EPEL

        EPEL stands for Extra Packages for Enterprise Linux, and is a software
        repository maintained by the Fedora Project community.

        It contains packages that are supplementary to a base RHEL subscription
        including the *optional* software repository, such as **amavisd-new**
        and **clamav**.

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

    made-to-measure

        A Made-to-Measure solution is designed to be altered and adjusted to
        better fit one's needs.

        This is in contrast with so-called Commercial-Off-the-Shelf solutions,
        which allow for too little modification in the solution itself, or none
        at all, and require one's needs to be flexible.

    management domain

        A management domain is (...)

    msa
    Mail Submission Agent

        The Mail Submission Agent (*MSA*) (...)

    mua
    Mail User Agent

        The Mail User Agent (*MUA*) (...)

    pattern

        A pattern for mailboxes can be specified using ``%`` and ``*``
        wildcards.

        The ``%`` wildcard matches mailboxes on a single level only, while the
        ``*`` wildcard matches mailboxes in all depth levels.

        To list INBOX folders for users in the example.org domain, use:

        .. parsed-literal::

            # :command:`kolab lm user/%@example.org`

        but to list all user folders in the example.org domain:

        .. parsed-literal::

            # :command:`kolab lm user/*@example.org`

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

    recipient email address
    recipient email addresses

        A recipient email address is (...)

        .. seealso::

            *   :term:`primary email address`
            *   :term:`secondary email address`

    recipient policy

        The recipient policy (...)

    relative distinguished name

        A relative distinguished name (...)

    result attribute

        The result attribute is the name of the target attribute to use
        the value of, when translating a login username to the
        appropriate value (a process called :term:`canonification`).

        .. seealso::

            *   :term:`canonification`

    root dn

        A root dn describes the path to the root of a Directory Information Tree
        hierarchy.

        It is commonly associated with LDAP databases, in that all entries
        contained within one root dn are in databases that are separate from the
        databases used for another root dn.

    sealed system

        A sealed system is a system where the users have access to the services
        offered by the system, but not the system itself. In other words, a
        Kolab Groupware user cannot normally login to a shell on the system and
        start poking around.

    secondary email address

        A secondary email address (...)

        .. seealso::

            *   :term:`external email address`
            *   :term:`forwarding email address`
            *   :term:`primary email address`

    working domain

        The working domain is the currently selected domain name space
        to work against in the Kolab Web Administration Panel.

        A user logs in to the Web Administration Panel with an initial
        login username of ``john.doe@example.org``, but may have
        privileges to edit users in another parent domain name space
        such as ``company.com``. John would issue a
        ``system.select_domain`` and his session would then be
        associated with the ``company.com`` domain -- now his
        :term:`working domain`.
