class HexSystemController < ApplicationController
	before_action :presets

	def hexmap
		@factions = SectorModel::Faction.where(sector_id: params[:sector_id])
		raw_hexmap_data = SectorModel::System.hexmap(params[:sector_id])

		organized_data = raw_hexmap_data.map {|point| {sys_id: point.id, n: point.name, q: point.q, r: point.r, hex_loc: point.location,
			colour: "#{point.color_code.nil? ? "rgb(247, 171, 45)" : point.color_code}"}}
			
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