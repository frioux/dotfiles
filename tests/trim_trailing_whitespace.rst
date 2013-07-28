Trim Trailing Whitespace Property
=================================

The following tests are for the ``trim_trailing_whitespace`` EditorConfig
property.

Finding Trailing Whitespace
---------------------------
The following command can be used to locate lines with trailing whitespace in a
file named file.txt:

	grep "[ \t]$" file.txt

Trimming Whitespace
-------------------
1. Open trim.txt
2. Add a line to the file and save the file
3. Confirm that no lines end with whitespace

Not Trimming Whitespace
-----------------------
1. Open no_trim.txt
2. Add a line to the file and save the file
3. Confirm that some lines end with whitespace
