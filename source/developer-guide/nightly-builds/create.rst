============================================
Creating the nightly builds on OBS
============================================

This chapter explains how to create a branch of the development project on the OBS server provided by `Kolab Systems <https://kolabsys.com>`_, and how to modify it to be able to build from the source tar.gz files from https://git.kolab.org.

Creating a branch in OBS
========================

Please follow the instructions at :ref:`dev-packaging-howto_get_started` to create your own branch of the development packages.

Some of the steps you can do in the web client as well, eg. to branch the package `kolab-syncroton <https://obs.kolabsys.com/package/show?package=kolab-syncroton&project=Kolab%3ADevelopment>`_ from project `Kolab Development <https://obs.kolabsys.com/project/show?project=Kolab%3ADevelopment>`_, you click on the link `Branch Package <https://obs.kolabsys.com/package/branch_dialog?package=kolab-syncroton&project=Kolab%3ADevelopment>`_ on the `page of the package kolab-syncroton <https://obs.kolabsys.com/package/show?package=kolab-syncroton&project=Kolab%3ADevelopment>`_.

You should select the packages that you want to build in your nightly build, and create a branch for each of them. The result looks like this: `Project home:tpokorra:branches:Kolab:Development <https://obs.kolabsys.com/project/show?project=home%3Atpokorra%3Abranches%3AKolab%3ADevelopment>`_

One-time adjustments for nightly builds
=======================================

Replace the source files
------------------------
On the command line with osc, you need once to remove the original tar.gz file, and download the latest tar.gz file from https://git.kolab.org.

This is an example for the package kolab-syncroton:

.. parsed-literal::

    osc rm kolab-syncroton-2.2.1.tar.gz
    wget https://git.kolab.org/kolab-syncroton/snapshot/kolab-syncroton-master.tar.gz
    osc add kolab-syncroton-master.tar.gz

Furthermore you need to modify the build files to reference the new tar.gz file, and to find the extracted code in the right place.

For CentOS, those changes are required in the .spec file:

.. parsed-literal::

    -Source0:        http://mirror.kolabsys.com/pub/releases/%{name}-%{version}.tar.gz
    +Source0:        %{name}-master.tar.gz
    -%setup -q -n %{name}-%{version}
    +%setup -q -n %{name}-master    

Adjust the release numbers
--------------------------
One other issue: in order for the :ref:`installation of the nightly packages <dev-packaging-install_nightly>` to work properly, you need to adjust the release number of the packages.

For CentOS, you need to add the following line to the top of your .spec file:

.. parsed-literal::
    %define release_prefix dev%(date +%%Y%%m%%d)

And in the settings of your project, go to "Advanced" / "Project Config", and enter this line:

.. parsed-literal::
    Release: 99.%%{?release_prefix}.<CI_CNT>.<B_CNT>

For more details, see http://en.opensuse.org/openSUSE:Build_Service_prjconf

Commit the changes
------------------

At last, you need to commit your changes, and the OBS will build your own packages:

.. parsed-literal::

    osc commit -m "replacing the source files"


Nightly update
==============

You should create a cronjob on your system, where you run osc. This cronjob must fetch the latest tar.gz file from https://git.kolab.org, and then commit that to the OBS.

Have a look at this script for an example: https://gist.github.com/tpokorra/5698249

To regularly check that your nightly build works, you can use the command "osc results".

The following code is also part of the above gist:

.. parsed-literal::
    cd kolab-syncroton
    result=`osc results | grep CentOS_6 | grep x86_64 | grep -E "failed|unresolvable|broken"`
    if [ ! -z "$result" ]
    then
       echo "there is a problem with result of package " $pkgname
       echo $result
    fi

Trouble Shooting
================

Link has errors: conflict in file
---------------------------------
Your branch is linked to the original package, which means that OBS will try to merge updates to the source package into your branch. This sometimes leads to the error "conflict in file".

To resolve this, do this with osc on the command line:

.. parsed-literal::
    osc branch  # will give you the same error as on the OBS webpage
    osc pull
    vi <file that has conflict>  # resolve conflict manually
    osc resolved <file that had conflict>
    osc commit -m "Rebased"

