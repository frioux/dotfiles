Tests for Character Set Property
==============================

The following tests are for the ``charset`` EditorConfig property.

Verifying Character Set
-----------------------

In general the character set used in a file may not be conclusively verified,
but it can often be verified with reasonable accuracy.  The ``file`` command
can be used to guess the character set used.

Verifying LF newlines:

``file test_files/latin1.txt`` should return something like:

	test_files/utf-8.txt: ASCII text

``file test_files/utf-8.txt`` should return something like:

	test_files/utf-8.txt: UTF-8 Unicode text

``file test_files/utf-8-bom.txt`` should return something like:

	test_files/utf-8-bom.txt: UTF-8 Unicode (with BOM) text

``file test_files/utf-16be.txt`` should return something like:

	test_files/utf-16be.txt: Big-endian UTF-16 Unicode text

``file test_files/utf-16le.txt`` should return something like:

	test_files/utf-16le.txt: Little-endian UTF-16 Unicode text, with no line terminators

Note that UTF-8 files without any unicode characters are indistinguishable from
Latin1 files.

Tests for Newlines
------------------
To ensure that the newlines added to files are not affected by the newlines
already present in the files, new files should be created.

Latin1 Character Set
~~~~~~~~~~~~~~~~~~~~
1. Open file ``latin1.txt``.
2. Add a line without unicode characters to the file and save it.
3. Confirm that the file is an ASCII file.

Latin1 Character Set with Unicode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open file ``latin1.txt``.
1. Add this line to the file: "Here is a unicode character: ★" and save it
2. Confirm that either:
   a. an error was raised
   b. the file was saved as UTF-8 without BOM

UTF-8 Character Set
~~~~~~~~~~~~~~~~~~~
1. Open file ``utf-8.txt``.
2. Add this line to the file: "Here is a unicode character: ★" and save it
3. Confirm that the file was saved as UTF-8 (without BOM)

UTF-8 with BOM Character Set
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Create file ``utf-8-bom.txt``.
2. Add a line to the file and save it
3. Confirm that the file was saved as UTF-8 with BOM

UTF-16BE Character Set
~~~~~~~~~~~~~~~~~~~~~~
1. Create file ``utf-16be.txt``.
2. Add a line to the file and save it
3. Confirm that the file was saved as UTF-16BE

UTF-16LE Character Set
~~~~~~~~~~~~~~~~~~~~~~
1. Create file ``utf-16le.txt``.
2. Add a line to the file and save it
3. Confirm that the file was saved as UTF-16LE
