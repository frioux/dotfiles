Tests for EditorConfig Plugins
==============================

There is currently no way to automate tests for EditorConfig plugins like there
is for the EditorConfig core libraries.  This repository contains instructions
to help developers manually test their EditorConfig plugins.

Running Tests
-------------

The ``tests`` directory contains instructions for testing various EditorConfig
properties.  The ``test_files`` directory contains the test files referenced in
these instructions.

Tests should be run by opening up each relevant file in the ``tests``
directory, running through the tests in the file and verifying that the
expected behavior is observed.

After running each test the files in the git repository should be reverted and
any newly created files should be deleted.  To revert files in the git
repository use:

	git checkout -- test_files/
