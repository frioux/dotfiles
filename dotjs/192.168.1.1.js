$("table#conntrack_table tbody tr").filter(function() {
    var rows = $(this).children().slice(3,5);

    var re = /^192\.168\.1\.\d+$/;
    var remove = true;
    rows.each(function (x,y) {
        if (!$(y).text().match(re))
            remove = false;
    });
    return remove;
}).remove();
