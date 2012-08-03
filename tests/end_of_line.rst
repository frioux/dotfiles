Tests for End of Line Property
==============================

The following tests are for the ``end_of_line`` EditorConfig property.

Verifying Newline Style
-----------------------

The style of newlines in a file can be verified with the ``file`` command.

Verifying LF newlines:

``file test_files/lf.txt`` should return something like:

	test_files/lf.txt: ASCII text

``file test_files/crlf.txt`` should return something like:

	test_files/crlf.txt: ASCII text, with CRLF line terminators

``file test_files/cr.txt`` should return something like:

	test_files/cr.txt: ASCII text, with CR line terminators

Tests for Newlines
------------------
To ensure that the newlines added to files are not affected by the newlines
already present in the files, new files should be created.

Unix-style Newlines
~~~~~~~~~~~~~~~~~~~
1. Create file ``lf.txt``.
2. Add two lines to the the file and save it.
3. Confirm that new lines use LF

Windows-style Newlines
~~~~~~~~~~~~~~~~~~~~~~
1. Open ``crlf.txt``.
2. Add a new line to the end of the file and save it.
3. Confirm that new lines use CRLF

Old Mac-style Newlines
~~~~~~~~~~~~~~~~~~~~~~
1. Open ``cr.txt``.
2. Add a new line to the end of the file and save it.
3. Confirm that new lines use CR
