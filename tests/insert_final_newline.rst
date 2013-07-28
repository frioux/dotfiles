Insert Final Newline Property
=============================

The following tests are for the ``insert_final_newline`` EditorConfig property.

Checking for Final Newline
--------------------------

Files can be tested for a newline at the end with the ``file`` command.

``file test_files/with_newline.txt`` should return something like:

	test_files/with_newline.txt: ASCII text

``file test_files/without_newline.txt`` should return something like:

	test_files/without_newline.txt: ASCII text, with no line terminators

Tests for Newline at end of File
--------------------------------

Test for Newline
~~~~~~~~~~~~~~~~
1. Create file with_newline.txt
2. Add a single line to the file and save the file
3. Confirm that file ends in a newline

Test for No Newline
~~~~~~~~~~~~~~~~~~~
1. Create file without_newline.txt
2. Add a single line to the file and save the file
3. Confirm that file does not end in a newline
