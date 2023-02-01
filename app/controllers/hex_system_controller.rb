class HexSystemController < ApplicationController
	before_action :presets

	def hexmap
		raw_hexmap_data = SectorModel::System.hexmap

		organized_data = raw_hexmap_data.map {|point| {sys_id: point.id, n: point.name, q: point.q, r: point.r, hex_loc: point.location, colour:"rgb(247, 171, 45)"}}
		raw_json_data = organized_data.as_json.to_json
		parsed_data = JSON.parse(raw_json_data)
		formatted_data = {}
		parsed_data.each_with_index do |item, index|
				formatted_data[index] = item
		end

		gon.data = formatted_data
	end

	private
	
	def presets
		@page_libs = [:hexmap]
	end
	
end
