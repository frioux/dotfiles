---
files:
  - /home/frew/.vim/ftplugin/perl/perlomni.vim
  - /home/frew/.vim/bin/find_base_classes.pl
  - /home/frew/.vim/bin/perl_function_list.pl
  - /home/frew/.vim/bin/parse_moose_accessor.pl
  - /home/frew/.vim/ftplugin/perl/perl-completion.vim
  - /home/frew/.vim/bin/moose-type-constraints
  - /home/frew/.vim/perl/perl-functions
meta:
  author: Cornelius
  dependency:
    - name: libperl.vim
      required_files:
        - from: http://github.com/c9s/libperl.vim/raw/master/vimlib/autoload/libperl.vim
          target: autoload/libperl.vim
    - name: search-window.vim
      required_files:
        - from: http://github.com/c9s/search-window.vim/raw/master/vimlib/autoload/swindow.vim
          target: autoload/swindow.vim
  name: perl-completion.vim
  repository: http://github.com/c9s/perl-completion.vim
  script:
    - utils/find_base_classes.pl
    - utils/perl_function_list.pl
    - utils/parse_moose_accessor.pl
    - utils/moose-type-constraints
  script_id: 2852
  type: plugin
  version: 1.4
  version_from: vimlib/ftplugin/perl/perlomni.vim
  vim_version:
    op: '>='
    version: 7.0
