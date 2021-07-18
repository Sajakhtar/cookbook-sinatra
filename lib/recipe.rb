class Recipe
  attr_reader :name, :description, :rating, :prep_time

  def initialize(recipe)
    @name = recipe[:name]
    @description = recipe[:description]
    @rating = recipe[:rating]
    @prep_time = recipe[:prep_time]
    @done = recipe[:done]
  end

  def mark_as_done!
    @done = true
  end

  def done?
    @done
  end
end
