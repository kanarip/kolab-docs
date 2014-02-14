.. _dev-packaging-install_nightly:

============================================
Install the nightly build on a test server
============================================

For development of the community version of Kolab, it is helpful to have nightly built packages of the master of https://git.kolab.org.

Note: these packages are only meant for development and testing, not at all for production use!!!

It is recommended to do a fresh install of the machine, when you want to go back to the Kolab Community version packages, without the nightly packages.

CentOS 6
=================================================

First the usual steps, that you do for installing Kolab3 (see also :ref:`installation-centos`):

.. parsed-literal::

    wget http://ftp.uni-kl.de/pub/linux/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
    yum -y localinstall --nogpgcheck epel-release-6-8.noarch.rpm
    cd /etc/yum.repos.d/
    wget http://obs.kolabsys.com:82/Kolab:/3.2/CentOS_6/Kolab:3.2.repo
    wget http://obs.kolabsys.com:82/Kolab:/3.2:/Updates/CentOS_6/Kolab:3.2:Updates.repo
    cd -

Now also install the repo for the `obs.kolabsys.com tpokorra Project <https://obs.kolabsys.com/project/show?project=home%3Atpokorra%3Abranches%3AKolab%3ADevelopment>`_:

.. parsed-literal::

    wget http://obs.kolabsys.com:82/home:/tpokorra:/branches:/Kolab:/Development/CentOS_6/home:tpokorra:branches:Kolab:Development.repo \\
              -O /etc/yum.repos.d/obs-tpokorra-nightly-kolab.repo

Now run:

.. parsed-literal::

    yum install kolab
    setup-kolab

Debian 7.0
==========

See also the usual steps, that you do for installing Kolab3 (see also :ref:`installation-debian`). We are adding another repository for the nightly built packages.

.. parsed-literal::
    username=tpokorra
    cat > /etc/apt/sources.list.d/kolab.list <<FINISH
    deb http://obs.kolabsys.com:82/Kolab:/3.2/Debian_7.0/ ./
    deb http://obs.kolabsys.com:82/Kolab:/3.2:/Updates/Debian_7.0/ ./
    deb http://obs.kolabsys.com:82/home:/$username:/branches:/Kolab:/Development/Debian_7.0/ ./
    FINISH
    
    wget http://obs.kolabsys.com:82/Kolab:/3.2/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com:82/Kolab:/3.2:/Updates/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com:82/home:/$username:/branches:/Kolab:/Development/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    
    cat > /etc/apt/preferences.d/kolab <<FINISH
    Package: *
    Pin: origin obs.kolabsys.com
    Pin-Priority: 501
    FINISH
    
    apt-get update
    apt-get install kolab

And then run

.. parsed-literal::
    setup-kolab
