$(function() {
    var cache_drug = {};
    var cache_se = {};
    var cache_iu = {};
    $("#dname, #compare_dname, #compare_dname_2").autocomplete({
        minLength: 3,
        source: function(request, response) {
            predict(cache_drug, request, response, "drug_name");
        }
    });

    $("#se").autocomplete({
        minLength: 3,
        source: function(request, response) {
            predict(cache_se, request, response, "side_effect");
        }
    });

    $("#iu").autocomplete({
        minLength: 3,
        source: function(request, response) {
            predict(cache_iu, request, response, "indication_use");
        }
    });

    function predict(cache, request, response, field) {
        var req = request.term;
        var term = req.substring(0, 3);

        if (term in cache) {
            if (req in cache) {
                response(cache[req]);
                return;
            } else {
                var length = req.length;

                var sliced;
                while (length > 3) {
                    sliced = req.substring(0, length - 1);

                    if (sliced in cache) {

                        cache[req] = $.grep(cache[sliced], function(n, i) {
                            return n.toUpperCase().includes(req.toUpperCase());
                        });

                        response(cache[req]);
                        return;
                        break;
                    }
                    length = length - 1;
                }
            }
        }

        $.getJSON('/drug/suggest_' + field, request, function(data, status, xhr) {
            cache[term] = data;
            response(data);
        });
    }

    $("#df_show, #dt_show").datepicker({
        dateFormat: "dd-mm-yy",
        altFormat: "yymmdd",
        yearRange: "2014:2017",
        changeYear: true,
        changeMonth: true,
        defaultDate: "01-01-14"
    });
    $("#df_show").datepicker("option", "altField", "#df");
    $("#dt_show").datepicker("option", "altField", "#dt");

});
