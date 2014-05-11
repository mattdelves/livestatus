require 'influxdb'

influxdb = InfluxDB::Client.new

databases = influxdb.get_database_list
database_name = "livestatus"

database_names = databases.collect { |database| database["name"] }

influxdb.create_database(database_name) unless database_names.include?(database_name)
