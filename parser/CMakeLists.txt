#
# Copyright (c) 2011-2013 EditorConfig Team
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

# Basic parser tests

# test repeat sections
new_ec_test(repeat_sections basic.in a.a "^option1=value1[ \t]*[\n\r]+option2=value2[ \t\n\r]*$")
new_ec_test(basic_cascade basic.in b.b "^option1=c[ \t]*[\n\r]+option2=b[ \t\n\r]*$")

# Tests for whitespace parsing

# test no whitespaces in property assignment
new_ec_test(no_whitespace whitespace.in test1.c "^key=value[ \t\n\r]*$")

# test single spaces around equals sign
new_ec_test(single_spaces_around_equals whitespace.in test2.c
    "^key=value[ \t\n\r]*$")

# test multiple spaces around equals sign
new_ec_test(multiple_spaces_around_equals whitespace.in test3.c
    "^key=value[ \t\n\r]*$")

# test spaces before property name
new_ec_test(spaces_before_property_name whitespace.in test4.c
    "^key=value[ \t\n\r]*$")

# test spaces before after property value
new_ec_test(spaces_after_property_value whitespace.in test5.c
    "^key=value[ \t\n\r]*$")

# test blank lines between properties
new_ec_test(blank_lines_between_properties whitespace.in test6.c 
    "^key1=value1[ \t]*[\n\r]+key2=value2[ \t\n\r]*$")

# test spaces in section name
new_ec_test(spaces_in_section_name whitespace.in " test 7 "
    "^key=value[ \t\n\r]*$")

# test spaces before section name are ignored
new_ec_test(spaces_before_section_name whitespace.in test8.c
    "^key=value[ \t\n\r]*$")

# test spaces after section name
new_ec_test(spaces_after_section_name whitespace.in test9.c "^key=value[ \t\n\r]*$")

# test spaces at beginning of line between properties
new_ec_test(spaces_before_middle_property whitespace.in test10.c "^key1=value1[ \t]*[\n\r]+key2=value2[ \t]*[\n\r]+key3=value3[ \t\n\r]*$")

# test colon seperator with no whitespaces in property assignment
new_ec_test(colon_sep_no_whitespace whitespace.in test1.d "^key=value[ \t\n\r]*$")

# test colon seperator with single spaces around equals sign
new_ec_test(colon_sep_single_spaces_around_equals whitespace.in test2.d
    "^key=value[ \t\n\r]*$")

# test colon seperator with multiple spaces around equals sign
new_ec_test(colon_sep_multiple_spaces_around_equals whitespace.in test3.d
    "^key=value[ \t\n\r]*$")

# test colon seperator with spaces before property name
new_ec_test(colon_sep_spaces_before_property_name whitespace.in test4.d
    "^key=value[ \t\n\r]*$")

# test colon seperator with spaces before after property value
new_ec_test(colon_sep_spaces_after_property_value whitespace.in test5.d
    "^key=value[ \t\n\r]*$")


# Tests for comment parsing

# test comments ignored after property name
new_ec_test(comments_after_property comments.in test1.c
    "^key=value[ \t\n\r]*$")

# test comments ignored after section name
new_ec_test(comments_after_section comments.in test2.c
    "^key=value[ \t\n\r]*$")

# test comments ignored before properties
new_ec_test(comment_before_props comments.in test3.c
    "^key=value[ \t\n\r]*$")

# test comments ignored between properties
new_ec_test(comment_between_props comments.in test4.c
    "^key1=value1[ \t]*[\n\r]+key2=value2[ \t\n\r]*$")

# test semicolons at end of property value are included in value
new_ec_test(semicolon_in_property comments.in test5.c
    "^key=value; not comment[ \t\n\r]*$")

# test escaped semicolons are included in property value
new_ec_test(escaped_semicolon_in_property comments.in test6.c
    "^key=value ; not comment[ \t\n\r]*$")

# test escaped semicolons are included in section names
new_ec_test(escaped_semicolon_in_section comments.in "test;.c"
    "^key=value[ \t\n\r]*$")

# test octothorpe comments ignored after property name
new_ec_test(octothorpe_comments_after_property comments.in test7.c
    "^key=value[ \t\n\r]*$")

# test octothorpe comments ignored after section name
new_ec_test(octothorpe_comments_after_section comments.in test8.c
    "^key=value[ \t\n\r]*$")

# test octothorpe comments ignored before properties
new_ec_test(octothorpe_comment_before_props comments.in test9.c
    "^key=value[ \t\n\r]*$")

# test octothorpe comments ignored between properties
new_ec_test(octothorpe_comment_between_props comments.in test10.c
    "^key1=value1[ \t]*[\n\r]+key2=value2[ \t\n\r]*$")

# test octothorpe at end of property value are included in value
new_ec_test(octothorpe_in_property comments.in test11.c
    "^key=value; not comment[ \t\n\r]*$")

# test escaped octothorpes are included in property value
new_ec_test(escaped_octothorpe_in_property comments.in test12.c
    "^key=value ; not comment[ \t\n\r]*$")

# test escaped octothorpes are included in section names
new_ec_test(escaped_octothorpe_in_section comments.in "test\#.c"
    "^key=value[ \t\n\r]*$")

# test EditorConfig files with BOM at the head
new_ec_test(bom_at_head bom.in "a.c" "^key=value[ \t\n\r]*$")

# test EditorConfig files with CRLF line separators
new_ec_test(crlf_linesep crlf.in "a.c" "^key=value[ \t\n\r]*$")
