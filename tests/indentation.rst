Tests for Indentation Properties
================================

The following tests are for ``indent_style``, ``indent_size``, and
``tab_width`` EditorConfig properties.

Space-based indentation
-----------------------

The following tests are for space-based indentation (``indent_style = space``).

3-space indentation
~~~~~~~~~~~~~~~~~~~
1. Open ``3_space.txt``.
2. Add a new line to the end of the file and indent it twice.
3. Confirm that new line is indented 6 spaces.
4. Confirm that mixed indentation on first line of file is indented 6 columns.

4-space indentation with tab width of 8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open ``4_space.py``.
2. Add a new line of code to the end of the file and indent it once.
3. Confirm that new last line is indented with 4 spaces.
4. Add a second new line of code to the end of the file and indent it twice.
5. Confirm that new last line is indented with 8 spaces.
6. Confirm that indentation on third line of file uses a single 8 column tab.

Space-based indentation with no size specified
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open ``space.txt``.
2. Confirm that no errors occur and EditorConfig file is read properly.
3. Add a new line of text to the end of the file and indent it once.
4. Confirm that new last line is indented with spaces.
5. Confirm that new last line indentation is the same size as the first line.


Tab-based indentation
-----------------------

The following tests are for tab-based indentation (``indent_style = tab``).

Tab-based indentation with no size specified
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open ``tab.txt``.
2. Confirm that no errors occur and EditorConfig file is read properly.
3. Add a new line of text to the end of the file and indent it once.
4. Confirm that new last line is indented with a single tab.

Tab-based indentation with size of 4
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open ``4_tab.txt``.
2. Confirm that no errors occur and EditorConfig file is read properly.
3. Add a new line of text to the end of the file and indent it once.
4. Confirm that new last line is indented with a single tab.

Tab-based indentation with size of 4 and tab width of 8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Open ``4_tab_width_of_8.txt``.
2. Confirm that no errors occur and EditorConfig file is read properly.
3. Add a new line of text to the end of the file and indent it once.
4. Confirm that new last line is indented with 4 spaces.
5. Add a second new line of text to the end of the file and indent it twice.
6. Confirm that new last line is indented with a single tab.
