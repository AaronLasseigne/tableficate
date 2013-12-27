# Tableficate
A DSL for easy table creation with sorting and filtering. It tries to do to tables what simple_form and formtastic have done for forms. Below you'll find basic documentation with more compelete docs in the [wiki](https://github.com/AaronLasseigne/tableficate/wiki).

This project follows [Semantic Versioning](http://semver.org/).

## Installation

    $ gem install tableficate

If you're using Bundler, add this to your Gemfile:

    gem 'tableficate', '~>0.4.0'

## Support

<table>
  <tr>
    <td><strong>Ruby</strong></td>
    <td>1.9</td>
  </tr>
  <tr>
    <td><strong>Rails</strong></td>
    <td>3.1</td>
  </tr>
  <tr>
    <td><strong>Database Framework</strong></td>
    <td>ActiveRecord</td>
  </tr>
  <tr>
    <td><strong>Templating</strong></td>
    <td>Any templating engine can be used. The default theme uses ERB.</td>
  </tr>
  <tr>
    <td><strong>Pagination</strong></td>
    <td>Any pagination can be used. The default theme has built-in support for Kaminari and will_paginate.</td>
  </tr>
</table>

## Basic Usage
Let's say that we want to create a table that lists active accounts in the system with their time of creation and the name on the account.

Our controller:

    @accounts = Accounts.active.tableficate(params[:accounts]).page(params.try(:[], :accounts_page) || 1)

Here we're getting active accounts, calling tableficate and then paginating with Kaminari. Tableficate works on Arel objects and passes out an Arel so you can add things like pagination. We pass in the params for the table we'll create in the view. By default `:accounts` is derived from the database table name of the primary table in the query.

Our View:

    <%= table_for @accounts, show_sorts: true do |t| %>
      <% t.column :id, header: 'Account Number' %>
      <% t.column :created_at do |account| %>
        <%= account.created_at.strftime('%m/%d/%Y') %>
      <% end %>
      <% t.column :first_name %>
      <% t.column :last_name %>
      <% t.actions do |account| %>
        <%= link_to('View', account_path(account)) %>
      <% end %>

      <% t.filter :first_name %>
      <% t.filter :last_name %>
    <% end %>

This creates a sortable table with 2 filters, 4 data columns and a column for actions. Column headers are automatically generated but can be overridden as seen on `:id`. The column output can also be overridden by passing a block to the call. This setup only covers basic functionality. Some of the more advanced functionality requires you to wrap your scope in a special table model.

Having created the basic table we now want to default the sorting to show newest accounts first and we want `:first_name` and `:last_name` to be merged into one column. First, create a table model.

In "app/tables/" we'll create a new table model using the generator. Provide the name of the new table model and then the model being wrapped.

    $ rails generate tableficate:table AccountReport Account

Our table model:

    class AccountReport < Tableficate::Base
      scope :account

      default_sort :created_at, 'DESC'

      column :full_name, sort: 'first_name ASC, last_name ASC'

      filter :full_name do |value, scope|
        first_name, last_name = value.split(/\s+/)

        if last_name.nil?
          scope.where(['first_name LIKE ? OR last_name LIKE ?', first_name, first_name])
        else
          scope.where(['first_name LIKE ? AND last_name LIKE ?', first_name, last_name])
        end 
      end
    end

We've defined a scope that we're wrapping. Then we provide a default sorting and explain how to sort and filter a new column called `:full_name`.

Our new controller using `AccountReport`:

    @accounts = AccountReport.active.tableficate(params[:accounts]).page(params.try(:[], :accounts_page) || 1)

Our new view using `:full_name`:

    <%= table_for @accounts, show_sorts: true do |t| %>
      <% t.column :id, header: 'Account Number' %>
      <% t.column :created_at do |account| %>
        <%= account.created_at.strftime('%m/%d/%Y') %>
      <% end %>
      <% t.column :full_name do |account| %>
        <%= "#{account.first_name} #{account.last_name}" %>
      <% end %>
      <% t.actions do |account| %>
        <%= link_to('View', account_path(account)) %>
      <% end %>

      <% t.filter :full_name %>
    <% end %>

Now we have default sorting, sortable columns and a full name filter.

## Themes

New themes can be created using the theme generator.

    $ rails generate tableficate:theme foo

The theme can then be applied to a table.

    <%= table_for @records, theme: 'foo' do |t| %>
      ...
    <% end %>
    
[Find out more about themes.](https://github.com/AaronLasseigne/tableficate/wiki/Custom-Themes)

## Changes Needed to Upgrade From 0.3

1. The hidden `sort` and `dir` fields should be removed from the `filters/_form.html.erb` partial and replaced with `<%= tableficate_hidden_tags(table) %>`.
2. The `sort` and `dir` fields have been merged into `order`.
3. The :as option on table_for has been removed. This is now set on the tableficate scope using :param_namespace. The first parameter to tableficate should now be the params hash. This means that `tableficate(params[:foo])` will now be `tableficate(params)`. Additionally, the '_header.html.erb' partial should replace the sorting links with `link_with_order`. 