.. _and-kolab_wap_api:

======================================
Kolab Web Administration Panel and API
======================================

The web administration panel comes with an API in order to allow
different, third-party interfaces, as well as the Kolab tool-chain to
Kolab Groupware, to execute tasks of an administrative nature.

The API uses JSON to exchange information with the API client.

The calls to the Web API are made to a service handler, for its methods
handle the request. A call therefore looks as follows:

    **<service>.<method>**

which is a location beneath the base URL for the API.

Suppose https://kolab-admin.example.org/api/ is the API base URL, then a
call to service method **system.authenticate** would be a POST HTTP/1.1
request to https://kolab-admin.example.org/api/system.authenticate.

HTTP Method Convention
======================

Two HTTP methods are used: GET and POST. The GET method is generally(!)
used for read-only operations, to obtain information, whereas the POST
method is used for write operations (modification of objects or session
state).

For GET requests, the parameters (the payload) are appended to the URI
requested,
https://kolab-admin.example.org/api/domain.info?domain=example.org.

.. NOTE::

    This restricts GET requests to specifying key-value pairs of payload
    information only, even though a GET parameter key can be specified
    more then once, creating a list of values.

Some read-only operations, such as user.find_by_attributes require the
request to pass along multiple attributes with, potentially, multiple
search parameters. These types read-only requests are the exception to
the rule of using GET for read-only requests, and use POST instead.

For POST requests, the payload is a JSON-encoded dictionary (array) of
parameter keys and values. Only strings are allowed as keys. Values for
the payload may contain lists, strings, dictionaries (arrays), integers,
floats, etc.

Service and Method Naming Convention
====================================

In another rule-of-thumb we outline the naming convention for services
and methods.

Service names consist of an object name either in singular or plural
form. The singular form depicts actions are placed against a single
instance of an object, such as **object.add**, or when at most one
result entry is expected, such as **object.find**.

The plural form depicts actions that are placed against multiple
instances of an object, such as **objects.list** or **objects.search**,
and expect zero or more result entries to be returned.

Method names often imply an action is placed against one or more objects
in one request. Certain actions may be confusing though. For these we
have the following rules;

**Finding an object**

    The method find is always executed against the service with the
    singular form of the object name. The target of calling a find
    method is to obtain exactly zero or one instance of an object. The
    method should fail if the result set contains any number of objects
    not zero or one.

    Example finding user *John Doe <john.doe@example.org>*:

    .. parsed-literal::

        >>> print api.get('user.find', '{"mail": "john.doe@example.org"})
        '{"status":"OK","result":(...)}'

**Searching for objects**

    The method search is always executed against the service with the
    plural form of the object name. The target of calling a search
    method is to obtain all matches, if any. The method should return
    any result set containing zero or more results.

    Example searching for user *John Doe <john.doe@example.org>*:

    .. parsed-literal::

        >>> print api.get('users.search', '{"givenname":"John"}')
        '{"status":"OK","result":(...)}'

**Listing objects**

    A list result set contains the following components:

        #.  status

        #.  result

            #.  **count** (integer)

            #.  **list** (dictionary)

                #.  entry id

                    #. additional entry attributes

                #.  entry id

                    #. additional entry attributes

    Example listing domains:

    .. parsed-literal::

        >>> print api.get('domains.list')
        "{
                u'status': u'OK',
                u'result': {
                        u'count': 2,
                        u'list': {
                                u'associateddomain=example.org,cn=kolab,cn=config': {
                                        u'associateddomain': [
                                                u'example.org',
                                                u'kolab.example.org',
                                                u'localhost.localdomain',
                                                u'localhost'
                                            ]
                                        },
                                u'associateddomain=mykolab.com,cn=kolab,cn=config': {
                                        u'associateddomain': u'mykolab.com'
                                    }
                            }
                    }
            }"

Standard Response Layout
========================

The standard response layout offers a location for the request status, an error
code and the corresponding message, or a result.

The status is the first item in the JSON object. It has two possible values: OK
or ERROR. Depending on the status of the request, the rest of the JSON output
contains a result (OK) or the error details (ERROR).

The response to a successful request looks as follows:

.. parsed-literal::

    {
        "status": "OK",
        "result": (...)
    }

The response to a successful request that is expected to return zero or one
items, such as find methods, includes a result layout as follows:

.. parsed-literal::

    {
        "status": "OK",
        "result": {
            (... entry data ...)
        }
    }

The reponse to a successful request that is expected to return a list of zero,
one or more items, such as list and search methods, includes a result layout as
follows:

.. parsed-literal::

    {
        "status": "OK",
        "result": {
            "list": [
                    (...),
                ],
            "count": <integer>
        }
    }

A failed result however looks like:

.. parsed-literal::

    {
        "status": "ERROR",
        "code": <integer>,
        "reason": "<string>"
    }

Service Handlers
================

The following service handlers are available:

**domain**

    Domain operations, such as obtaining information about them, or adding,
    editing and deleting a domain.

**domains**

    Operations against multiple domains, such as listing or searching.

**form_value**

    The service handler for form values. Can be used to generate form values
    (such as passwords for new users), and compose form values for form fields
    for which the value is to be composed using existing field values from other
    form fields -- for example the ``mail`` attribute value using a
    :ref:`admin_rcpt-policy`.

    It is also used to validate form input.

**group**

    Add, modify, delete or obtain information about a group object.

**groups**

    List or search group objects.

**group_types**

    The service handler that provides information about group types.

**resource**

    Add, modify, delete or obtain information about a resource object.

**resources**

    List or search resource objects.

**resource_types**

    The service handler that provides information about resource types.

**role**

    Add, modify, delete or obtain information about a role object.

**roles**

    List or search role objects.

**role_types**

    The service handler that provides information about role types.

**system**

    The main service handler for modifying session state.

**user**

    Add, modify, delete or obtain information about a user object.

**users**

    List or search user objects.

**user_types**

    The service handler that provides information about user types.

The ``domain`` Service
======================

The ``domain`` service makes available actions against a single parent domain
entity, for example 'add' or 'delete'.

``domain.add`` Method
---------------------

Depending on the technology used, quite the variety of things may need to happen
when adding a domain to a Kolab Groupware deployment. This is therefore made the
responsbility of the API rather than the client.

.. program:: domain.add

.. option:: type_id

    The ``type_id`` for the domain. At the time of this writing, only one type
    ID is available, namely that of a parent domain.

.. option:: domain name

    The domain name is a mandatory parameter to the ``domain.add`` call. Note
    that it is the ``domain_types.list`` API call that describes what the
    attribute name for the domain name (the value) should be.

.. rubric:: Example Usage

To add a domain ``example.org``, use the following logic.

#.  Login to the API, using the
    :ref:`and-kolab-wap-api-system-authenticate-method`. An example login
    procedure is included in that section.

#.  Obtain the list of different domain types, using the process outlined the
    example usage section of :ref:`and-kolab-wap-api-domain_types-list-method`.

#.  A subsequent call may therefore look like:

    >>> api.request(
            'POST',
            'domain.add',
            post = json.dumps(
                    {
                            "type_id": 1,
                            "associateddomain": [
                                    'example.org'
                                ]
                        }
                ),
            headers = headers
        )

Server-side Implementation Details
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On the server-side, when a domain is added, an entry is added to the default
authentication and authorization database, as configured through the setting
``auth_mechanism`` in the ``[kolab]`` section of :manpage:`kolab.conf(5)`.

The authentication database technology referred to has the necessary settings to
determine how a new domain can be added. The related settings for LDAP are
``domain_base_dn``, ``domain_scope``, ``domain_filter``,
``domain_name_attribute`` (used for the RDN to compose the DN).

After checking the domain does not already exist (using administrative
credentials), the domain is added using the credentials for the logged in user.

This is an access control verification step only; the logged in user must have
'add' rights on the Domain Base DN.

Additional steps when adding a (primary) domain name space is to create the
databases and populate the root dn.

.. TODO
.. ^^^^
..
.. The following is a list of things that still need to be designed and/or
.. implemented.
..
.. *   Adding an alias for a domain name space, such that "company.nl" can be
..     specified as an alias domain name space for "company.com".
..
.. *   Designating an "owner" of a domain name space, possibly through nesting
..     (LDAP) or assigning a owner_id (SQL).
..
.. *   Determining access to a domain name space for any particular set of
..     credentials.
..
.. *   It seems, for OpenLDAP, the server-side getEffectiveRights control is not
..     supported. An alternative may be to probe the root dn for the domain name
..     space using the current session bind credentials, but this may not scale.
..     Exceptions to the probing would need to be established to make sure the
..     known DNs are not subjected to the extensive operation(s) (such as
..     ``cn=Directory Manager``).
..
.. *   Once a domain is added, we have to implement access control on top of it.

``domain.delete`` Method
------------------------

``domain.edit`` Method
----------------------

``domain.info`` Method
----------------------

The ``domains`` Service
=======================

``domains.list`` Method
-----------------------

The ``domain_types`` Service
============================

.. _and-kolab-wap-api-domain_types-list-method:

``domain_types.list`` Method
----------------------------

List the types of domain objects that the API accepts.

.. rubric:: Example Usage

#.  Login to the API, using the
    :ref:`and-kolab-wap-api-system-authenticate-method`. An example login
    procedure is included in that section.

#.  List the type definitions for the object ``domain``, using
    :ref:`and-kolab-wap-api-domain_types-list-method`:

    >>> domain_types_response = api.request(
            'GET',
            'domain_types.list',
            headers = headers
        )

#.  The raw results may look like:

    .. parsed-literal::

        {
                "status": "OK",
                "result": {
                        "list": {
                                "1": {
                                        "key": "standard",
                                        "name": "Standard domain",
                                        "description": "A standard domain name space",
                                        "attributes": {
                                                "auto_form_fields": [],
                                                "form_fields": {
                                                        "associateddomain": {
                                                                "type": "list"
                                                            },
                                                        "inetdomainbasedn": {
                                                                "optional": true
                                                            },
                                                        "inetdomainstatus": {
                                                                "optional": true,
                                                                "type": "select",
                                                                "values": [
                                                                        "",
                                                                        "active",
                                                                        "suspended"
                                                                    ]
                                                                }
                                                    },
                                                "fields":{
                                                        "objectclass": [
                                                                "top",
                                                                "domainrelatedobject",
                                                                "inetdomain"
                                                            ]
                                                    }
                                            }
                                    }
                            },
                        "count": 1
                    }
            }

    The part of particular interest is the ``attributes`` section. For a
    detailed review of its structure, see
    :ref:`and-kolab-wap-api-attributes-value-format`.

    In this example, the ``domain_types.list`` gives us one type definition, and
    tells us that at least one ``associateddomain`` attribute value is required,
    since it does not include ``optional: true``.


The ``form_value`` Service
==========================

``form_value.generate`` Method
------------------------------

This API call allows access to routines that generate attribute values. It
accepts data containing the names and values of other attribute values as input,
which can be used to generate the new attribute value requested.

The form_value.generate API call accepts the following parameters:

**attribute**

    The name of the attribute to generate the new value for.

**data**

    An array with key-value pairs containing the attribute name (key) and
    attribute value (value) to use to generate the new value for the attribute
    supplied in attribute.

    This parameter is required for certain attributes, such as the ``cn``, but
    not for other attributes, such as ``userPassword``.

**object_type**

    The object type name to generate the value for.

**type_id**

    The object type ID to allow for different policies to be applied.

.. rubric:: Example Usage #1: Generate a User Password

#.  Login to the API, using the
    :ref:`and-kolab-wap-api-system-authenticate-method`. An example login
    procedure is included in that section.

#.  Issue a call against ``form_value.generate``:

    >>> print api.request(
            'POST',
            'form_value.generate',
            post = json.dumps(
                    {
                            'attributes': [ 'userPassword' ],
                        },
                ),
            headers = headers
        )
    {"status":"OK","result":{"userPassword":"CSRlN3zrIqqv4x-"}}

.. rubric:: Example Usage #2: Generate Attribute Values for a Kolab User

#.  Login to the API, using the
    :ref:`and-kolab-wap-api-system-authenticate-method`. An example login
    procedure is included in that section.

#.  Issue a call against ``form_value.generate``:

    >>> print api.request(
            'POST',
            'form_value.generate',
            post = json.dumps(
                    {
                            'object_type': 'user',
                            'type_id': 1,
                            'attributes': [
                                    'alias',
                                    'cn',
                                    'displayname',
                                    'mail',
                                    'uid'
                                ],
                            'givenname': 'John',
                            'preferredlanguage': 'en_US',
                            'sn': 'Doe',
                        },
                ),
            headers = headers
        )
    {
            "status": "OK",
            "result": {
                    "alias": [
                            "doe@example.org",
                            "j.doe@example.org"
                        ],
                    "cn": "John Doe",
                    "displayname": "Doe, John",
                    "mail": "john.doe@example.org",
                    "uid":"doe"
                }
        }

    .. NOTE::

        The ``attributes`` in this example come from the user type definition
        for ``user_type_id`` 1, and correspond with the field names listed in
        ``auto_form_fields``.

        The ``data`` that is listed in each attribute definition in
        ``auto_form_fields`` is submitted alongside the list of attributes.

        .. seealso::

            *   :ref:`and-kolab-wap-api-attributes-value-format`

``form_value.list_options`` Method
----------------------------------

List options for particular form fields.

``form_value.validate`` Method
------------------------------

The ``group`` Service
=====================

``group.add`` Method
---------------------

``group.delete`` Method
---------------------

``group.edit`` Method
---------------------

``group.info`` Method
---------------------

``group.members_list`` Method
-----------------------------

The ``group.members_list`` service method lists the members of a group.

The ``groups`` Service
======================

``groups.list`` Method
----------------------

The ``system`` Service
======================

.. _and-kolab-wap-api-system-authenticate-method:

``system.authenticate`` Method
------------------------------

Successful authentication is a prerequisite in order to be able to execute any
other action against the system. Upon success, the ``system.authenticate`` API
call returns a session token that MUST be supplied with all subsequent requests
for the session, through the HTTP header ``X-Session-Token``.

.. program:: system.authenticate

.. option:: username

    The username to use when authenticating.

    Note that this should be fully qualified, with the following exceptions:

    #.  The ``cn=Directory Manager`` server administrator account does not
        belong to any particular domain name space.

    #.  Users may authenticate against the :term:`primary domain` without
        specifying the primary domain qualification suffix.

.. option:: password

    The password.

.. option:: domain

    For global administrator accounts that have rights to read multiple domain
    name space Directory Information Tree hierarchies, optionally specify the
    domain to select as the :term:`working domain`.

.. rubric:: Example Usage

The following is a detailed, low-level, step-by-step description of executing
a call against the ``system.authenticate`` service method, in Python.

.. parsed-literal:

    >>> import json
    >>> from pykolab import wap_client as api
    >>> result = api.request(
            'POST',
            'system.authenticate',
            post=json.dumps(
                    {
                            'username': 'cn=Directory Manager',
                            'password': 'Welcome2KolabSystems'
                        }
                )
        )
    >>> print result
    {
            'domain': 'example.org',
            'userid': 'cn=Directory Manager',
            'user': 'cn=Directory Manager',
            'session_token': '72l71b7eog28qv5mq6luukb5r7'
        }
    >>> headers = { 'X-Session-Token': result['session_token']

This is a result that is already interpreted partially, and the raw response
looks as follows:

.. parsed-literal::

    {
            "status": "OK",
            "result": {
                    "user": "cn=Directory Manager",
                    "userid": "cn=Directory Manager",
                    "domain": "example.org",
                    "session_token": "66qkdbk28i6dggnvias35k0dh4"
                }
        }

The result in this response consists of the following components:

**user**

    The login name for the user authenticated.

**userid**

    The ID for the user authenticated, usually a persistent unique attribute
    associated with the entry in LDAP, except for global server administrators
    such as ``cn=Directory Manager``.

**domain**

    The current working domain. When no domain had been specified during login,
    this will default to the configured :term:`primary domain` -- in this case
    ``example.org``.

**session_token**

    A token uniquely identifying the session. This token should be used for
    subsequent API calls to associate them with this session.

    To this end, save a dictionary to pass on to subsequent requests.

    >>> headers = { 'X-Session-Token': result['session_token'] }

To assist in authenticating, the ``pykolab.wap_client`` also includes a function
``authenticate(username=None, password=None, domain=None)``, for which options
that are not specified explicitly are pulled from :manpage:`kolab.conf(5)`.

.. _and-kolab-wap-api-system-capabilities-method:

``system.capabilities`` Method
------------------------------

For all service handlers registered, a method ``capabilities`` can be executed
listing the methods available and access to them for the currently logged in
user. The ``system.capabilities`` API call lists all of the registered service
handlers' methods and access for all domains.

.. rubric:: Example Usage

.. parsed-literal::

    {
            "status": "OK",
            "result": {
                    "list": {
                            "example.org": {
                                    "actions": {
                                            "system.quit": {"type": "w"},
                                            "system.configure": {"type": "w"},
                                            "domain.add": {"type": "w"},
                                            "domain.delete": {"type": "w"},
                                            "domain.edit": {"type": "w"},
                                            "domain.find": {"type": "r"},
                                            "domain.info": {"type": "r"},
                                            "domain.effective_rights": {"type": "r"},
                                            "domain_types.list": {"type": "r"},
                                            "domains.list": {"type": "r"},
                                            "domains.effective_rights": {"type": "r"},
                                            "form_value.generate": {"type": "r"},
                                            "form_value.validate": {"type": "r"},
                                            "form_value.select_options": {"type": "r"},
                                            "form_value.list_options": {"type": "r"},
                                            "group.add": {"type": "w"},
                                            "group.delete": {"type": "w"},
                                            "group.edit": {"type": "w"},
                                            "group.info": {"type": "r"},
                                            "group.find": {"type": "r"},
                                            "group.members_list": {"type": "r"},
                                            "group.effective_rights": {"type": "r"},
                                            "group_types.list": {"type": "r"},
                                            "groups.list": {"type": "r"},
                                            "resource.add": {"type": "w"},
                                            "resource.delete": {"type": "w"},
                                            "resource.edit": {"type": "w"},
                                            "resource.info": {"type": "r"},
                                            "resource.find": {"type": "r"},
                                            "resource.effective_rights": {"type": "r"},
                                            "resource_types.list": {"type": "r"},
                                            "resources.list": {"type": "r"},
                                            "sharedfolder.add": {"type": "w"},
                                            "sharedfolder.delete": {"type": "w"},
                                            "sharedfolder.edit": {"type": "w"},
                                            "sharedfolder.info": {"type": "r"},
                                            "sharedfolder.find": {"type": "r"},
                                            "sharedfolder.effective_rights": {"type": "r"},
                                            "sharedfolder_types.list": {"type": "r"},
                                            "sharedfolders.list": {"type": "r"},
                                            "roles.list": {"type": "r"},
                                            "role.add": {"type": "w"},
                                            "role.delete": {"type": "w"},
                                            "role.edit": {"type": "w"},
                                            "role.info": {"type": "r"},
                                            "role.find": {"type": "r"},
                                            "role.members_list": {"type": "r"},
                                            "role.effective_rights": {"type": "r"},
                                            "role_types.list": {"type": "r"},
                                            "type.add": {"type": "w"},
                                            "type.delete": {"type": "w"},
                                            "type.edit": {"type": "w"},
                                            "type.info": {"type": "r"},
                                            "type.effective_rights": {"type": "r"},
                                            "user.add": {"type": "w"},
                                            "user.delete": {"type": "w"},
                                            "user.edit": {"type": "w"},
                                            "user.info": {"type": "r"},
                                            "user.find": {"type": "r"},
                                            "user.effective_rights": {"type": "r"},
                                            "user_types.list": {"type": "r"},
                                            "users.list": {"type": "r"}
                                        }
                                }
                        },
                    "count": 1
                }
        }

``system.get_domain`` Method
----------------------------

The get_domain method returns the currently selected working domain.

.. rubric:: Example Usage

.. parsed-literal::

    {
            "status":"OK",
            "result": {
                "domain":"example.org"
            }
        }

``system.quit`` Method
----------------------

The quit method ends the session and terminates its validity permanently.

``system.select_domain`` Method
-------------------------------

Select the domain supplied as the current working domain. By default, users are
logged in and have access to what they are authorized for in their own domain
name space only. Certain users, such as ``cn=Directory Manager``, have access to
all domains. This API call allows such users to select the domain name space
they are currently working on.

Server-side Implementation Details
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On the server-side, when ``system.select_domain`` is called successfully, the
selected domain is stored in ``$_SESSION['user']->current_domain``. This is a
private property, however, and the rest of the code is to use the public
function ``$_SESSION['user']->get_domain()``.

The ``user`` Service
====================

``user.add`` Method
-------------------

Add a user account.

.. rubric:: Example Usage #1: Adding a Kolab User

A Kolab User (a groupware account) is, in a default installation, user type ID
number 1.

#.  Login to the API, using the
    :ref:`and-kolab-wap-api-system-authenticate-method`. An example login
    procedure is included in that section.

#.  Obtain the list of different user types, using the process outlined the
    example usage section of :ref:`and-kolab-wap-api-user_types-list-method`.

    In this example, we will be using user type ID 1, for a "Kolab User". Its
    type definition looks as follows:

    .. parsed-literal::

        {
                "status": "OK",
                "result": {
                    "list": {
                            "1": {
                                    "key": "kolab",
                                    "name": "Kolab User",
                                    "description": "A Kolab User",
                                    "attributes": {
                                            "fields": {
                                                    "objectclass": [
                                                            "inetorgperson",
                                                            "kolabinetorgperson",
                                                            "mailrecipient",
                                                            "organizationalperson",
                                                            "person",
                                                            "top"
                                                        ]
                                                },
                                            "form_fields": {
                                                    "alias": {
                                                            "type": "list",
                                                            "optional": true
                                                        },
                                                    "givenname":[],
                                                    "initials": {
                                                            "optional": true
                                                        },
                                                    "l": {
                                                            "optional": true
                                                        },
                                                    "mailalternateaddress": {
                                                            "type": "list",
                                                            "optional": true
                                                        },
                                                    "mailhost": {
                                                            "readonly": true
                                                        },
                                                    "mailquota": {
                                                            "type": "text-quota",
                                                            "optional": true
                                                        },
                                                    "mobile": {
                                                            "optional": true
                                                        },
                                                    "nsroledn": {
                                                            "type": "list",
                                                            "autocomplete": true,
                                                            "optional":true
                                                        },
                                                    "o": {
                                                            "optional": true
                                                        },
                                                    "ou": {
                                                            "type": "select",
                                                            "optional": true
                                                        },
                                                    "pager": {
                                                            "optional": true
                                                        },
                                                    "postalcode": {
                                                            "optional": true
                                                        },
                                                    "preferredlanguage": {
                                                            "type": "select"
                                                        },
                                                    "sn": [],
                                                    "street": {
                                                            "optional": true
                                                        },
                                                    "telephonenumber": {
                                                            "optional": true
                                                        },
                                                    "title": {
                                                            "optional": true
                                                        },
                                                    "userpassword": {
                                                            "optional": true
                                                        }
                                                },
                                            "auto_form_fields": {
                                                    "alias": {
                                                            "type": "list",
                                                            "optional": true,
                                                            "data": [
                                                                    "givenname",
                                                                    "preferredlanguage",
                                                                    "sn"
                                                                ]
                                                        },
                                                    "cn": {
                                                            "data": [
                                                                    "givenname",
                                                                    "sn"
                                                                ]
                                                        },
                                                    "displayname": {
                                                            "data": [
                                                                    "givenname",
                                                                    "sn"
                                                                ]
                                                        },
                                                    "mail": {
                                                            "data": [
                                                                    "givenname",
                                                                    "preferredlanguage",
                                                                    "sn"
                                                                ]
                                                        },
                                                    "uid": {
                                                            "data": [
                                                                    "givenname",
                                                                    "preferredlanguage",
                                                                    "sn"
                                                                ]
                                                        },
                                                    "userpassword": {
                                                            "optional": true
                                                        }
                                                }
                                        },
                                },
                            (...),
                            "count": 5
                    }
            }

    It is worth highlighting that only the following input is actually required:

    *   ``givenName``
    *   ``sn``

    All other values that are required, either by configured policy or by the
    LDAP schema, can be generated using this information (including ``uid`` and
    ``mail``).

    Most commonly, however, you will want to also set:

    *   ``userPassword``,
    *   ``preferredLanguage``

    Furthermore, some attributes that are generated may require additional form
    field input for the generating to properly function -- such as the
    ASCII-only ``uid`` attribute, where the input may contain utf-8 characters,
    and transliteration needs to be applied using the ``preferredlanguage``.

#.  Long story short, issue a call against the API ``user.add`` method with
    missing input data:

    >>> print api.request(
            'POST',
            'user.add',
            post = json.dumps(
                    {
                            'object_type': 'user',
                            'type_id': 1,
                            'givenname': 'Jane',
                            'sn': 'Doe'
                        },
                ),
            headers = headers
        )
    {
            "status": "ERROR",
            "code": 345,
            "reason": "Missing input value for preferredlanguage"
        }

#.  Complete the information required:

    >>> print api.request(
            'POST',
            'user.add',
            post = json.dumps(
                    {
                            'object_type': 'user',
                            'type_id': 1,
                            'givenname': 'Jane',
                            'sn': 'Doe',
                            'preferredlanguage': 'en_US'
                        },
                ),
            headers = headers
        )
    {
            "status": "OK",
            "result": {
                    "id": "62df3d81-8fef11e3-b80b888c-22d75d85",
                }
        }

To retrieve the resulting user information, including generated values for
attribute values and possibly policies that are being applied by LDAP or by
another process, use :ref:`and-kolab-wap-api-user-info-method` against the
``id`` in the response.

``user.delete`` Method
----------------------

The ``user.delete`` method takes exactly one parameter, and that is the ID of
the user object.

This ID can be either of two items:

    *   The persistent unique ID associated with the LDAP object regardless of
        its current position in the Directory Information Tree hierarchy,

    *   The current position in the Directory Information Tree hierarchy,
        otherwise known as the :term:`distinguished name`.

You can select a user by:

    *   Selecting the user from a list obtained using the
        :ref:`and-kolab-wap-api-users-list-method`,
    *   Finding exactly one user object (in order to be able to bail out if
        there are multiple search results) using the
        :ref:`and-kolab-wap-api-user-find-method`.

.. rubric:: Example Usage: Delete a User

    >>> print api.request(
            'POST',
            'user.delete',
            post = json.dumps(
                    {
                            'id': '62df3d81-8fef11e3-b80b888c-22d75d85'
                        }
                ),
            headers = headers
        )
    {"status":"OK","result":[]}

``user.edit`` Method
--------------------

``user.enable`` Method
----------------------

.. _and-kolab-wap-api-user-find-method:

``user.find`` Method
--------------------

Find exactly one user object, or none at all, but no more than one.

This method takes search criteria that help you narrow down what entry you are
looking for.

A successful search for a user would look as follows:

    >>> print api.request(
            'POST',
            'user.find',
            post = json.dumps(
                    {
                            'search': {
                                    'params': {
                                            'givenname': {
                                                    'type': 'exact',
                                                    'value': 'John',
                                                },
                                            'sn': {
                                                    'type': 'exact',
                                                    'value': 'Doe',
                                                },
                                        },
                                },
                            'search_operator': 'AND',
                            'sort_by': 'displayName'
                        }
                ),
            headers = headers
        )
    {
            "status": "OK",
            "result": {
                    "alias":["doe@example.org","j.doe@example.org"],
                    "givenname":"John",
                    "ou":"ou=people,dc=example,dc=org",
                    "preferredlanguage":"en_US",
                    "sn":"Doe",
                    "cn":"John Doe",
                    "displayname":"Doe, John",
                    "mail":"john.doe@example.org",
                    "uid":"doe",
                    "objectclass":[
                            "top",
                            "inetorgperson",
                            "kolabinetorgperson",
                            "mailrecipient",
                            "organizationalperson",
                            "person"
                        ],
                    "userpassword":"{SSHA}fd+aI995jN9n06KchY7TjgyZMgtDyuUESpiCKA==",
                    "mailhost":"localhost",
                    "mailquota":"1048576",
                    "id":"1f83d881-85c611e3-96ef888c-22d75d85",
                    "type_id":1
                }
        }

Should, however, multiple LDAP entries have an attribute value for ``givenname``
of "John", and ``sn`` of "Doe":

.. parsed-literal::

    { "status": "ERROR", "code": 923, "reason": "Multiple entries found" }

When zero, one or more results are expected, use the
:ref:`and-kolab-wap-api-users-search-method`.

.. _and-kolab-wap-api-user-info-method:

``user.info`` Method
--------------------

>>> print api.request(
        'GET',
        'user.info',
        get = { 'id': '62df3d81-8fef11e3-b80b888c-22d75d85' },
        headers = headers
    )

or using instead:

>>> print api.request(
        'GET',
        'user.info',
        get = { 'id': 'uid=doe2,ou=People,dc=example,dc=org' },
        headers = headers
    )

.. parsed-literal::

    {
            "status": "OK",
            "result": {
                    "givenname": "Jane",
                    (...)
                }
        }
``user.search`` Method
----------------------

The ``user_types`` Service
==========================

The user_types service ...

.. _and-kolab-wap-api-user_types-list-method:

``user_types.list`` Method
--------------------------

Storage Format for an Object Type
=================================

The object type definitions are backed by database entries, containing the
following attributes per object type:

**id**

    Of type INT, this attribute is automatically assigned by the database
    backend, unless specifically supplied on insert.

**key**

    Of type VARCHAR(16), the key attribute is to hold a machine readable name.

**name**

    Of type VARCHAR(128), the name attribute is to be the human-readable name
    for the object type.

**description**

    Of type VARCHAR(256), the description attribute holds the description for
    the object type.

**attributes**

    Of type TEXT, the attributes contains a serialized JSON object with the
    information needed for the API and client interface to build queries and
    forms for the object type.

.. _and-kolab-wap-api-attributes-value-format:

The ``attributes`` Attribute Value Format
=========================================

The structure of the ``attributes`` attribute value to an object type definition
is as follows.

.. code-block:: python

    attributes = {
            "<form_field_type>": {
                    "<form_field_name>": {
                                ['data': {
                                        "<form_field_name>"[,
                                        "<form_field_name>"[,
                                        "<form_field_name>"],]
                                    },]
                                ['type' => "text|select|multiselect|...",]
                                ['values': {
                                        "<value1>"[,
                                        "<value2>"[,
                                        "<value3>"],]
                                    },]
                        }
                }
        }

The ``attributes`` attribute to an object type definition entry holds an array
with any or all of the following ``<form_field_type>`` keys:

**auto_form_fields**

    The ``auto_form_fields`` key holds a list of form field names -- that
    correspond with the object's attribute names -- for which the value is to be
    generated automatically, using an API call to the ``form_value.generate``
    service method.

    The key for each key-value pair indicates the form field name (see above as
    ``form_field_name``) for which the value is to be generated automatically.

    Each of the keys corresponds with an object attribute name, such as ``uid``
    or ``displayname``, and its value is an array containing the names of the
    form fields of which the value is to be submitted as part of the
    ``form_value.generate`` API call.

    .. rubric:: Example #1: Composing a User's ``displayName`` Attribute Value

    Provided the user type's ``auto_form_fields`` contains an array key of
    ``displayname``, the array value for this key could look as follows:

    .. parsed-literal::

        attributes = {
                'auto_form_fields': {
                        'displayname': {
                                'data': {
                                        'givenname',
                                        'sn'
                                    },
                            },
                        (...)
                    },
                (...)
            }

    This indicates to the client application that the value for a form field
    named ``displayname`` is to be automatically generated using other
    information provided in the form.

    In order to generate the value for the ``displayname`` form field, it is
    indicated that, using the ``data`` list, the values of form fields
    ``givenname`` and ``sn`` should be used.

    In a webclient, this would means attaching a JavaScript ``onchange()`` event
    to the form elements for the ``givenname`` and ``sn`` attributes, so that
    when the user changes the value for either of these form fields, such event
    can be handled.

    This ``onchange()`` event should submit a call to ``form_value.generate``,
    with the form field values for the ``givenname`` and ``sn`` form fields
    included in the submission.

    The result of the ``form_value.generate`` call will include a new value for
    the ``displayname`` form field.

    .. rubric:: Example #2: Composing a User's ``uid`` Attribute Value

    Provided the user type's ``auto_form_fields`` contains an array key of
    ``uid``, the array value for this key could look as follows:

    .. parsed-literal::

        attributes = {
                'auto_form_fields': {
                        'uid': {
                                'data': {
                                        'givenname',
                                        'preferredlanguage',
                                        'sn'
                                    },
                            },
                        (...)
                    },
                (...)
            }

    This indicates to the client application that the value for a form field
    named ``uid`` is to be automatically generated using other information
    provided in the form.

    In order to generate the value for the ``uid`` form field, it is indicated
    that, using the ``data`` list, the values of form fields ``givenname``,
    ``preferredlanguage`` and ``sn`` should be used.

    The use of ``preferredlanguage`` is important, as ``uid`` attributes do not
    allow non-ASCII characters, but many user's names contain non-ASCII
    characters. The process of substituting non-ASCII characters to the ASCII
    representation is called transliteration. The recipient policy documentation
    illustrates the process of :ref:`admin_rcpt-policy_locale-transliteration`.

    In a webclient, this would means attaching a JavaScript ``onchange()`` event
    to the form elements for the ``givenname`` and ``sn`` attributes, so that
    when the user changes the value for either of these form fields, such event
    can be handled.

    This ``onchange()`` event should submit a call to ``form_value.generate``,
    with the form field values for the ``givenname`` and ``sn`` form fields
    included in the submission.

    The result of the ``form_value.generate`` call will include a new value for
    the ``displayname`` form field.

**form_fields**

    The form_fields key holds an array of form fields that require user input.

    The key name for each key => value pair indicates the form field name for
    which the value is to be supplied by the user.

    Because some attributes can be multi-valued, or have a limited list of
    options, each defined form field in form_fields can hold an array with
    additional key-value pairs illustrating the type of form field that should
    be used, and what format to expect the result value in.

    Additional Information in form_fields

    **autocomplete**

        A form field of type list can be made to use automatic completion of
        entries the user starts typing in.

        Examples of autocompletion for list form fields include
        ``uniqueMember`` (members for groups) and ``nsRoleDN`` (roles for a
        user).

    **maxlength**

        For a form field of type text or type list, this value holds the maximum
        length for a given item.

    **type**

        The type is to indicate the type of form field. Options include;

        **text**

            This is a regular input field of type text, and the default type of
            a form field.

            Additional parameters for a text form field include maxlength.

        **list**

            A form field of type list is expecting a list of text input values.

            A client web interface could choose to display a textarea with the
            instructions to supply one item per line, or more advanced (better)
            equivalents, such as an add/delete widget.

            A client command-line interface could choose to prompt for input
            values until an empty value is supplied.

            Additional parameters for a list form field include maxlength,
            which holds the maximum length of each text value in the list.

            .. NOTE::

                You can only use this form field type for attributes that allow
                multiple values -- otherwise use type **text**.

        **multiselect**

            This form field is a select list, where multiple options may be
            selected (as opposed to a select list, where only one option may be
            selected).

            If the values are not specified already, using the **values** key to
            the attribute specification, a client interface MUST consult the
            ``form_value.list_options`` API call for option values, as this is
            also the list that input values are checked against.

            .. NOTE::

                You can only use this form field type for attributes that allow
                multiple values -- otherwise use type **select**.

            .. seealso::

                *   :ref:`and-kolab-wap-api-form_value-list_options`

        **select**

            This form field is a selection list, of which one option may be
            selected.

            If the values are not specified already, using the **values** key to
            the attribute specification, a client interface MUST consult the
            ``form_value.list_options`` API call for option values, as this is
            also the list that input values are checked against.

    **value_source**

        The source of values for a list, multiselect or select type.

    **values**

        A static, pre-defined list of values for a list, multiselect or select type.

**fields**

    The fields key holds an array of form fields and values for said form
    fields, that are static.

    One example of such form fields is ``objectclass``.

The ``users`` Service
=====================

The users service ...

``users.list`` Method
---------------------

Use ``users.list`` to display paginated lists of users.

.. parsed-literal::

    >>> print api.request(
            'GET',
            'users.list',
            headers = headers
        )

    {
            "status": "OK",
            "result": {
                    "list": {
                            "uid=doe,ou=People,dc=example,dc=org": {
                                    "uid": "doe"
                                },
                            "uid=doe2,ou=People,dc=example,dc=org": {
                                    "uid": "doe2"
                                }
                        },
                    "count": 2
                }
        }

``users.search`` Method
-----------------------
