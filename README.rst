chromium-sandbox-manager
========================

what is chromium-sandbox-manager
--------------------------------

  chromium-sandbox-manager (or csm) is a set of bash scripts written to help
  sandbox the chrome browser using firejail.

documentation
-------------

  see DOCUMENTATION, which basically is just
  ``chromium-sandbox-manager --help > DOCUMENTATION``

dependencies
------------

 - firejail ( + patches found in /patches folder )

installing
----------

 - compile and install firejail with patches from /patches folder

 - put the tarball in a directory where you have permissions, and extract sources::

     xz -cd chrome-sandbox-manager-0.X.tar.xz | tar -xvf -

 - add said directory to your $PATH variable, and run::

     chrome-sandbox-manager
