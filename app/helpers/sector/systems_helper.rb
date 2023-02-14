module Sector::SystemsHelper
  def combine_uwp_params(params)
    "#{params[:starport]}#{params[:planet_size]}#{params[:atmosphere]}#{params[:hydrosphere]}#{params[:population]}#{params[:goverment]}#{params[:law]}-#{params[:tech_level]}"
  end
  
  def combine_note_params(params)
    "#{params[:notes1]} #{params[:notes2]} #{params[:notes3]}".rstrip
  end

  def combine_pbg_params(params)
    "#{params[:pop_base]}#{params[:asteroid_belts]}#{params[:gas_giants]}" 
  end
  
end
