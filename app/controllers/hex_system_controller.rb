class HexSystemController < ApplicationController
	before_action :presets

	def hexmap
		@sector = SectorModel::Sector.find_by(id: params[:sector_id])
		if @sector.nil?
			redirect_to sectors_path, alert: "Sector not found."
			return
		end

		unless can_view_sector?(@sector, current_user)
			redirect_back_or_to sectors_path, alert: "You do not have permission to view this sector's hexmap."
			return
		end

		@factions = SectorModel::Faction.where(sector_id: @sector.id)
		raw_hexmap_data = SectorModel::System.hexmap(@sector.id)

		@organized_data = raw_hexmap_data.map {|point| {sys_id: point.id, n: point.name, q: point.q, r: point.r, hex_loc: point.location,
			allegiance: point.allegiance,
			colour: "#{point.color_code.nil? ? "rgb(247, 171, 45)" : point.color_code}"}}
			
		raw_json_data = @organized_data.as_json.to_json
		parsed_data = JSON.parse(raw_json_data)
		
		formatted_data = {}
		parsed_data.each_with_index do |item, index|
				formatted_data[index] = item
		end

		gon.data = formatted_data
		gon.hex_color = @sector.hex_color.presence || "#f8f9fa"
		gon.border_width = @sector.border_width.presence || 4
		gon.border_opacity = @sector.border_opacity.presence || 0.5
	end

	private
	
	def presets
		@page_libs = [:hexmap]
	end

	# TODO: Add in ability to edit system faction from the hexmap.

end