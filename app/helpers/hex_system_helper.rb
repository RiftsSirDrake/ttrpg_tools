module HexSystemHelper
  
  def planet_size_int(planet)
    planet_size = planet.gsub(/[^0-9]/, '').to_i
    planet_size
  end
  
end
