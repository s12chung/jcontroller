//= require jquery_ujs
//= require jcontroller
//= require_self
//= require_tree .

test_append = function(controller_namespace, filter, params) {
    var $div = $(document.createElement('div'));
    $div.attr("filter", controller_namespace + "/" + 'html' + "/" + filter);
    $div.append(params.s);
    $('#test_append').append($div);
};

create_routes = function(controller_path) {
    var test = function (filter, params) {
        test_append(controller_path, filter, params);
    };

    Jcontroller.create(controller_path, {
        before: function (params) {
            test("before", params);
        },
        index: function (params) {
            test("index", params);
        },
        after: function (params) {
            test("after", params);
        }
    });
};