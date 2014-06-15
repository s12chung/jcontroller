var Jcontroller = {
    controllers_path: 'Jcontroller/controllers/',
    application_controller_path: "application",
    create: function(controller_path, definition) {
        Jcontroller.define_namespace(Jcontroller.controllers_path + controller_path,
            $.extend({
                    parent_path: controller_path === this.application_controller_path ? undefined : "application",
                    parent: function() {
                        if (Jcontroller.blank(this.parent_cache)) { this.parent_cache =  Jcontroller.find(this.parent_path); }
                        return this.parent_cache;
                    },

                    dup: function(state, params) {
                        var dup = $.extend({}, this, state.jaction);
                        dup.state = state;
                        dup.params = params;
                        if (Jcontroller.present(dup.parent())) { dup.parent_cache = dup.parent().dup(state, params); }
                        return dup;
                    },

                    execute_action: function() {
                        if ($.isPlainObject(this.html)) {
                            this.execute_post_order_filter('before');
                            this.execute_post_order_filter(this.action_name);
                            this.execute_pre_order_filter('after');
                        }
                    },
                    execute_post_order_filter: function(filter) {
                        if (Jcontroller.present(this.parent())) this.parent().execute_post_order_filter(filter);
                        this.execute_filter(this[this.format][filter]);
                    },
                    execute_pre_order_filter: function(filter) {
                        this.execute_filter(this[this.format][filter]);
                        if (Jcontroller.present(this.parent())) this.parent().execute_pre_order_filter(filter);
                    },
                    execute_filter: function(filter) {
                        if ($.isFunction(filter)) { $.proxy(filter, this)(); }
                    }
                },
                definition
            )
        );
    },
    execute_jaction: function(state, params) {
        var controller = this.find(state.jaction.controller_path);
        if (this.present(controller)) { controller.dup(state, params).execute_action(); }
    },

    blank: function(o) { return typeof o === "undefined" || o === null; },
    present: function(o) { return !this.blank(o); },

    define_namespace: function(namespace_string, definition) {
        return $.extend(this.get_or_create(namespace_string), definition);
    },
    get_or_create: function(namespace_string) {
        var current_namepace = window;
        $.each(namespace_string.split('/'), function(index, level) {
            if (Jcontroller.blank(current_namepace[level])) { current_namepace[level] = {}; }
            current_namepace = current_namepace[level];
        });

        return current_namepace;
    },
    find: function(controller_path) {
        if (this.blank(controller_path)) { return undefined; }
        var namespace_string = this.controllers_path + controller_path;

        var current_namepace = window;
        $.each(namespace_string.split('/'), function(index, level) {
            if (Jcontroller.blank(current_namepace[level])) {
                current_namepace = undefined;
                return false;
            }
            current_namepace = current_namepace[level];
        });
        return current_namepace;
    }
};