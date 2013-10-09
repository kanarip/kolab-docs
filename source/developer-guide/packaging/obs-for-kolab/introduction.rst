=============================
Introduction to the Kolab OBS
=============================

The Kolab community uses a private instance of the
`Open Build Service <http://openbuildservice.org>`_ provided and maintained by
`Kolab Systems <https://kolabsys.com>`_.

There are a variety of reasons to run a private OBS instance, for which
you could read on :ref:`dev-packaging-why_private_obs` if you are interested.

*   Web Address: https://obs.kolabsys.com
*   API Web Address: https://obs.kolabsys.com:444

.. toctree::
    :maxdepth: 2

    howto-get-started
    generic-macros-and-conditions
    webserver-applications

.. Setup and Structure
.. ===================
..
.. #.  Create a Logical Volume to hold the virtual machine:
..
..     .. parsed-literal::
..
..         :command:`lvcreate -L 20G -n guest_obs01 vg_kvm02`
..
.. #.  Refresh the storage pool:
..
..     .. parsed-literal::
..
..         :command:`virsh pool-refresh vg_kvm02`
..
.. #.  Download the raw server appliance image, and xzcat it in to the logical
..     volume:
..
..     .. parsed-literal::
..
..         :command:`xzcat /path/to/raw/xz/image > /dev/vg_kvm02/guest_obs01`
..
.. #.  Start the VM
.. #.  Load the correct certificates
.. #.  Set the hostname, IP address, gateway and DNS servers
.. #.  Change passwords
