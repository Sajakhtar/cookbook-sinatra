require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require './lib/cookbook'
require './lib/recipe'
require './lib/service'
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file   = File.join(__dir__, './lib/recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  @recipe = Recipe.new({ name: params[:name], description: params[:description], rating: params[:rating], prep_time: params[:prep_time], done: false })
  csv_file   = File.join(__dir__, './lib/recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.add_recipe(@recipe)
  redirect to '/'
end

get '/destroy/:index' do
  csv_file   = File.join(__dir__, './lib/recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/search' do
  erb :search
end

post '/import' do
  # @results = Service.new(params[:ingredient]).scrape_recipes
  # binding.pry
  redirect to "/results/:#{params[:ingredient]}"
end

get '/results/:ingredient' do
  @recipes = Service.new(params[:ingredient]).scrape_recipes
  erb :results
end

get '/test' do
  # '<h1>Hello <em>world</em>!</h1>'
  @usernames = %w[ssaunier Papillard]
  erb :test
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
