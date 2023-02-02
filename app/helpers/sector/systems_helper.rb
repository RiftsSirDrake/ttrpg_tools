module Sector::SystemsHelper
  def combine_uwp_params(params)
    "#{params[:starport]}#{params[:planet_size]}#{params[:atmosphere]}#{params[:hydrosphere]}#{params[:population]}#{params[:goverment]}#{params[:law]}-#{params[:tech_level]}"
  end
  
  def combine_note_params(params)
    "#{params[:notes1]} #{params[:notes2]} #{params[:notes3]}".rstrip
  end

  def combine_pbg_params(pbg_base, params)
    if pbg_base.length == 1
      "#{pbg_base}#{params[:asteroid_belts]}#{params[:gas_giants]}" 
    else
      "#{pbg_base[0]}#{params[:asteroid_belts]}#{params[:gas_giants]}"
    end
  end
  
end
