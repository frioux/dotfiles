# Example usage of mduem




# $ make
# or
# $ make all
# or
# $ make build
# to generate all files which can be generated from other files.

# Files to generate.
TARGETS_GENERATED :=# In this example, there is no generated file.




# $ make install
# to install all files into a specified location.

# The location to install files.
INSTALLATION_DIR := $(HOME)/.vim

# Files in $(TARGETS_GENERATED) and $(TARGETS_STATIC) are installed.
# Use $(TARGETS_STATIC) to specify files which are not generated.
TARGETS_STATIC := autoload/smartchr.vim doc/smartchr.txt

# Function to compute the path to install a file.  Usually it is not necessary
# to override this.  The default one means that a file is copied under
# $(INSTALLATION_DIR) with its directory structure.
#
# For example, "autoload/smartchr.vim" is copied to
# "$(INSTALLATION_DIR)/autoload/smartchr.vim".  In this example,
# $(INSTALLATION_DIR) is "$(HOME)/.vim", so that the file is copied to
# "$(HOME)/.vim/autoload/smartchr.vim".
#
# RENAME_TARGET = $(patsubst %,$(INSTALLATION_DIR)/%,$(1))

# While installation, if a file contains "@@VERSION@@", it is expanded to
# a version number which is automatically computed from the current git
# repository, then the expanded one is installed instead of the original one.
#
# But some files should be installed as-is.  $(SHOULD_INSTALL_ASIS_P) is used
# to determine what files to be installed as-is.  This function takes the path
# to a file.  If this function yields non-empty value, a given file is
# installed as-is.
#
# SHOULD_INSTALL_ASIS_P =# All files are version-filtered by default.

# Sometimes it's necessary to do some tasks after installation.  List such
# targets (as tasks) in $(TARGETS_POST_INSTALL).
#
# For example, it is necessary to update the help tags for Vim plugins which
# are installed by user.  So the following rules should be added:
#
# $(INSTALLATION_DIR)/doc/tags: doc/smartchr.txt
#         vim -n -N -u NONE -U NONE -e -c 'helptags $(dir $@) | qall!'
# TARGETS_POST_INSTALL := $(INSTALLATION_DIR)/doc/tags
#
# By default, mduem recognizes the current repository is for Vim script if the
# name of the current directory starts with "vim-".  In such a case, the above
# rules are automatically defined, so that user doesn't have to write them.
#
# However, it's possible to explicitly specify the type of the current
# repository as follows:
#
#   # For Vim-script repository.
# REPOS_TYPE := vim-script
#   # For any software.
# REPOS_TYPE := generic




# $ make clean
# to delete all generated files and all junk files.




# $ make pack
# to create a package (as a zip file, currently).  If there is an appropriate
# tag in the current git repository, its name is used as the version number
# for a package to create.

# By default, all files in the current repository and all generated files
# (which are listed by $(TARGETS_GENERATED)) are included into a package.
#
# If it is necessary to include other files or to exclude some files in the
# current repository, list them in $(TARGETS_ARCHIVED).  For example,
#
# To add other files:
#     TARGETS_ARCHIVED = $(all_files_in_repos) and other files
#
# To exclude some files from all files in the current repository:
#     TARGETS_ARCHIVED = $(filter %.txt,$(all_files_in_repos))




# $ make test
# to test.
#
# Each test case consists of two files - {case}.input and {case}.expected.
# These files are put in "test" directory.  $(TEST_RULE) is executed and its
# output is compared to the content of {case}.expected.  If there is no
# difference between the files, test {case} is passed.  Otherwise it is
# failed.

# By default, {case}.input is treated as a shell script and it is source'd to
# get output.  If the current repository is for Vim script, vim-vspec is used
# instead.
#
# To customize $(TEST_RULE), write like the following:
#
# define TEST_RULE
#         # $< = {case}.input
#         # $@ = a temporary file to store output
#         source './$<' &>'$@' || { cat '$@'; false; }
# endef
#
# If there are additional dependencies for $(TEST_RULE), list them in
# $(TEST_RULE_DEPS).  For example, all tests for a Vim script are dependent on
# *.vim files in the current repository.  To denote this, write as follows:
#
# TEST_RULE_DEPS = $(filter %.vim,$(all_files_in_repos))

# A project (= superproject) usually depends on some projects (= subprojects).
# It's necessary to set up the subprojects to test the superproject.  If there
# are such subprojects to set up, list their names in $(DEPS).  For example:

DEPS := vim-vspec

# Each subproject has its own official repository.  Define the URI of each
# repository as follows.  (Note that mduem supports only git repository)

DEPS_vim_vspec_URI := git://github.com/kana/vim-vspec.git

# The superproject requires specific versions of subprojects.  To denote it,
# write as follows.  (note that these "versions" are used as <commit-ish>s)

DEPS_vim_vspec_VERSION := 0.0.3a1

# Note that mduem automatically adds the above configuration for Vim-script
# repository.  So that it's not necessary to set up by manually.  Usually, all
# user has to do is to add configuration for Vim scripts except vim-vspec.
#
# But sometimes it's necessary to specify to use a specific version of
# vim-vspec.  In such a case, user may override DEPS_vim_vspec_URI and
#  DEPS_vim_vspec_VERSION.




# Include mduem's Makefile.  It must be included after all of user's
# configuration to avoid overriding it.
include ../../Makefile

# __END__
