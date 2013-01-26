# Gollum Rails

# Usage

Put

```
gem 'gollum_rails'
```

in your `Gemfile`

If you want add an initializer into e.g. `config/initializers/gollum_rails.rb`

```
Gollum::Rails::Wiki.new(<location>)

```

Explanation:

`Gollum::Rails::Wiki` spawns a new instance of the gollum wiki and sets it in the Dependency Injection container

`<location>` is the location to your GIT repository, containing the pages

Now you can extend a model with the Page class and treat it as a normal ActiveModel

```
class Page < Gollum::Rails::Page

end
```

# Api

# TODO
* List all pages
* Search pages
* embed gollum :markdown editor
