#
# Copyright (c) 2011-2012 EditorConfig Team
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


# Tests for *

# matches a single characters
new_ec_test(star_single star.in ace.c "^key=value[ \t\n\r]*$")

# matches zero characters
new_ec_test(star_zero star.in ae.c "^key=value[ \t\n\r]*$")

# matches multiple characters
new_ec_test(star_multiple star.in abcde.c "^key=value[ \t\n\r]*$")

# does not match path separator
new_ec_test(star_over_slash star.in a/e.c "^[ \t\n\r]*$")


# Tests for ?

# matches a single character
new_ec_test(question_single question.in some.c "^key=value[ \t\n\r]*$")

# does not match zero characters
new_ec_test(question_zero question.in som.c "^[ \t\n\r]*$")

# does not match multiple characters
new_ec_test(question_multiple question.in something.c "^[ \t\n\r]*$")


# Tests for [ and ]

# close bracket inside
new_ec_test(brackets_close_inside brackets.in ].g "^close_inside=true[ \t\n\r]*$")

# close bracket outside
new_ec_test(brackets_close_outside brackets.in b].g "^close_outside=true[ \t\n\r]*$")

# negative close bracket inside
new_ec_test(brackets_nclose_inside brackets.in c.g "^close_inside=false[ \t\n\r]*$")

# negative close bracket outside
new_ec_test(brackets_nclose_outside brackets.in c].g "^close_outside=false[ \t\n\r]*$")

# character choice
new_ec_test(brackets_choice brackets.in a.a "^choice=true[ \t\n\r]*$")

# character choice 2
new_ec_test(brackets_choice2 brackets.in c.a "^[ \t\n\r]*$")

# negative character choice
new_ec_test(brackets_nchoice brackets.in c.b "^choice=false[ \t\n\r]*$")

# negative character choice 2
new_ec_test(brackets_nchoice2 brackets.in a.b "^[ \t\n\r]*$")

# character range
new_ec_test(brackets_range brackets.in f.c "^range=true[ \t\n\r]*$")

# character range 2
new_ec_test(brackets_range2 brackets.in h.c "^[ \t\n\r]*$")

# negative character range
new_ec_test(brackets_nrange brackets.in h.d "^range=false[ \t\n\r]*$")

# negative character range 2
new_ec_test(brackets_nrange2 brackets.in f.d "^[ \t\n\r]*$")

# range and choice
new_ec_test(brackets_range_and_choice brackets.in e.e
    "^range_and_choice=true[ \t\n\r]*$")

# character choice with a dash
new_ec_test(brackets_choice_with_dash brackets.in -.f
    "^choice_with_dash=true[ \t\n\r]*$")


# Tests for **

# matches over path separator
new_ec_test(star_star_over_separator star_star.in a/e.c "^key=value[ \t\n\r]*$")

