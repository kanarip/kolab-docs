===================================
Hosted Kolab Customer Control Panel
===================================

Signup, Confirm, Payment
========================

The following diagram is a basic overview of the process for a type of account
that is known as an account for an "Individual User".

.. graphviz::

    digraph {
            subgraph cluster_backend {
                    label="Backend Process";
                    "Invoice" [shape=diamond];
                };

            subgraph cluster_frontend {
                    label="User-facing Process";

                    "Signup" -> "Confirm" [color=red];
                    "Confirm" -> "Invoice" [color=blue];
                    "Confirm" -> "Payment" [color=red];
                    "Invoice" -> "Payment" [dir=none,color=red];
                };

            "Activation" [shape=diamond];

            "Suspension" [shape=diamond];

            "Payment" -> "Activation" [color=green];

            "Confirm" -> "Suspension" [color=red];
        }

The following diagram is a basic overview of the process for a type of account
that is known as a "Group Manager Account", where customers register their own
domain name space(s) and create accounts in that domain.

.. graphviz::

    digraph {
            subgraph cluster_frontend {
                    label="User-facing Process";

                    "Signup" -> "Confirm" [color=red];
                    "Confirm" -> "Ownership" [color=red];

                    "Ownership" -> "Account Management" [color=red];
                    "Account Management" -> "Account Activation" [dir=none,color=blue];
                };

            "Account Activation" [shape=diamond];
            "Domain Activation" [shape=diamond];

            "Suspension" [shape=diamond];

            "Ownership" -> "Domain Activation" [dir=none,color=blue];

            "Ownership" -> "Suspension" [color=red];
        }

.. NOTE:: Important Notes

    #.  The confirmation of the domain ownership activates the domain.
    #.  Accounts created in the domain are active immediately, all options
        included.

        This facilitates the migration of user data.

.. IMPORTANT::

    The invoices for group manager accounts is created as part of a batch
    process executed on the backend.

    This allows a group manager to first add one or more mailboxes and
    subscriptions to their account, before an invoice is generated.

Configuration
=============

The main object in the HKCCP configuration are the *account types*.

They include the following settings:

**user_type_id** [int]

    The ``user_type_id`` is to correspond with a type ID obtained using a
    ``user_types.list`` WAP API call.

    The user type that corresponds with the configured ID defines (in part) what
    the form for signup will look like.

    .. NOTE::

        *   Form fields marked as optional in the user type definition are
            skipped.

        *   Some form fields are forcefully skipped, and/or re-inserted (such as
            ``mailquota``), possibly using a different name for the form field
            (``quota`` for ``mailquota``, for example).

    For an account type "user account" to register for an email address in the
    primary hosted domain for example, the user type is set to '5', which
    results in the following fields being requested input for:

        #.  First Name (``givenname``)
        #.  Family Name (``sn``)
        #.  Country (``c``)
        #.  Existing Email Address (``mailalternateaddress``)
        #.  "Password" and "Confirm Password" (``userPassword``)
        #.  Desired Email Address (``uid`` and ``mail``)

            This form field is morphed through setting the ``email``
            configuration item for the account type to ``true``.

**name** [string]

    The label used in localization for the name of the account type.

**description** [string]

    The label used in localization for the description of the account type.

**email** [boolean]

    Setting ``email`` to ``true`` indicates this user type is to register for an
    email address.

    The form will morph the ``uid`` field into a ``uid`` form field and an
    appended select list of available domains. Upon submission of the form, the
    ``uid`` attribute value is extracted directly from the corresponding form
    field, and the ``mail`` attribute value is composed from the ``uid`` and the
    selected domain name space.

**signup** [boolean]

    Setting ``signup`` to ``true`` makes this account type available to the
    signup form.

**minlength** [int]

**workflow** [list of strings]

**suspended_role** [string]

Example Configuration of Account Types
--------------------------------------

.. graphviz::

    digraph {

            subgraph cluster_options {
                    label = "Options";
                    "Account";
                    "Quota";
                    "ActiveSync";
                    "Custom Domain";
                }

            subgraph cluster_billing_account_types {
                    label = "Billing Account Types";
                    "User";
                    "Domain";
                }

            subgraph cluster_account_types {
                    label = "Account Types";
                    "Domain User";
                }

            subgraph cluster_paymentplans {
                    label = "Payment Plans";
                    "Monthly";
                    "Quarterly User";
                    "Quarterly Domain";
                    "Yearly User";
                    "Yearly Domain";
                    "Biennial";
                }

            "Account", "Quota", "ActiveSync" -> "User";
            "Custom Domain" -> "Domain";
            "Quota", "ActiveSync" -> "Domain User";
            "Domain User" -> "Domain" [dir=none];

            "Account" -> "Account Setup Costs";
            "Domain" -> "Domain Setup Costs";

            "Account Setup Costs" -> "Monthly", "Quarterly User", "Yearly User";
            "Domain Setup Costs" -> "Monthly", "Quarterly Domain", "Yearly Domain", "Biennial";

            "Monthly", "Quarterly User", "Yearly User" -> "User";
            "Monthly", "Quarterly Domain", "Yearly Domain", "Biennial" -> "Domain";
        }

Cost Factors
============

Cost factors included in an invoice, on per item basis include:

**Account(s)**

**Per Account Options** (subscriptions)

    Account options and subscriptions take two different forms: The option is
    either a boolean (on / off), or an integer (quantity / volume).

    The subscriptions should hold;

        *   a start date (start charging for it),
        *   an end date (stop charging),
        *   an expiry date (paid for up to this day)

    Using this information, the following calculations can be made:

        *   What was the list price of items in the previous payment period?
        *   What is the list price of items in the current payment period?
        *   What items changed and when (for value increases and accreditation)?

**Setup Costs**

**Rebates**

    Rebates are of a one-time only nature, and apply to either any current
    **new** invoice, or the **next new** invoice.

**Discounts**

    Various types of discounts apply all over the place.

Invoice Calculations
====================

An invoice is calculated over;

#.  The start of the current payment period,

    This is derived from;

    *   the end date of the previous **paid** invoice, plus 1 day, or
    *   the payment date of the first invoice, or
    *   today

#.  The list price of individual subscription items for the account(s),

    Where account(s) is to be regarded to as:

    #.  One billing account that may have subscriptions or its own, and
    #.  Zero, one or more user accounts that each may have subscriptions.

    A query might look as follows:

    .. code-block:: php

        $query = "SELECT k.UUID as UUID, k.email AS account_name " .
                "FROM accounts a INNER JOIN kolabusers k " .
                "ON a.ID = k.account WHERE a.ID = '<customer ID>'";

        $result = mysql_query($query);

        foreach (mysql_fetch_assoc($result) as $account) {
            $current_active_subscriptions = mysqli_fetch_all(
                    mysql_query(
                            "SELECT * FROM subscriptions " .
                            "WHERE UUID = '" . $account['UUID'] . "' AND " .
                            "(expires IS NULL OR expires <= TOMORROW)"
                        ),
                    MYSQLI_ASSOC
                );
        }


Account Discounts
-----------------

Account discounts are considered *price rates* or *rated reductions*. They are
to be executed against the original total sum of an invoice.

There's three ways of using the account discount in applied math:

.. math:: price = list price * price rate
    :label: Using Price Rates

    0 <= pricerate <= 1

.. math:: price = list price * (1 - discount)
    :label: Using Discount

    0 <= discount <= 1

.. math:: price = list price - (list price * discount)
    :label: Using Discount

    0 <= discount <= 1

Alternatively, if price rates and discounts are to be expressed in percentages:

.. math:: price = list price * (price rate / 100)
    :label: Using Price Rates

    0 <= pricerate <= 100

.. math:: price = list price * ((100 - discount) / 100)
    :label: Using Discount

    0 <= discount <= 100

.. math:: price = list price - (list price * (discount / 100))
    :label: Using Discount

    0 <= discount <= 100

An example invoice might therefore list::

    ============  ==========  ===  =========
    Item          Item Price  Qty  Sub-total
    ============  ==========  ===  =========
    User Account      10 CHF    2     20 CHF
    Setup Costs       50 CHF    1     50 CHF
    -----------------------------  ---------
                        Sub-total     70 CHF
                 Account Discount     10 %
    =============================  =========
                            Total     63 CHF

.. *   Volume Discounts

Contractual Term Length Discounts
---------------------------------

A contractual term's length is used to allow the user to commit to longer
periods of time, separate from the payment period.

As such, a customer could choose to commit to a contract for a minimum period of
a year, but choose for monthly invoicing for increased flexibility.

A scenario where such is primarily applicable and useful is, for example, a
group manager account for a business where employees get hired and fired.

For an account's options, **setup costs** may be incurred, per contractual term.

An account's options are choosen during initial signup, as are the contractual
term length and payment plan.

For a **group manager** account, the required *option* to register one or more
domain name spaces to manage is the factor that causes the first domain name
space registered to incur the setup costs.

.. NOTE::

    The setup costs should probably be incurred on the *domain account* the user
    registered.

For an **individual user** account, it is the required *option* of a user
account that incurs the setup costs.

Setup costs can be mapped to contractual term lengths like so, for example:

=============  ===========
Contract Term  Setup Costs
=============  ===========
1 Month            100 CHF
3 Months            75 CHF
1 Year              50 CHF
2 Years              0 CHF
=============  ===========

In this scenario, an example invoice for an annual contractual term with a
**monthly** payment plan might therefore list:

.. parsed-literal::

    ============  ==========  ===  =========
    Item          Item Price  Qty  Sub-total
    ============  ==========  ===  =========
    User Account      10 CHF    2     20 CHF    # 10 CHF * 2 qty * 1 month
    Setup Costs       50 CHF    1     50 CHF
    -----------------------------  ---------
                            Total     70 CHF

Another example invoice for an annual contractual term with a **yearly** payment
plan might therefore list:

.. parsed-literal::

    ============  ==========  ===  =========
    Item          Item Price  Qty  Sub-total
    ============  ==========  ===  =========
    User Account      10 CHF    2    240 CHF    # 10 CHF * 2 qty * 12 months
    Setup Costs       50 CHF    1     50 CHF
    -----------------------------  ---------
                            Total    290 CHF

Advance Payment Discounts
-------------------------

For advance payments made, a reduction in price is calculated. This may be
anywhere between 0% and 100% in price reduction, and is likely increased as the
advance payment increases.

Advance payment discounts are currently set to be:

*   **1%** for quarterly payments,
*   **3%** for yearly payments.

An example invoice for an annual contractual term with a **yearly** payment plan
might therefore list:

.. parsed-literal::

    ============  ==========  ===  ==========
    Item          Item Price  Qty   Sub-total
    ============  ==========  ===  ==========
    User Account      10 CHF    2  240.00 CHF    # 10 CHF * 2 qty * 12 months
    Setup Costs       50 CHF    1   50.00 CHF
    -----------------------------  ----------
                        Sub-total  290.00 CHF
         Advance Payment Discount    3    %
    -----------------------------  ----------
                            Total  281.30 CHF

Billing Account Permutations
============================

This section outlines the mutations possible for new accounts, and existing
accounts, that spawn the need for new invoices, different invoices (superseeding
existing ones) and accreditation.

General Considerations
----------------------

A billing account corresponds to one or more Kolab User accounts. Billing
accounts are the origin for account invoice calculations, and thus where the
iteration over indvidual items and each item's options originates.

For individual users, this may currently amount to:

.. graphviz::

    digraph {
            "Billing Account" -> "Kolab User Account" [dir=both];
            "Kolab User Account" -> "Option $x", "Option $y";
        }

But in the foreseeable future may amount to:

.. graphviz::

    digraph {
            "Billing Account" -> "Kolab User Account #1" [dir=both];
            "Billing Account" -> "Kolab User Account #2";
            "Billing Account" -> "Kolab User Account #3";
            "Kolab User Account #1" -> "Option $x", "Option $y";
            "Kolab User Account #2" -> "Option $x";
            "Kolab User Account #3" -> "Option $y";
        }

For group manager accounts, this may currently amount to:

.. graphviz::

    digraph {
            "Billing Account" -> "Domain Admin" [dir=both];
            "Domain Admin" -> "Custom Domain Option";
            "Domain Admin" -> "Kolab User Account #1", "Kolab User Account #2", "Kolab User Account #3";
            "Kolab User Account #1" -> "Option $x", "Option $y";
            "Kolab User Account #2" -> "Option $x";
            "Kolab User Account #3" -> "Option $y";
        }

Addition of Options and Subscriptions, Positive Change of Values
----------------------------------------------------------------

This scenario applies to a billing account increasing its service use.

The following options could be increased for user accounts:

*   Increase of Quota
*   Enabling ActiveSync

For group manager accounts, the following options could be increased:

*   Increase of Quota for a domain user account
*   Enabling ActiveSync for a domain user account
*   Adding a domain user account
*   Registering additional domain name spaces

A new invoice should be created for the increased value of the option(s)
changed, if the total value of the invoice is greather than or equal to $x CHF.

The new invoice shall include;

#.  The increased price for the account against a new payment period starting on
    the date the option was originally increased,

#.  A deduction of the amount already paid in, calculated on a daily basis,
    times the number of days remaining on the original payment period,
    accredited against the new price,

#.  The total for the new invoice.

Increase of Quota (User Account, Monthly Payment)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The math computes as follows:

.. math:: price = ( account price + ( new units - free units ) * unit price ) * months
    :label: Price for new Monthly Payment Invoice

.. math:: credit = ( amount paid - ( days * ( account price + ( old units - free units ) * unit price ) / 30.4375 ) )
    :label: Value of Accreditation

.. Works too, but is a negative number (same formula as a decrease of options
.. .. math::
..     :nowrap:
..
..     \begin{eqnarray}
..         old daily price = ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 \\
..         new daily price = ( 10 + ( 2 - 1 ) * 2 ) / 30.4375 \\
..         accredit = ( ( 30.4375 * 1 ) - 14 ) * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 - ( ( 30.4375 * 1 ) - 14 ) * ( 10 + ( 2 - 1 ) * 2 ) / 30.4375
..     \end{eqnarray}

.. math:: total = price - credit
    :label: New Invoice Total

Which, in an example situation of a 1GB increase to 2GB for a base account (the
minimal possible increase), 14 days in to the current payment period, is:

.. math:: price = ( 10 + ( 2 - 1 ) * 2 ) * 1 = 12 CHF
    :label: Price for new Monthly Payment Invoice

.. math:: credit = ( 10 - ( 14 * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 ) ) = 5.40 CHF
    :label: Value of Accreditation

.. math:: total = price - credit = 6.60 CHF
    :label: New Invoice Total

Which, in an example situation of a 1GB increase to 4GB for a base account, 14
days in to the current payment period, is:

.. math:: price = ( 10 + ( 4 - 1 ) * 2 ) * 1 = 16 CHF
    :label: Price for new Monthly Payment Invoice

.. math:: credit = ( 10 - ( 14 * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 ) ) = 5.40 CHF
    :label: Value of Accreditation

.. math:: total = price - credit = 10.60 CHF
    :label: New Invoice Total

Increase of Quota (User Account, Quarterly Payment)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The base logic applies to this payment plan as well.

As an example, the same user account increases quota from 1 GB to 2 GB 14 days
in to the current payment period:

.. math:: price = ( 10 + ( 2 - 1 ) * 2 ) * 3 = 36 CHF
    :label: Price for new Quarterly Payment Invoice

.. math:: credit = ( 30 - ( 14 * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 ) ) = 25.40 CHF
    :label: Value of Accreditation

.. math:: total = price - credit = 10.60 CHF
    :label: New Invoice Total

Doing the basic reasoning rather than the more accurate math leads us to, in an
example situation an original 1GB user account being increased to 2GB quota 14
days after a payment period has started:

*   14 days are (approximately) 1/6th of the original 3 months time period
*   5 CHF out of 30 CHF paid is therefore "used up", and
*   14 times the daily price does result in 4.59999.

Additionally, we know that approximately 25 CHF needs to be accredited. The
original price on an invoice for the new options would amount to 36 CHF -
the new invoice would be an approximate 11 CHF.

Removal of Options and Subscriptions, Negative Change of Values
---------------------------------------------------------------

This scenario applies to a billing account decreasing its service use.

This will result in a lower invoice value for the next payment period, and will
need accredited underutilized service use alread paid for.

The new invoice, to be generated for the next payment interval, shall include;

#.  The new price for the account against against the new payment period
    starting on the date of the next payment period,

#.  A deduction of the amount already paid in, calculated on a daily basis,
    times the number of days remaining on the original payment period,
    accredited against the new price,

#.  The total for the new invoice.

.. math::
    :nowrap:

    \begin{eqnarray}
        old daily price = ( account price + ( old units - free units ) * unit price ) / 30.4375 \\
        new daily price = ( account price + ( new units - free units ) * unit price ) / 30.4375 \\
        accredit = ( ( 30.4375 * months ) - days ) * old daily price - ( ( 30.4375 * months ) - days ) * new daily price
    \end{eqnarray}

Example scenario: User from 2GB to 1GB 14 days in to monthly payment period

.. math::
    :nowrap:

    \begin{eqnarray}
        old daily price = ( 10 + ( 2 - 1 ) * 2 ) / 30.4375 = 0.39 CHF \\
        new daily price = ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 0.33 CHF \\
        accredit = ( ( 30.4375 * 1 ) - 14 ) * old daily price - ( ( 30.4375 * 1 ) - 14 ) * new daily price = 1.08 CHF
    \end{eqnarray}

original price: 12 CHF
new price: 10 CHF

i would expect to get back about 1 CHF (half of the cost of the additional unit of storage at 2 CHF)

daily price i've paid: ( account price + ( old units - free units ) * unit price ) / 30.4375

daily price i've paid: ( 10 + ( 2 - 1 ) * 2 ) / 30.4375 = 0.39 CHF = (old daily price)

new daily price: ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 0.33 CHF

i need to be accredited: (30.4375 - 14) * old daily price - (30.4375 - 14) * new daily price

this would be: (30.4375 - 14) * ( 10 + ( 2 - 1 ) * 2 ) / 30.4375 - (30.4375 - 14) * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 1.08 CHF

Example scenario: User from 10GB to 1GB, 183 days in to yearly payment period.

.. math::
    :nowrap:

    \begin{eqnarray}
        old daily price = ( 10 + ( 10 - 1 ) * 2 ) / 30.4375 = 0.92 CHF \\
        new daily price = ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 0.33 CHF \\
        accredit = ( ( 30.4375 * 12 ) - 183 ) * old daily price - ( ( 30.4375 * 12 ) - 183 ) * new daily price = 107.78 CHF
    \end{eqnarray}

original price: 336 CHF
new price: 120 CHF

i would expect to get back about 6 times 9 times 2 = 108 CHF

daily price i've paid: ( account price + ( old units - free units ) * unit price ) / 30.4375

daily price i've paid: ( 10 + ( 10 - 1 ) * 2 ) / 30.4375 = 0.92 CHF = (old daily price)

new daily price: ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 0.33 CHF

i need to be accredited: (30.4375 * months - days) * old daily price - (30.4375 * months - days) * new daily price

this would be: (30.4375 * 12 - 183) * ( 10 + ( 10 - 1 ) * 2 ) / 30.4375 - (30.4375 * 12 - 183) * ( 10 + ( 1 - 1 ) * 2 ) / 30.4375 = 107.78 CHF

.. parsed-literal::

                                  Aug
      a                          31st   e
      |------b--c-------------------(d) |-----------------------------|
     Aug                                Sep                          Sep
     1st                                1st                          30th

**a**)

    Start of payment period. Generate invoice according to current
    subscriptions, etc.

**b**)

    Change of options.

    Re-generate invoice for Aug 1st - Aug 8th on the old subscriptions, and Aug
    9th - end of payment period.

    .. NOTE::

        New invoice is actually generated only for cumulative values over the
        threshold.

        Otherwise, the accreditation awaits the invoice for the next payment
        period, or the additional cost awaits the invoice for the next payment
        period.

**c**)

    Payment of invoice 1.

**d**)

    End of payment period 1.

**e**)

    Start of payment period 2.

.. parsed-literal::

    Invoice at point A:

    =============  ==========  ===  =========
    Item           Item Price  Qty  Sub-total
    =============  ==========  ===  =========
    User Account       10 CHF    1  20.00 CHF   # Both items for Aug 1st - 31st.
    Extra Storage       2 CHF    2   4.00 CHF
    ------------------------------  ---------
                         Sub-total  24.00 CHF
                  Account Discount  10    %
    ==============================  =========
                             Total  21.60 CHF

    Invoice at point B:

    =============  ==========  ===  =========
    Item           Item Price  Qty  Sub-total
    =============  ==========  ===  =========
    User Account       10 CHF    1  20.00 CHF   # Aug 1st - 31st.
    Extra Storage       2 CHF    2   1.05 CHF   # Aug 1st - 8th.  ( ( 4 / 30.4375 ) * 8 )
    Extra Storage       2 CHF    4   5.90 CHF   # Aug 9th - 31st. ( ( 8 / 30.4375 ) * ( 30.4375 - 8 ) )
    ------------------------------  ---------
                         Sub-total  26.95 CHF
                  Account Discount  10    %
    ==============================  =========
                             Total  24.26 CHF

Alterations to Account Discount rate
------------------------------------


.. rubric:: Footnotes

.. [#] This is an example situation.
