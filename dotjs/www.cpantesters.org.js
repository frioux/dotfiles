$("table.test_results tbody tr").filter(function() {
   var text = $(this).text();

   if (text.match(/RC\d+/)) return true;

   var results = text.match(/\d+\.(\d+)\.\d+/);
   if (!results || results[1] % 2 == 0) return false;

   return true;
}).remove();
