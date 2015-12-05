require "yahoo_weatherman"

zipcode = ""
if !ARGV[0]
 	puts "Curious about the weather today? Tell me your zip code!"
	zipcode = gets
else
    zipcode = ARGV[0]
	ARGV.clear
end

@client = Weatherman::Client.new(unit: 'f')
@lookup = @client.lookup_by_location(zipcode)

def findweather(zipcode)
	conditions = @lookup.forecasts[0]['text']
	temp = @lookup.condition['temp']
	is_today = 1
	print_conditions(temp, conditions, is_today)
end

def get_extended_forecast(zipcode)
	puts "Do you want the extended forecast [Y/N]?"
	answer = gets.chomp.downcase
	if answer == 'y'
		forecasts = @lookup.forecasts
		forecasts.each do |forecast|
			low = forecast['low']
			high = forecast['high']
			date = forecast['date']
			day = date.strftime("%A")
			day_of_week = date.strftime("%u")
			current_day = DateTime.now.strftime("%u")
			if current_day == day_of_week
				day = "Today"
			elsif current_day.to_i + 1 == day_of_week.to_i
				day = "Tomorrow"
			end
			temp = "#{day}'s forecast is between #{low} and #{high}"
			print_conditions(temp, forecast['text'], 0)
		end
	end
end

def print_conditions(temp, conditions, is_today)
	if is_today == 1
		if conditions == 'Clear'
			print "It's #{temp} and Clear, check for stars tonight!"
		elsif conditions.include? "Sunny"
			print "It's #{temp} and Sunny, put on some sunscreen!"
		elsif conditions.include? "Cloudy"
			print "It's #{temp} and Cloudy, go check out the cloud formations!"
		elsif conditions.include? "Rainy"
			print "It's #{temp} and Rainy, go take a nap!"
		elsif conditions.include? "Snowy"
			print "It's #{temp} and Snowy, go play outside!"
		end	
	else
		if conditions == 'Clear'
			print "#{temp} and Clear.""\n"
		elsif conditions.include? "Sunny"
			print "#{temp} and Sunny.""\n"
		elsif conditions.include? "Cloudy"
			print "#{temp} and Cloudy.""\n"
		elsif conditions.include? "Rainy"
			print "#{temp} and Rainy.""\n"
		elsif conditions.include? "Snowy"
			print "#{temp} and Snowy."
		end
	end
end

puts findweather(zipcode)
get_extended_forecast(zipcode)
