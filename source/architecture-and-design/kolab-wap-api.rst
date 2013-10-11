.. _and-kolab_wap_api:

======================================
Kolab Web Administration Panel and API
======================================

The web administration panel comes with an API in order to allow different,
third-party interfaces, as well as the Kolab tool-chain to Kolab Groupware, to
execute tasks of an administrative nature.

The API uses JSON to exchange information with the API client.

The calls to the Web API are made to a service handler, for its methods handle
the request. A call therefore looks as follows:

    **<service>.<method>**

which is a location beneath the base URL for the API.

Suppose https://kolab-admin.example.org/api/ is the API base URL, then a call to
service method **system.authenticate** would be a POST HTTP/1.1 request to
https://kolab-admin.example.org/api/system.authenticate.

HTTP Method Convention
======================

Two HTTP methods are used: GET and POST. The GET method is generally(!) used for
read-only operations, whereas the POST method is used for write operations.

For GET requests, the parameters (the payload) are appended to the URI
requested, https://kolab-admin.example.org/api/domain.info?domain=example.org.

.. NOTE::

    This restricts GET requests to specifying key-value pairs of payload
    information only, even though a GET parameter key can be specified more then
    once, creating a list of values.

Some read-only operations, such as user.find_by_attributes require the request
to pass along multiple attributes with, potentially, multiple search parameters.
These types read-only requests are the exception to the rule of using GET for
read-only requests, and use POST instead.

For POST requests, the payload is a JSON-encoded dictionary (array) of parameter
keys and values. Only strings are allowed as keys. Values for the payload may
contain lists, strings, dictionaries (arrays), integers, floats, etc.

Service and Method Naming Convention
====================================

In another rule-of-thumb we outline the naming convention for services and
methods.

Service names consist of an object name either in singular or plural form. The
singular form depicts actions are placed against a single instance of an object,
such as **object.add**, or at most one result entry is expected, such as
**object.find**.

The plural form depicts actions that are placed against multiple instances of an
object, such as **objects.list** or **objects.search**, and expect zero more
result entries to be returned.

Method names often imply an action is placed against one or more objects in one
request. Certain actions may be confusing though. For these we have the
following rules;

*   Finding an object

    The method find is always executed against the service with the singular
    form of the object name. The target of calling a find method is to obtain
    exactly zero or one instance of an object. The method should fail if the
    result set contains any number of objects not zero or one.

    Example finding user *John Doe <john.doe@example.org>*::

        >>> print api.get('user.find', '{"mail": "john.doe@example.org"})
        '{"status":"OK","result":(...)}'

*   Searching for objects

    The method search is always executed against the service with the plural
    form of the object name. The target of calling a search method is to obtain
    all matches, if any. The method should return any result set containing zero
    or more results.

    Example searching for user *John Doe <john.doe@example.org>*::

        >>> print api.get('users.search', '{"givenname":"John"}')
        '{"status":"OK","result":(...)}'

*   Listing objects

    A list result set contains the following components:

        #.  status

        #.  result

            #.  **count** (integer)

            #.  **list** (dictionary)

                #.  entry id

                    #. additional entry attributes

                #.  entry id

                    #. additional entry attributes

    Example listing domains::

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

The reponse to a successful request that is expected to return a list of zero, one or more items, such as list and search methods, includes a result layout as follows:

.. parsed-literal::

    {
        "status": "OK",
        "result": {
            "list": (...),
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

domain

    Domain operations, such as obtaining information for them, or adding, editing and deleting a domain.

    further description

domains

    short description

    further description

form_value

    Service handler for form values. Can be used to generate form values (such as passwords for new users), and compose form values for form fields for which the value is to be composed using existing field values from other form fields.

    further description

group

    short description

    further description

groups

    short description

    further description

group_types

    short description

    further description

resource

    short description

    further description

resources

    short description

    further description

resource_types

    short description

    further description

role

    short description

    further description

roles

    short description

    further description

role_types

    short description

    further description

system

    short description

    further description

user

    short description

    further description

users

    short description

    further description

user_types

    short description

    further description

17.3.5. The domain Service
The domain service makes available actions against a single domain entity, for example 'add' or 'delete'. For actions against multiple domain entities, such as 'list' and 'search', see Section 17.3.6, “The domains Service”.
17.3.5.1. domain.add Method
Depending on the technology used, quite the variety of things may need to happen when adding a domain to a Kolab Groupware deployment. This is therefore a responsbility for the API rather then the client.
Parameters
The following parameters MUST be specified with the domain.add API call:

    associateddomain
    One or more domain name spaces to be added.
    If more than one domain name space is specified (i.e. associateddomain consists of a list or array), the remaining domain name spaces are added as aliases.

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
Example 17.1. Example domain.add API call in Python
The following is an example of a call to API service method domain.add:

import json
import httplib
import sys

from pykolab import utils

API_HOSTNAME = "kolab-admin.example.org"
API_PORT = "443"
API_SCHEME = "https"
API_BASE = "/api"

username = utils.ask_question("Login")
password = utils.ask_question("Password", password=True)

params = json.dumps({
                'username': username,
                'password': password
            })

if API_SCHEME == "http":
    conn = httplib.HTTPConnection(API_HOSTNAME, API_PORT)
elif API_SCHEME == "https":
    conn = httplib.HTTPSConnection(API_HOSTNAME, API_PORT)

conn.connect()
conn.request('POST', "%s/system.authenticate" %(API_BASE), params)
try:
    response_data = json.loads(conn.getresponse().read())
except ValueError, e:
    print e
    sys.exit(1)

# Check status here, using response_data['status']

if response_data.has_key('session_token'):
    session_id = response_data['session_token']

headers = { 'X-Session-Token': session_id }

params = json.dumps({
                'domain': utils.ask_question("Domain")
            })

conn.request('POST', "%s/domain.add" %(API_BASE), params, headers)
try:
    response_data = json.loads(conn.getresponse().read())
except ValueError, e:
    print e
    sys.exit(1)


Response

{
    "status":"OK"
}

Server-side Implementation Details
On the server-side, when a domain is added, an entry is added to the default authentication and authorization database, as configured through the setting auth_mechanism in the [kolab] section of /etc/kolab/kolab.conf.
The authentication database technology referred to has the necessary settings to determine how a new domain can be added. The related settings for LDAP are domain_base_dn, domain_scope, domain_filter, domain_name_attribute (used for the RDN to compose the DN).
After checking the domain does not already exist (using administrative credentials), the domain is added using the credentials for the logged in user. This is an access control verification step only; the logged in user must have 'add' rights on the Domain Base DN.
Additional steps when adding a (primary) domain name space is to create the databases and populate the root dn.
17.3.5.1.1. TODO
The following is a list of things that still need to be designed and/or implemented.

    Adding an alias for a domain name space, such that "company.nl" can be specified as an alias domain name space for "company.com".
    Designating an "owner" of a domain name space, possibly through nesting (LDAP) or assigning a owner_id (SQL).
    Determining access to a domain name space for any particular set of credentials.
    It seems, for LDAP, the server-side getEffectiveRights control is not supported. An alternative may be to probe the root dn for the domain name space using the current session bind credentials, but this may not scale. Exceptions to the probing would need to be established to make sure the known DNs are not subjected to the extensive operation(s) (such as cn=Directory Manager).
    Once a domain is added, we have to implement access control on top of it.

17.3.5.2. domain.delete Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.5.3. domain.edit Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.6. The domains Service
17.3.6.1. domains.list Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
The response consists of the following two toplevel keys, contained within a JSON object:

    status
    result

The result JSON object contains the following two primary keys:

    list
    The value represents the list of results. Languages in use today allow the counting of the list's keys, which should get a client application to be able to estimate the number of results contained within the list.
    count
    The value represents the total number of results, to allow for pagination on the client.

17.3.7. The form_value Service
17.3.7.1. form_value.generate Method
This API call allows access to routines that generate attribute values. It accepts data containing the names and values of other attribute values as input, which can be used to generate the new attribute value requested.
Parameters
The form_value.generate API call accepts the following parameters:

    attribute
    The name of the attribute to generate the new value for.
    data
    An array with key => value pairs containing the attribute name (key) and attribute value (value) to use to generate the new value for the attribute supplied in attribute.
    This parameter is required for certain attributes, such as cn, but not for other attributes, such as userPassword.
    user_type_id
    An optional parameter to indicate to the API that the formation policy for users should be used.
    Supply an integer indicating the user type to use policies for that user type.
    Supply a boolean True to use a policy for users, allowing the use of policies not specific to any user type.
    Supply a boolean False to reject the use of any user policy.
    The default for this parameter is False.
    group_type_id
    An optional parameter to indicate to the API that the formation policy for groups should be used.
    Supply an integer indicating the group type to use policies for that group type.
    Supply a boolean True to use a policy for groups, allowing the use of policies not specific to any group type.
    Supply a boolean False to reject the use of any group policy.
    The default for this parameter is False.

Important
The API call does not allow both the user_type_id and group_type_id to;

    both be boolean False,
    both be boolean True,
    both be an integer reference to each respective type ID.

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
A client could choose to have a user's password generated by the API.
Example 17.2. Generate the User Password with the API

result = request('POST', 'form_value.generate_userpassword')
print result['userpassword']


Response

{
        "status": "OK",
        "result": {
                "password": "3SQLAdcW_KZL5vO"
            }
    }

17.3.7.2. form_value.list_options Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.7.3. form_value.validate Method
para
This API call allows access to routines that generate attribute values. It accepts data containing the names and values of other attribute values as input, which can be used to generate the new attribute value requested.
Parameters
The form_value.validate API call accepts the following parameters:

    attribute
    The name of the attribute to validate the value for.
    data
    The data to validate.
    user_type_id
    An optional parameter to indicate to the API that the validation policy for users should be used.
    Supply an integer indicating the user type to use policies for that user type.
    Supply a boolean True to use a policy for users, allowing the use of policies not specific to any user type.
    Supply a boolean False to reject the use of any user policy.
    The default for this parameter is False.
    group_type_id
    An optional parameter to indicate to the API that the validation policy for groups should be used.
    Supply an integer indicating the group type to use policies for that group type.
    Supply a boolean True to use a policy for groups, allowing the use of policies not specific to any group type.
    Supply a boolean False to reject the use of any group policy.
    The default for this parameter is False.

Important
The API call does not allow both the user_type_id and group_type_id to;

    both be boolean False,
    both be boolean True,
    both be an integer reference to each respective type ID.

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.8. The group Service
17.3.8.1. group.info Method
para
Parameters
The following parameters are required:

    group
    The group to return information for.

    Currently, we only allow the group to be searched by the email address associated with the group.

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Response

{
        "status": "OK",
        "result": {
                "cn": "sysadmin-main",
                "objectclass": [
                        "top",
                        "groupofuniquenames",
                        "kolabgroupofuniquenames",
                        "posixgroup"
                    ],
                "gidnumber": "666",
                "uniquemember": [
                        "uid=vanmeeuwen,ou=people,dc=klab,dc=cc",
                        "uid=adomaitis,ou=people,dc=klab,dc=cc"
                    ],
                "mail":"sysadmin-main@klab.cc",
                "type_id":3,
                "id":"adf3ce81-088311e1-98bcc2f1-b2ae40b4"
            }
    }

17.3.8.2. group.members_list Method
The group.members_list service method lists the members of a group.
Parameters
The following parameters are required:

    group
    The group to list the members for.

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
The response consists of the following two toplevel keys, contained within a JSON object:

    status
    result

The result JSON object contains the following two primary keys:

    list
    The value represents the list of results. Languages in use today allow the counting of the list's keys, which should get a client application to be able to estimate the number of results contained within the list.
    count
    The value represents the total number of results, to allow for pagination on the client.

17.3.9. The system Service
17.3.9.1. system.authenticate Method
Successful authentication is a prerequisite in order to be able to execute any other action against the system. Upon success, the system.authenticate API call returns a session token that MUST be supplied with all subsequent requests for the session, through the HTTP header X-Session-Token.
Parameters
The following parameters MUST be supplied with a call to system.authenticate:

    username
    The username.
    Note
    Currently, only the 'entryDN' and 'mail' attribute values are allowed as the username for an authentication request.
    See also: Section 9.1, “The User Supplied Login”
    password
    para

The following parameters MAY be supplied with a call to system.authenticate:

    domain
    With supplying the domain parameter in an authentication request,

HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
Example 17.3. Example system.authenticate API call in Python
The following is an example of authentication against the API in Python:

import json
import httplib
import sys

from pykolab import utils

API_HOSTNAME = "kolab-admin.example.org"
API_PORT = "443"
API_SCHEME = "https"
API_BASE = "/api"

username = utils.ask_question("Login")
password = utils.ask_question("Password", password=True)

params = json.dumps({
                'username': username,
                'password': password
            })

if API_SCHEME == "http":
    conn = httplib.HTTPConnection(API_HOSTNAME, API_PORT)
elif API_SCHEME == "https":
    conn = httplib.HTTPSConnection(API_HOSTNAME, API_PORT)

conn.connect()
conn.request('POST', "%s/system.authenticate" %(API_BASE), params)
try:
    response_data = json.loads(conn.getresponse().read())
except ValueError, e:
    print e
    sys.exit(1)

# Check status here, using response_data['status']

if response_data.has_key('result'):
    if response_data['result'].has_key('session_token'):
        session_id = response_data['result']['session_token']


Response
The following is a response to a successful authentication request (with inserted line-breaks for readability):

{
    "status":"OK",
    "result": {
        "user":"cn=Directory Manager",
        "domain":"klab.cc",
        "session_token":"ndgu4ennb6t51i4b0dvkulhvk6"
    }
}

The following is a reponse to an unsuccessful call to system.authenticate (with inserted line-breaks for readability):

{
    "status":"ERROR",
    "code":500,
    "reason":"Internal error"
}

17.3.9.2. system.capabilities Method
For all service handlers registered, a method capabilities can be executed listing the methods available and access to them. The system.capabilities API call lists all of the registered service handlers' methods and access.
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.9.3. system.get_domain Method
The get_domain method returns the currently selected working domain.
Parameters
No parameters are available for this method.
HTTP Method(s)
GET, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
Example 17.4. Example system.get_domain API call in Python
The following is an example of a call to API service method system.get_domain:

import json
import httplib
import sys

from pykolab import utils

API_HOSTNAME = "kolab-admin.example.org"
API_PORT = "443"
API_SCHEME = "https"
API_BASE = "/api"

username = utils.ask_question("Login")
password = utils.ask_question("Password", password=True)

params = json.dumps({
                'username': username,
                'password': password
            })

if API_SCHEME == "http":
    conn = httplib.HTTPConnection(API_HOSTNAME, API_PORT)
elif API_SCHEME == "https":
    conn = httplib.HTTPSConnection(API_HOSTNAME, API_PORT)

conn.connect()
conn.request('POST', "%s/system.authenticate" %(API_BASE), params)
try:
    response_data = json.loads(conn.getresponse().read())
except ValueError, e:
    print e
    sys.exit(1)

# Check status here, using response_data['status']

if response_data.has_key('session_token'):
    session_id = response_data['session_token']

headers = { 'X-Session-Token': session_id }

conn.request('GET', "%s/system.get_domain" %(API_BASE), params, headers)
try:
    response_data = json.loads(conn.getresponse().read())
except ValueError, e:
    print e
    sys.exit(1)


Response

{
    "status":"OK",
    "result": {
        "domain":"example.org"
    }
}

17.3.9.4. system.quit Method
The quit method ends the session.
Parameters
params
HTTP Method(s)
GET, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.9.5. system.select_domain Method
Select the domain supplied as the current working domain. By default, users are logged in and have access to what they are authorized for in their own domain name space only. Certain users, such as cn=Directory Manager, have access to all domains. This API call allows such users to select the domain name space they are currently working on.
Parameters
params: domain name
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
Server-side Implementation Details
On the server-side, when system.select_domain is called successfully, the selected domain is stored in $_SESSION['user']->current_domain. This is a private property, however, and the rest of the code is to use the public function $_SESSION['user']->get_domain():
17.3.10. The user Service
The user service ...
17.3.10.1. user.add Method
Parameters
A required parameter is the user_type_id (obtain from user_types.list). Further required parameters are the keys of the form_fields array for the user type with that id.
Example 17.5. Example set of required parameters
A simple user type could look as follows:

$id = 1;
$key = 'simple';
$description = 'A simple user type';
$attributes = Array(
        'auto_form_fields' => Array(),
        'form_fields' => Array(
                'cn' => Array(),
                'mail' => Array(),
            ),
        'fields' => Array(
                'objectclass' => Array(
                        'top'
                        'inetorgperson'
                    ),
            ),
    );

Additional required parameters for this user type (with ID 1) would include cn and mail.

Note
Note that keys of the array auto_form_fields may be submitted, but are honored only if admin_auto_fields_rw is set to true or 1. If this setting is not specified (the default), form field values are re-generated. The client interface should have disabled input for these form fields.
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para

headers = { 'X-Session-Token': <token> }
params = { 'cn': 'John Doe', 'mail': 'john.doe@example.org' }
request('POST', 'user.add', params, headers)

Response
para
17.3.10.2. user.delete Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.10.3. user.disable Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.10.4. user.edit Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.10.5. user.enable Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.10.6. user.info Method
para
Parameters
The following parameter(s) MUST be supplied with a call to user.info:

    user
    A string allowing the user the information needs to be obtained for to be uniquely identified.
    Note
    Currently, only the 'entryDN' and 'mail' attribute values are allowed as the username for an authentication request.

HTTP Method(s)
GET, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
The response to a user.info API call contains all information to a particular entry in the authentication and authorization database technology, that can be obtained using the bind credentials for the session user.
The output is normalized for abstraction, and looks as follows, with added line-breaks for clarity:

{
    u'status': 'OK',
    u'uid=vanmeeuwen,ou=People,dc=klab,dc=cc': {
            u'mailalternateaddress': [
                    u'vanmeeuwen@klab.cc',
                    u'j.vanmeeuwen@klab.cc'
                ],
            u'displayname': u'van Meeuwen, Jeroen',
            u'uid': u'vanmeeuwen',
            u'mailhost': u'imap.klab.cc',
            u'objectclass': [
                    u'top',
                    u'person',
                    u'inetOrgPerson',
                    u'organizationalPerson',
                    u'mailrecipient',
                    u'kolabInetOrgPerson',
                    u'posixAccount'
                ],
            u'loginshell': u'/bin/bash',
            u'userpassword': u'{SSHA}yGEm7rdOSrTDCd/h4F5q1fx5GTvSynHU',
            u'uidnumber': u'500',
            u'modifiersname': u'cn=directory manager',
            u'modifytimestamp': u'20111206153131Z',
            u'preferredlanguage': u'en_US',
            u'gidnumber': u'500',
            u'createtimestamp': u'20111119171559Z',
            u'sn': u'van Meeuwen',
            u'homedirectory': u'/home/vanmeeuwen',
            u'mail': u'jeroen.vanmeeuwen@klab.cc',
            u'givenname': u'Jeroen',
            u'creatorsname': u'cn=directory manager',
            u'cn': u'Jeroen van Meeuwen'
        }
}

17.3.10.7. user.search Method
para
Parameters
params
HTTP Method(s)
GET, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.11. The user_types Service
The user_types service ...
17.3.11.1. user_types.add Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.11.2. user_types.delete Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.11.3. user_types.edit Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
17.3.11.4. user_types.list Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
The response consists of the following two toplevel keys, contained within a JSON object:

    status
    result

The result JSON object contains the following two primary keys:

    list
    The value represents the list of results. Languages in use today allow the counting of the list's keys, which should get a client application to be able to estimate the number of results contained within the list.
    count
    The value represents the total number of results, to allow for pagination on the client.

17.3.11.5. Storage Format for user_type
The user types are backed by database entries, containing the following attributes per user type:

    id
    Of type INT, this attribute is automatically assigned by the database backend, unless specifically supplied on insert.
    key
    Of type VARCHAR(16), the key attribute is to hold a machine readable name.
    name
    Of type VARCHAR(128), the name attribute is to be the human-readable name for the user type.
    description
    Of type VARCHAR(256), the description attribute holds the description for the user type.
    attributes
    Of type TEXT, the attributes contains a serialized JSON object with the information needed for the API and client interface to build queries and forms for the user type.

17.3.11.5.1. The attributes Attribute Value Format
The structure of the attributes attribute value is:

Array(
        "<form_field_type>" => Array(
                "<form_field_name>" => Array(
                            ['data' => Array(
                                    "<form_field_name>"[,
                                    "<form_field_name>"[,
                                    "<form_field_name>"],]
                                ),]
                            ['type' => "text|select|multiselect|...",]
                            ['values' => Array(
                                    "<value1>"[,
                                    "<value1>"[,
                                    "<value1>"],]
                                ),]
                    )
            )
    )

The attributes attribute to a user_type entry holds an array with any or all of the following <form_field_type> keys:

    auto_form_fields
    The auto_form_fields key holds an array of form fields that correspond with attributes for which the value is to be generated automatically, using an API call.
    The key name for each key => value pair indicates the form field name for which the value is to be generated automatically.
    Each array key corresponds with a user attribute name, and it's value is an array containing the name of the form fields for which the value to submit as part of the API call.
    Example 17.6. A User's displayname
    Provided the user type's auto_form_fields contains an array key of displayname, the array value for this key could look as follows:

    Array(
            'auto_form_fields' => Array(
                    'displayname' => Array(
                            'data' => Array(
                                    'givenname',
                                    'sn'
                                ),
                        ),
                    (...)
                ),
            (...)
        );

    This indicates to the client that a form field named 'displayname' is to be populated with the information contained within the form fields named 'givenname' and 'sn'.
    If the client is capable of doing so, it should also update the form field named 'displayname' after the values for any of the form fields named 'givenname' or 'sn' have been changed.

    With a JSON object payload containing the values of the form fields for which the names are contained within the 'data' key, if any, the client should submit a POST request on change of these form fields, and will be returned the new value for the automatically generated form field.
    form_fields
    The form_fields key holds an array of form fields that require user input.
    The key name for each key => value pair indicates the form field name for which the value is to be supplied by the user.
    Because some attributes can be multi-valued, or have a limited list of options, each defined form field in form_fields can hold an array with additional key => value pairs illustrating the type of form field that should be used, and what format to expect the result value in.
    Additional Information in form_fields
        maxlength
        For a form field of type text or type list, this value holds the maximum length for a given item.
        type
        The type is to indicate the type of form field. Options include;
            text
            This is a regular input field of type text.
            This is the default.
            Additional parameters for a text form field include maxlength.
            list
            A form field of type list is expecting a list of text input values.
            A client web interface could choose to display a textarea with the instructions to supply one item per line, or more advanced (better) equivalents, such as an add/delete widget.
            A client command-line interface could choose to prompt for input values until an empty value is supplied.
            Additional parameters for a list form field include maxlength, which holds the maximum length of each text value in the list.
            multiselect
            This form field is a select list, where multiple options may be selected (as opposed to a select list, where only one option may be selected).
            A client interface MUST consult the form_value.list_options API call for options, described in Section 17.3.7.2, “form_value.list_options Method”.
            select
            This form field is a selection list, of which one option may be selected.
            A client interface MUST consult the form_value.list_options API call for options, described in Section 17.3.7.2, “form_value.list_options Method”.
        value_source
        para
        values
        para
    fields
    The fields key holds an array of form fields and values for said form fields, that are static. One example of such form fields is objectclass.

17.3.12. The users Service
The users service ...
17.3.12.1. users.list Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
The response consists of the following two toplevel keys, contained within a JSON object:

    status
    result

The result JSON object contains the following two primary keys:

    list
    The value represents the list of results. Languages in use today allow the counting of the list's keys, which should get a client application to be able to estimate the number of results contained within the list.
    count
    The value represents the total number of results, to allow for pagination on the client.

17.3.12.2. users.search Method
para
Parameters
params
HTTP Method(s)
POST, with an X-Session-Token HTTP/1.1 header.
Example Client Implementation
para
Response
para
