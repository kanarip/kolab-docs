.. _admin_roundcube-settings:

==================================
Roundcube Settings Reference Guide
==================================

Roundcube is configured using a default settings file, a settings file for site-
specific configuration, host-specific configuration files, and configuration
files specific to plugins.

The configuration inheritance model looks as follows:

``config/defaults.inc.php``

    This configuration file ships the default settings for Roundcube.

    .. NOTE::

        On the expanded sources (from tarball releases), this file is at
        :file:`your/install/path/config/defaults.inc.php`. On packaged
        distributions however, this path is a symbolic link to
        :file:`/etc/roundcubemail/defaults.inc.php`.

``config/config.inc.php``

    Site-specific global settings are in this configuration file.

    .. NOTE::

        On the expanded sources (from tarball releases), this file starts out as
        :file:`your/install/path/config/config.inc.php.dist`.

        You would rename this original ``.dist`` file to
        :file:`your/install/path/config/config.inc.php`, but on packaged
        distributions, this is already done by the packaging. Similar to
        ``defaults.inc.php``, this configuration file also lives in
        :file:`/etc/roundcubemail/`, at
        :file:`/etc/roundcubemail/config.inc.php` to be precise, and a symbolic
        link is created from to original file location to this location.

``config/<site>.inc.php``

    ``<site>`` being a placeholder for an arbitrary site name, Roundcube allows
    the inclusion of additional configuration using the
    :ref:`admin_roundcube-settings_include_host_config` setting.

``plugins/<plugin_name>/config.inc.php``

    Each plugin that requires configuration ships a :file:`config.inc.php.dist`.

    As you may have suspected, these configuration files too are created
    symbolic links for, to :file:`/etc/roundcubemail/<plugin_name>.inc.php`.

Since the configuration files are PHP code that is being executed while the
configuration loads, one might add include statements such that configured
condititions load additional configuration files on top of the aforementioned
four (types).

For example, :file:`/etc/roundcubemail/config.inc.php` might have a segment to
establish defaults at the start, then include a site specific configuration file:

.. code-block:: php

    if (file_exists(dirname(__FILE__) . PATH_SEPARATOR . $_SERVER["HTTP_HOST"] . PATH_SEPARATOR . basename(__FILE__))) {
        require_once(dirname(__FILE__) . PATH_SEPARATOR . $_SERVER["HTTP_HOST"] . PATH_SEPARATOR . basename(__FILE__));
    }

and then re-apply mandatory defaults:

.. code-block:: php

    $mandatory_plugins = Array(
            'kolab_auth',           # Applies globally required routines
                                    # including authentication, authorization
                                    # and canonification.

            'kolab_folders',        # Hides groupware folders if the plugins
                                    # for them are not loaded.
        );

    foreach ( $mandatory_plugins as $num => $plugin ) {
        if (!in_array($plugin, $config['plugins'])) {
                $config['plugins'][] = $plugin;
        }
    }

-----------------
Database Settings
-----------------

.. seealso::

    *   :ref:`admin_roundcube-settings_database-configuration-hints`

.. include:: roundcube-settings/db_dsnr.txt
.. include:: roundcube-settings/db_dsnw.txt
.. include:: roundcube-settings/db_dsnw_noread.txt

.. include:: roundcube-settings/db_persistent.txt
.. include:: roundcube-settings/db_prefix.txt
.. include:: roundcube-settings/db_table_dsn.txt

-------------
IMAP Settings
-------------

.. include:: roundcube-settings/imap_cache.txt
.. include:: roundcube-settings/imap_cache_ttl.txt
.. include:: roundcube-settings/messages_cache.txt
.. include:: roundcube-settings/messages_cache_threshold.txt
.. include:: roundcube-settings/messages_cache_ttl.txt
.. include:: roundcube-settings/memcache_hosts.txt
.. include:: roundcube-settings/delete_always.txt
.. include:: roundcube-settings/delete_junk.txt
.. include:: roundcube-settings/logout_expunge.txt
.. include:: roundcube-settings/logout_purge.txt
.. include:: roundcube-settings/flag_for_deletion.txt
.. include:: roundcube-settings/create_default_folders.txt
.. include:: roundcube-settings/default_folders.txt
.. include:: roundcube-settings/junk_mbox.txt
.. include:: roundcube-settings/protect_default_folders.txt
.. include:: roundcube-settings/check_all_folders.txt
.. include:: roundcube-settings/default_host.txt
.. include:: roundcube-settings/default_port.txt
.. include:: roundcube-settings/imap_auth_cid.txt
.. include:: roundcube-settings/imap_auth_pw.txt
.. include:: roundcube-settings/imap_auth_type.txt
.. include:: roundcube-settings/imap_delimiter.txt
.. include:: roundcube-settings/imap_disabled_caps.txt
.. include:: roundcube-settings/imap_force_caps.txt
.. include:: roundcube-settings/imap_force_lsub.txt
.. include:: roundcube-settings/imap_force_ns.txt
.. include:: roundcube-settings/imap_ns_other.txt
.. include:: roundcube-settings/imap_ns_personal.txt
.. include:: roundcube-settings/imap_ns_shared.txt
.. include:: roundcube-settings/imap_timeout.txt
.. include:: roundcube-settings/min_refresh_interval.txt
.. include:: roundcube-settings/no_save_sent_messages.txt
.. include:: roundcube-settings/quota_zero_as_unlimited.txt
.. include:: roundcube-settings/refresh_interval.txt
.. include:: roundcube-settings/sent_mbox.txt
.. include:: roundcube-settings/skip_deleted.txt
.. include:: roundcube-settings/trash_mbox.txt

-------------
LDAP Settings
-------------

.. include:: roundcube-settings/ldap_public.txt
.. include:: roundcube-settings/ldap_cache.txt
.. include:: roundcube-settings/ldap_cache_ttl.txt

.. include:: roundcube-settings/autocomplete_addressbooks.txt

-----------------------------
Session & Login Configuration
-----------------------------

.. include:: roundcube-settings/assets_path.txt
.. include:: roundcube-settings/ip_check.txt
.. include:: roundcube-settings/login_autocomplete.txt
.. include:: roundcube-settings/login_lc.txt
.. include:: roundcube-settings/log_logins.txt
.. include:: roundcube-settings/log_session.txt
.. include:: roundcube-settings/session_auth_name.txt
.. include:: roundcube-settings/session_domain.txt
.. include:: roundcube-settings/session_lifetime.txt
.. include:: roundcube-settings/session_name.txt
.. include:: roundcube-settings/session_path.txt
.. include:: roundcube-settings/session_storage.txt
.. include:: roundcube-settings/user_aliases.txt
.. include:: roundcube-settings/mail_domain.txt
.. include:: roundcube-settings/referer_check.txt
.. include:: roundcube-settings/use_secure_urls.txt
.. include:: roundcube-settings/username_domain_forced.txt
.. include:: roundcube-settings/username_domain.txt

------------
Log Settings
------------

.. include:: roundcube-settings/debug_level.txt
.. include:: roundcube-settings/imap_debug.txt
.. include:: roundcube-settings/ldap_debug.txt
.. include:: roundcube-settings/log_date_format.txt
.. include:: roundcube-settings/log_dir.txt
.. include:: roundcube-settings/log_driver.txt
.. include:: roundcube-settings/per_user_logging.txt
.. include:: roundcube-settings/smtp_debug.txt
.. include:: roundcube-settings/sql_debug.txt
.. include:: roundcube-settings/syslog_facility.txt
.. include:: roundcube-settings/syslog_id.txt

.. seealso::

    *   :ref:`admin_roundcube-settings-plugin_kolab_activesync_activesync_debug`
    *   :ref:`admin_roundcube-settings-plugin_kolab_activesync_activesync_user_log`

--------------
Other Settings
--------------

.. include:: roundcube-settings/addressbook_name_listing.txt
.. include:: roundcube-settings/addressbook_pagesize.txt
.. include:: roundcube-settings/addressbook_search_mode.txt
.. include:: roundcube-settings/addressbook_search_mods.txt
.. include:: roundcube-settings/addressbook_sort_col.txt
.. include:: roundcube-settings/address_book_type.txt
.. include:: roundcube-settings/address_template.txt
.. include:: roundcube-settings/advanced_prefs.txt
.. include:: roundcube-settings/autocomplete_max.txt
.. include:: roundcube-settings/autocomplete_min_length.txt
.. include:: roundcube-settings/autocomplete_single.txt
.. include:: roundcube-settings/autocomplete_threads.txt
.. include:: roundcube-settings/auto_create_user.txt
.. include:: roundcube-settings/autoexpand_threads.txt
.. include:: roundcube-settings/client_mimetypes.txt
.. include:: roundcube-settings/compose_extwin.txt
.. include:: roundcube-settings/compose_responses_static.txt
.. include:: roundcube-settings/contact_photo_size.txt
.. include:: roundcube-settings/date_formats.txt
.. include:: roundcube-settings/date_format.txt
.. include:: roundcube-settings/date_long.txt
.. include:: roundcube-settings/date_short.txt
.. include:: roundcube-settings/default_addressbook.txt
.. include:: roundcube-settings/default_charset.txt
.. include:: roundcube-settings/default_font_size.txt
.. include:: roundcube-settings/default_font.txt
.. include:: roundcube-settings/des_key.txt
.. include:: roundcube-settings/display_next.txt
.. include:: roundcube-settings/display_version.txt
.. include:: roundcube-settings/dont_override.txt
.. include:: roundcube-settings/draft_autosave.txt
.. include:: roundcube-settings/drafts_mbox.txt
.. include:: roundcube-settings/dsn_default.txt
.. include:: roundcube-settings/email_dns_check.txt
.. include:: roundcube-settings/enable_installer.txt
.. include:: roundcube-settings/enable_spellcheck.txt
.. include:: roundcube-settings/force_7bit.txt
.. include:: roundcube-settings/force_https.txt
.. include:: roundcube-settings/forward_attachment.txt
.. include:: roundcube-settings/generic_message_footer_html.txt
.. include:: roundcube-settings/generic_message_footer.txt
.. include:: roundcube-settings/htmleditor.txt
.. include:: roundcube-settings/http_received_header_encrypt.txt
.. include:: roundcube-settings/http_received_header.txt
.. include:: roundcube-settings/identities_level.txt
.. include:: roundcube-settings/image_thumbnail_size.txt
.. include:: roundcube-settings/im_convert_path.txt
.. include:: roundcube-settings/im_identify_path.txt
.. include:: roundcube-settings/include_host_config.txt
.. include:: roundcube-settings/inline_images.txt
.. include:: roundcube-settings/language.txt
.. include:: roundcube-settings/line_length.txt
.. include:: roundcube-settings/list_cols.txt
.. include:: roundcube-settings/mail_header_delimiter.txt
.. include:: roundcube-settings/mail_pagesize.txt
.. include:: roundcube-settings/max_group_members.txt
.. include:: roundcube-settings/max_pagesize.txt
.. include:: roundcube-settings/max_recipients.txt
.. include:: roundcube-settings/mdn_default.txt
.. include:: roundcube-settings/mdn_requests.txt
.. include:: roundcube-settings/mdn_use_from.txt
.. include:: roundcube-settings/message_extwin.txt
.. include:: roundcube-settings/message_show_email.txt
.. include:: roundcube-settings/message_sort_col.txt
.. include:: roundcube-settings/message_sort_order.txt
.. include:: roundcube-settings/mime_magic.txt
.. include:: roundcube-settings/mime_param_folding.txt
.. include:: roundcube-settings/mime_types.txt
.. include:: roundcube-settings/password_charset.txt
.. include:: roundcube-settings/plugins.txt
.. include:: roundcube-settings/prefer_html.txt
.. include:: roundcube-settings/prettydate.txt
.. include:: roundcube-settings/preview_pane_mark_read.txt
.. include:: roundcube-settings/preview_pane.txt
.. include:: roundcube-settings/product_name.txt
.. include:: roundcube-settings/read_when_deleted.txt
.. include:: roundcube-settings/recipients_separator.txt
.. include:: roundcube-settings/reply_all_mode.txt
.. include:: roundcube-settings/reply_mode.txt
.. include:: roundcube-settings/reply_same_folder.txt
.. include:: roundcube-settings/search_mods.txt
.. include:: roundcube-settings/send_format_flowed.txt
.. include:: roundcube-settings/sendmail_delay.txt
.. include:: roundcube-settings/show_images.txt
.. include:: roundcube-settings/show_real_foldernames.txt
.. include:: roundcube-settings/show_sig.txt
.. include:: roundcube-settings/skin_include_php.txt
.. include:: roundcube-settings/skin_logo.txt
.. include:: roundcube-settings/skin.txt
.. include:: roundcube-settings/smtp_auth_cid.txt
.. include:: roundcube-settings/smtp_auth_pw.txt
.. include:: roundcube-settings/smtp_auth_type.txt
.. include:: roundcube-settings/smtp_conn_options.txt
.. include:: roundcube-settings/smtp_helo_host.txt
.. include:: roundcube-settings/smtp_log.txt
.. include:: roundcube-settings/smtp_pass.txt
.. include:: roundcube-settings/smtp_port.txt
.. include:: roundcube-settings/smtp_server.txt
.. include:: roundcube-settings/smtp_timeout.txt
.. include:: roundcube-settings/smtp_user.txt
.. include:: roundcube-settings/spellcheck_before_send.txt
.. include:: roundcube-settings/spellcheck_dictionary.txt
.. include:: roundcube-settings/spellcheck_engine.txt
.. include:: roundcube-settings/spellcheck_ignore_caps.txt
.. include:: roundcube-settings/spellcheck_ignore_nums.txt
.. include:: roundcube-settings/spellcheck_ignore_syms.txt
.. include:: roundcube-settings/spellcheck_languages.txt
.. include:: roundcube-settings/spellcheck_uri.txt
.. include:: roundcube-settings/standard_windows.txt
.. include:: roundcube-settings/strip_existing_sig.txt
.. include:: roundcube-settings/support_url.txt
.. include:: roundcube-settings/temp_dir_ttl.txt
.. include:: roundcube-settings/temp_dir.txt
.. include:: roundcube-settings/time_formats.txt
.. include:: roundcube-settings/time_format.txt
.. include:: roundcube-settings/timezone.txt
.. include:: roundcube-settings/undo_timeout.txt
.. include:: roundcube-settings/upload_progress.txt
.. include:: roundcube-settings/use_https.txt
.. include:: roundcube-settings/useragent.txt
.. include:: roundcube-settings/x_frame_options.txt

---------------
Plugin Settings
---------------

.. _admin_roundcube-settings-plugin_acl:

The ``acl`` Plugin
==================

.. _admin_roundcube-settings-plugin_archive:

The ``archive`` Plugin
======================

.. _admin_roundcube-settings-plugin_calendar:

The ``calendar`` Plugin
=======================

.. include:: roundcube-settings/calendar.txt

.. _admin_roundcube-settings-plugin_kolab_activesync:

The ``kolab_activesync`` Plugin
===============================

.. include:: roundcube-settings/activesync_debug.txt
.. include:: roundcube-settings/activesync_user_log.txt

.. _admin_roundcube-settings-plugin_kolab_auth:

The ``kolab_auth`` Plugin
=========================

.. include:: roundcube-settings/kolab_auth.txt

.. _admin_roundcube-settings-plugin_kolab_addressbook:

The ``kolab_addressbook`` Plugin
================================

.. _admin_roundcube-settings-plugin_kolab_config:

The ``kolab_config`` Plugin
===========================

.. _admin_roundcube-settings-plugin_kolab_delegation:

The ``kolab_delegation`` Plugin
===============================

.. _admin_roundcube-settings-plugin_kolab_files:

The ``kolab_files`` Plugin
==========================

.. _admin_roundcube-settings-plugin_kolab_folders:

The ``kolab_folders`` Plugin
============================

.. _admin_roundcube-settings-plugin_libkolab:

The ``libkolab`` Plugin
=======================

.. include:: roundcube-settings/kolab_cache.txt
.. include:: roundcube-settings/kolab_messages_cache_bypass.txt
.. include:: roundcube-settings/libkolab.txt

.. _admin_roundcube-settings-plugin_libcalendaring:

The ``libcalendaring`` Plugin
=============================

.. _admin_roundcube-settings-plugin_managesieve:

The ``managesieve`` Plugin
==========================

.. _admin_roundcube-settings-plugin_password:

The ``password`` Plugin
=======================

.. _admin_roundcube-settings-plugin_redundant_attachments:

The ``redundant_attachments`` Plugin
====================================

.. _admin_roundcube-settings-plugin_tasklist:

The ``tasklist`` Plugin
=======================

.. _admin_roundcube-settings-plugin_threading_as_default:

The ``threading_as_default`` Plugin
===================================
