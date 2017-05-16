# lost.vim

Vim plugin to provide a command to help you orient yourself when editing a large
chunk of code.  While we should try to avoid having huge functions or huge
classes or huge blobs of code, they will likely exist forever and I aim to make
working with them less painful.

## Example

Imagine you have the following code block, and the cursor is where the `|` is:

```
sub foo {
   # 1000 lines of nonsense
   |dwigt();
   # 1000 more lines of nonsense
}
```

If you run the `:Lost` command you will see `sub foo {` at the bottom of your
vim window.  Nice!

[![Here's an asciinema demo](https://asciinema.org/a/2b64vpw1pmx3fl94ly1q4kyi8.png)](https://asciinema.org/a/2b64vpw1pmx3fl94ly1q4kyi8)

## Inspiration

(The following is quoted from [the blog
post](https://blog.afoolishmanifesto.com/posts/file-context-lost-in-a-file/)
where I had the idea for this tool.)

One of the subtle brilliances that `git` provides is context other than simple
line numbers in diffs.  I know that it wasn't the first tool to implement such a
feature (`diff -p` does the same thing) but it was the first one that I've seen
use it by default.  For example, the diff
[here](https://github.com/frioux/DBIx-Class-Helpers/commit/2bef898e9c2c70c79d269c7222e619ac08be027c#diff-541385fdf1ae526e444d502ed0483b3cL33)
includes the following snippet:

```
@@ -33,9 +44,9 @@ sub _defaults {
    my ($self, $params) = @_;

    $params->{namespace}           ||= [ get_namespace_parts($self) ]->[0];
-   $params->{left_method}         ||= String::CamelCase::decamelize($params->{left_class});
-   $params->{right_method}        ||= String::CamelCase::decamelize($params->{right_class});
-   $params->{self_method}         ||= String::CamelCase::decamelize($self);
+   $params->{left_method}         ||= $decamelize->($params->{left_class});
+   $params->{right_method}        ||= $decamelize->($params->{right_class});
+   $params->{self_method}         ||= $decamelize->($self);
    $params->{left_method_plural}  ||= $self->_pluralize($params->{left_method});
    $params->{right_method_plural} ||= $self->_pluralize($params->{right_method});
    $params->{self_method_plural}  ||= $self->_pluralize($params->{self_method});

```

The top of the snippet is the function that the change was made in.  The
context is not always perfect, but it's right so often it is astounding.  This
is exactly what I wanted, but generalized.

## Installation

If you don't have a preferred installation method, I recommend installing
[pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and
paste:

    cd ~/.vim/bundle
    git clone git://github.com/frioux/vim-lost

Once help tags have been generated, you can view the manual with
`:help lost`.

## Self-Promotion

Like lost.vim? Follow the repository on
[GitHub](https://github.com/frioux/vim-lost).  And if you're feeling especially
charitable, follow [frioux](https://blog.afoolishmanifesto.com) on
[Twitter](http://twitter.com/frioux) and [GitHub](https://github.com/frioux).

## License

Copyright (c) Arthur Axel fREW Schmidt.  Distributed under the same terms as Vim
itself.  See `:help license`.
