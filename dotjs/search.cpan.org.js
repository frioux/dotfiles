(function() {
var author_path = new RegExp('^/~([^/]+)/(.*)$');

$('a').each(function(i,x){
   var obj = $(this);
   var href = obj.attr('href');

   this.href = href.replace(author_path, function(match, author, path) {
      var middle = path.match(/\/$/)
        ? 'release'
        : 'module'
      ;

      return("http://metacpan.org/" + middle + "/" + author.toUpperCase() + '/' + path)
   });
})
})()
