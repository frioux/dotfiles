$("th").filter(function() {
    var text = $(this).text();
    var results = text.match(/\d+\.(\d+)\.\d+/);

    if (!results || results[1] % 2 == 0) return false;
    return true;
}).parent().remove();
