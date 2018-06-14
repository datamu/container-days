wget https://raw.githubusercontent.com/anofox/m3_konferenz/master/prepared_data/london_smart_meter/smart_meters_london_cleaned_same_start_with_weather_example.csv

# energy, hour, weekday
awk -F , '{print $4, $11}' smart_meters_london_cleaned_same_start_with_weather_example.csv > smart_meter_clean.csv
