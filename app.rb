require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     


# enter your Dark Sky API key here
ForecastIO.api_key = "1980ed0614a7bb78f55579cf1ccf75ff"

# do the heavy lifting, use Global Hub lat/long
forecast = ForecastIO.forecast(42.0574063,-87.6722787).to_hash

# pp = pretty print
# use instead of `puts` to make reading a hash a lot easier
# e.g. `pp forecast`
current_temperature = forecast["currently"]["temperature"]
conditions = forecast["currently"]["summary"]
puts "In Evanston, it is currently #{current_temperature} and #{conditions}"
# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]


url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=7b70131c38dc4b61880255f84a92d961"
news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output

get "/" do
  view "ask"
end

get "/news" do
 results = Geocoder.search(params["q"])
    @lat_long = results.first.coordinates # => [lat, long]
    
    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash
@current_temperature = forecast["currently"]["temperature"]
@conditions = @forecast["currently"]["summary"]
puts "In Evanston, it is currently #{current_temperature} and #{conditions}"
# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]
daytrait = []
for day in forecast["daily"]["data"]
  daytrait << "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
end
@future = daytrait

#titles = []
#for x in news["articles"]
#    titles << "#{x["title"]}"
#end
#@headlines = titles
view "news"
end