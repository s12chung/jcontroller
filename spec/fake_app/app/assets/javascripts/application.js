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

create_routes = function(controller_path, extend) {
    var set_basic_filters = function(format, filters) {
        $.each(filters, function(index, filter) {
            hash[format][filter] = function() {
                test_append(controller_path, filter, this.params);
            }
        });
    };

    var hash = { html: {}, js: {} };
    hash.html.state = function() {
        $(test_append_selector).html(JSON.stringify(this.state));
    };
    set_basic_filters('html', ["before", "after", "index", "manually_execute", "manual_parameters", "parameters_template"]);
    set_basic_filters('js', ["before", "after", "index"]);
    if (Jcontroller.present(extend)) $.extend(hash, extend);
    Jcontroller.create(controller_path, hash);
};