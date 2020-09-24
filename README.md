# Attributed
Attributed is a gem for rails application that allows single model instances to have different write permissions on different attributes of the same model.
For example, imagine that a certain role, like an admin, has to be able to update all attributes of a certain model, but a normal user cannot update an important or reserved one.
The gem achieves this result by filtering out certain params from the permitted params inside the controller.

## Installation
Inside your Gemfile put

    gem 'attributed'

and then run

    bundle install

In each model you want to have the feature, just put the following.

    include Attributed::Model

Once this config file is created, you can launch the following command.

    rails g attributed_migration

The command above will generate a migration file in your project. Now you can migrate.

    rails db:migrate

## Usage

Create one `Attributed::Item` for each class you need. The name of the item has to be PascalCase.

    role = attributes_lists.create(name: 'Order', authorized_attributes: ['number', 'date', 'description'])

In your controller you will have the method `filter_authorized_attributes` which accepts as arguments an array of parameters. By default the name of the controller (orders in this case) will be used to find the attributes_list with that name singularized, so an attributes_list with the item that has `name = 'Order'`. You can override this search key passing a second argument `item_name: 'SomethingElse'`.

For example, in a controller method where you permit you attributes, this

    def permitted_resource_params
      params.require(resource_name.to_sym).permit([:number, :date, :description, :attribute1, :attribute2])
    end

becomes like this

    def permitted_resource_params
      params.require(resource_name.to_sym).permit(filter_authorized_attributes([:number, :date, :description, :attribute1, :attribute2]))
    end

The method `filter_authorized_attributes` works with the intersection of the two arrays of attributes: this means that if you add an attribute inside the `attributes_list.authorized_attributes` column, it will still not be permitted unless it is also present in the other array. This means that in the controller you still have to list all permitted attributes possible like you did before, but with this gem you will decide who gets to write on which ones.
