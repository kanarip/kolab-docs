========
Packages
========

Packages come in three categories:

#.  Software for which the Kolab Groupware community is upstream;

    These packages we tend to build for all platforms.

#.  So-called "meta-packages" for ease of installation;

    These packages we tend to build for all platforms.

#.  Additional dependencies not supplied by or out-dated in the base platform;

    These packages we strive to keep to an absolute minimum.

We tend to create packages disabled for all repositories by default, and
therefore each package creation includes a segment by default:

.. parsed-literal::

    <build>
        <disable/>
    </build>

.. toctree::
    :maxdepth: 2

    packages-kolab
    packages-dependencies
    packages-extras
