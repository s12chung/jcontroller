var Jcontroller = {
    controllers_path: 'Jcontroller/controllers/',
    create: function(controller_path, definition) {
        Jcontroller.define_namespace(Jcontroller.controllers_path + controller_path,
            $.extend({
                    execute_action: function(action_name, params) {
                        var execute = function(f) {
                            if ($.isFunction(f)) f(params);
                        };
                        execute(this.before);
                        execute(this[action_name]);
                        execute(this.after);
                    }
                },
                definition
            )
        );
    },
    execute_action: function(controller_path, action_name, params) {
        var controller = Jcontroller.find(controller_path);
        if (Jcontroller.present(controller)) {
            controller.execute_action(action_name, params);
        }
    },

    blank: function(o) { return typeof o === "undefined" || o === null; },
    present: function(o) { return !Jcontroller.blank(o); },
    define_namespace: function(namespace_string, definition) {
        return $.extend(Jcontroller.get_or_create(namespace_string), definition);
    },
    get_or_create: function(namespace_string) {
        var current_namepace = window;
        $.each(namespace_string.split('/'), function(index, level) {
            if (Jcontroller.blank(current_namepace[level])) current_namepace[level] = {};
            current_namepace = current_namepace[level];
        });

        return current_namepace;
    },
    find: function(controller_path) {
        var namespace_string = Jcontroller.controllers_path + controller_path;

        var current_namepace = window;
        $.each(namespace_string.split('/'), function(index, level) {
            if (Jcontroller.blank(current_namepace[level])) return undefined;
            current_namepace = current_namepace[level];
        });
        return current_namepace;
    }
};