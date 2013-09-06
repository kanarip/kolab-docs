=============================
Generic Macros and Conditions
=============================

**Always ship sources and patches**

    RPM packages should always ship all sources and patches to all
    distributions.
    
    In RPM ``.spec`` files, it is possible to create a construction like:
    
    .. parsed-literal::
    
        %if 0%{?suse_version}
        Source1:        extra-source.for.suse
        Patch1:         patch.for.suse
        %endif
        
    These lines describe what to include in the source RPM, and should therefore
    be avoided (as files may get excluded).
    
    Instead, use:

    .. parsed-literal::
    
        Source1:        extra-source.for.suse
        Patch1:         patch.for.suse
        (...)
        %prep
        %setup
        %if 0%{?suse_version}
        %{__install} -p -m 644 %{SOURCE1} some/where
        %patch1 -p1
        %endif
        
**Define whether the system uses systemd or sysvinit**

    Use ``%{suse_version}`` and ``%{rhel}`` to determine whether **systemd** or
    **SysVinit** is in use.
    
    .. NOTE::
    
        All openSUSE versions supported use systemd, and all Fedora versions
        supported use systemd. This means that for as far as RPM packaging goes,
        basically only ``%{rhel}`` < 7 does not use systemd.

    .. parsed-literal::
    
        %if 0%{?suse_version} < 1 && 0%{?fedora} < 1 && 0%{?rhel} < 7
        %global with_systemd 0
        %else
        %global with_systemd 1
        %endif

