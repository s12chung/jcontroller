# Jcontroller [![Gem Version](https://badge.fury.io/rb/jcontroller.png)](http://badge.fury.io/rb/jcontroller) [![Build Status](https://travis-ci.org/s12chung/jcontroller.png?branch=master)](https://travis-ci.org/s12chung/jcontroller?branch=master) [![Code Climate](https://codeclimate.com/github/s12chung/jcontroller.png)](https://codeclimate.com/github/s12chung/jcontroller)
Rails controller based javascript to keep your javascript outside of your views.

Based off [Paul Irish's DOM-based Routing](http://www.paulirish.com/2009/markup-based-unobtrusive-comprehensive-dom-ready-execution/)
(or Garber-Irish Implementation). __Works with turbolinks__.

## How it works
```javascript
Jcontroller.create('users', {
    html: {
        // executes whenever users#index with html format is executed
        index: function() {}
    }
});
```
No other code is needed.

## Installation
Add `gem 'jcontroller'` to your application's `Gemfile` and run the `bundle` command, then add this to your `app/assets/javascripts/application.js`

    //= require jcontroller
    
## Controllers
### Namespaces
Jcontroller creation and finding are based off the controller path.
```javascript
// for Admin::UsersController
Jcontroller.create('admin/users', {});
```
### Filters
Jcontrollers can be created with before and after filters like so:
```javascript
Jcontroller.create('users', {
    html: {
        // executes for all html format responses for UsersController, before the specific action
        before: function() {}
        // executes whenever users#index with html format is executed
        index: function() {}
        // executes for all html format responses for UsersController, after the specific action
        after: function() {}
    }
});
```
### Inheritance
By default, jcontrollers inherit from the `application` jcontroller and will execute it if it exists, such as:
```javascript
Jcontroller.create('application', {
    html: {
        before: function() {}
        index: function() {}
        after: function() {}
    }
});
```
So with the jcontrollers above the order of execution is:
- `application.before`
- `users.before`
- `application.index`
- `users.index`
- `application.after`
- `users.after`

You can also set your own inhertance chain:
```javascript
Jcontroller.create('users', { 
    parent_path: 'users_base',
    ...
});
```
### API
- Parameters are accessed from `this.params` or as the first parameter
- The request state (controller_path, action_name, jcontroller, etc.) are also given in `this.state` or the second parameter
- And other methods to work with jcontrollers
```javascript
Jcontroller.create('users', {
    html: {
        index: function(params, state) {
            //this.params === params
            console.log(this.params);
            //this.state === state
            console.log(this.state);
            
            var jcontroller = JController.find('application');
            self.parent(); // === jcontroller
            
            //excute application_jcontroller for this state and params again
            jcontroller.execute_jaction(this.state, this.params);
            //execute application_jcontroller html.index function
            jcontroller.html.index();
        }
    }
});
```
### Organization
I like having a jcontrollers directory and calling my files as jcontroller files (ex. users_jcontroller.js).
## Parameters
### Manual
Use the `js` method with the `params` option.
```ruby
class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        js { :params => { :id => @user.id } }
    end
end
```
### From view template
You can also create parameters using a JSON DSL (such as [jbuilder](https://github.com/rails/jbuilder/)) by creating a template named `<action_name>_params.js.<DSL suffix>`:
```ruby
# app/views/users/show_params.js.jbuilder
json.id @user.id
```

## Controlling javascript execution
### Stop
Stop all execution of all filters and methods for the action:
```ruby
class UsersController < ApplicationController
    def index
        js false
    end
end
```
### Different jcontroller
Execute a different jcontroller:
```ruby
class UsersController < ApplicationController
    def index
        # same as "users#index.html", parameters and options are optional
        js "users/show.html", { :params => { ... } }
    end
end
```

### HTML view
Execute all filters and actions related to a action:
```erb
<!-- same as "users#index.html", parameters and options are optional -->
<%= execute_jaction "users/show.html", { :params => { ... } } %>
```

### Manually filter in Javascript
You can use the given [state](#api) to stop execution of functions:
```javascript
Jcontroller.create('application', {
    html: {
        before: function() {
            if (this.state.action_name === 'destroy') { }
        }
    }
});
```
### Redirect
You can execute all filters and functions of the current action before the redirected action using:
```ruby
class UsersController < ApplicationController
    def index
        js { :redirect => true }
        redirect_to user_path(User.first)
    end
end
```
So `users/index.html` will be executed before `users/show.html`.

## Ajax
You can optionally execute jcontrollers for ajax instead of writing javascript in views by turning it in `config/application.rb`:
```ruby
Jcontroller.ajax = true
```
Jcontrollers will automatically execute with parameters given by the template with a JSON DSL:
```ruby
# app/views/users/show.js.jbuilder
json.id @user.id
```

## Credits
Extracted out of [Placemark](https://www.placemarkhq.com/). Originally called [dom_routes](https://github.com/s12chung/dom_routes). An alternative is [paloma](https://github.com/kbparagua/paloma).