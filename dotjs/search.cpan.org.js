$('a').each(function(i,x){
   var obj = $(this);
   var href = obj.attr('href');
   var re = new RegExp('^/~([^/]+)/(.*)$');
   this.href = href.replace(re, 'https://metacpan.org/module/$1/$2');
})
