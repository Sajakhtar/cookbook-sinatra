require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []

    load_from_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe

    save_to_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)

    save_to_csv
  end

  def mark_as_done(index)
    @recipes[index].mark_as_done!

    save_to_csv
  end

  private

  def load_from_csv
    CSV.foreach(@csv_file_path) do |row|
      done = row[4] == 'true'
      @recipes << Recipe.new({ name: row[0], description: row[1], rating: row[2], prep_time: row[3], done: done })
    end
  end

  def save_to_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each { |rcp| csv << [rcp.name, rcp.description, rcp.rating, rcp.prep_time, rcp.done?] }
    end
  end
end
