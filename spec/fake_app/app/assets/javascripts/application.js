//= require jquery_ujs
//= require jcontroller
//= require_self
//= require_tree .

test_append_selector = '#test_append';
test_append = function(controller_namespace, filter, params) {
    var $div = $(document.createElement('div'));
    $div.attr("filter", controller_namespace + "/" + 'html' + "/" + filter);
    $div.append(params.s);
    $(test_append_selector).append($div);
};

create_routes = function(controller_path) {
    var test = function (filter, params) {
        test_append(controller_path, filter, params);
    };

    var hash = { html: {} };
    hash.html.state = function() {
        $(test_append_selector).html(JSON.stringify(this.state));
    };
    $.each(["before", "after", "index", "manually_execute", "manual_parameters", "parameters_template"], function(index, filter) {
        hash.html[filter] = function() {
            test(filter, this.params);
        }
    });
    Jcontroller.create(controller_path, hash);
};