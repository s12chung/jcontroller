var Jcontroller = {
    controllers_path: 'Jcontroller/controllers/',
    application_controller_path: "application",
    create: function(controller_path, definition) {
        Jcontroller.define_namespace(Jcontroller.controllers_path + controller_path,
            $.extend({
                    parent_path: controller_path === this.application_controller_path ? undefined : "application",
                    parent: function() {
                        if (Jcontroller.blank(this.parent_cache)) {
                            this.parent_cache =  Jcontroller.find(this.parent_path);
                        }
                        return this.parent_cache;
                    },
                    execute_filter: function(filter, params) {
                        if ($.isFunction(filter)) filter(params);
                    },
                    execute_action: function(action_name, params) {
                        this.execute_post_order_filter('before', params);
                        this.execute_post_order_filter(action_name, params);
                        this.execute_pre_order_filter('after', params)
                    },
                    execute_post_order_filter: function(filter, params) {
                        if (Jcontroller.present(this.parent())) this.parent().execute_post_order_filter(filter, params);
                        this.execute_filter(this[filter], params);
                    },
                    execute_pre_order_filter: function(filter, params) {
                        this.execute_filter(this[filter], params);
                        if (Jcontroller.present(this.parent())) this.parent().execute_pre_order_filter(filter, params);
                    }
                },
                definition
            )
        );
    },
    execute_action: function(controller_path, action_name, params) {
        var controller = this.find(controller_path);
        if (this.present(controller)) {
            controller.execute_action(action_name, params);
        }
    },

    blank: function(o) { return typeof o === "undefined" || o === null; },
    present: function(o) { return !this.blank(o); },
    define_namespace: function(namespace_string, definition) {
        return $.extend(this.get_or_create(namespace_string), definition);
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
        if (this.blank(controller_path)) return undefined;
        var namespace_string = this.controllers_path + controller_path;

        var current_namepace = window;
        $.each(namespace_string.split('/'), function(index, level) {
            if (Jcontroller.blank(current_namepace[level])) return undefined;
            current_namepace = current_namepace[level];
        });
        return current_namepace;
    }
};