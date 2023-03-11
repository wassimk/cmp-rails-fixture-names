# cmp-rails-fixture-names

This plugin is a source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) to complete Ruby on Rails fixture **names**. Names meaning the individual fixtures each fixture **type** represents.

For example, a `User` model would have a `users` fixture **type** and each fixture has a **name**. If you have a user fixture called `bob`. This cmp source will auto-complete the fixture name _bob_ when you type `users(:`.

It will also parse the fixture file and show the fixture data/attributes in the documentation window.

There is a companion plugin, called [cmp-rails-fixture-types](https://github.com/wassimk/cmp-rails-fixture-types) that only completes fixture **types**.

## Setup

### Prerequisites

Fixtures must exist in the default location of `test/fixtures` or `spec/fixtures` and be `.yml` files.

This plugin regex parses the YAML files for completion data so anything fancy like a Ruby loop that generates fixtures will likely break.

### Installation

Install **cmp-rails-fixture-names** using your plugin manager of choice. For example, here it is using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "wassimk/cmp-rails-fixture-names", version = "*", ft = "ruby" },
  },
}
```

Then add `rails-fixture-names` source in your **nvim-cmp** configuration:

```lua
require('cmp').setup {
  -- ...
  sources = {
    { name = 'rails-fixture-names' },
    -- other sources ...
  },
  -- ...
}
```
