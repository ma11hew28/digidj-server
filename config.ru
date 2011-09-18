require "bundler"
Bundler.setup(:default, (ENV["RACK_ENV"] || "development").to_sym)

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "digidj"

use Sinatra::ShowExceptions if DigiDJ.env == "development"
run DigiDJ::Application
