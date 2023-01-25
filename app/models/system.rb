class System < ApplicationRecord
  self.table_name = 'traveller_systems.system'
  
  def self.hexmap()
    sql = <<-SQL
      SELECT
      	location,
          name,
      	SUM(SUBSTRING(location,1,2)) AS q,
          SUM(SUBSTRING(location,3,2) -41)*-1 AS r
      FROM traveller_systems.system
      group by location;
    SQL
    hexmap = find_by_sql(sql)
  end
  
  def self.translated_system_info()
      sql = <<-SQL
      SELECT
        name,
        location,
        CASE
        	WHEN SUBSTRING(uwp,1,1) = 'X' THEN 'None'
        	WHEN SUBSTRING(uwp,1,1) = 'E' THEN 'Frontier - No Services'
        	WHEN SUBSTRING(uwp,1,1) = 'D' THEN 'Poor - Unrefined Fuel'
        	WHEN SUBSTRING(uwp,1,1) = 'C' THEN 'Routine - Unrefined Fuel, Basic Repair'
        	WHEN SUBSTRING(uwp,1,1) = 'B' THEN 'Good - Refined Fuel, Advanced Repair, Basic Shipyard'
        	WHEN SUBSTRING(uwp,1,1) = 'A' THEN 'Excellent - Refined Fuel, Advanced Repair, Advanced Shipyard'
            ELSE ''
        END AS 'starport',
        
        CASE
        	WHEN SUBSTRING(uwp,2,1) = 'C' THEN 'Huge - 18,400+ KM'
        	WHEN SUBSTRING(uwp,2,1) = 'B' THEN 'Huge - 16,800+ KM'
        	WHEN SUBSTRING(uwp,2,1) = 'A' THEN 'Huge - 15,200+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '9' THEN 'Large - 13,600+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '8' THEN 'Large - 12,000+ KM, Venus, Terra'
        	WHEN SUBSTRING(uwp,2,1) = '7' THEN 'Large - 10,400+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '6' THEN 'Medium - 8,800+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '5' THEN 'Medium - 7,200+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '4' THEN 'Medium - 5,600+ KM, Mars'
        	WHEN SUBSTRING(uwp,2,1) = '3' THEN 'Small - 4,000+ KM, Mercury'
        	WHEN SUBSTRING(uwp,2,1) = '2' THEN 'Small - 2,400+ KM, Luna'
        	WHEN SUBSTRING(uwp,2,1) = '1' THEN 'Small - 800+ KM'
        	WHEN SUBSTRING(uwp,2,1) = 'S' THEN 'Very Small - 200+ KM'
        	WHEN SUBSTRING(uwp,2,1) = '0' THEN 'Asteroid Belt'
        	WHEN SUBSTRING(uwp,2,1) = 'D' THEN 'Debris'
        	WHEN SUBSTRING(uwp,2,1) = 'R' THEN 'Planetary Ring'
        	ELSE ''
        END AS 'size',
        
        CASE
        	WHEN SUBSTRING(uwp,3,1) = 'F' THEN 'Thin, Low - Atmosphere in Valleys'
        	WHEN SUBSTRING(uwp,3,1) = 'E' THEN 'Ellipsoid - Uneven Atmosphere'
        	WHEN SUBSTRING(uwp,3,1) = 'D' THEN 'Dense, High - Extreme Pressure Below Sea Level'
        	WHEN SUBSTRING(uwp,3,1) = 'C' THEN 'Insidious - Extreme corrosion or similar'
        	WHEN SUBSTRING(uwp,3,1) = 'B' THEN 'Corrosive - Vacc or HazMat Suit Required'
        	WHEN SUBSTRING(uwp,3,1) = 'A' THEN 'Exotic - Unusual Gas Mix, Oxygen Tanks Required'
        	WHEN SUBSTRING(uwp,3,1) = '9' THEN 'Dense, Tainted - Requires Filter Mask' 
        	WHEN SUBSTRING(uwp,3,1) = '8' THEN 'Dense - No Gear Required'
        	WHEN SUBSTRING(uwp,3,1) = '7' THEN 'Standard, Tainted - Requires Filter Mask'
        	WHEN SUBSTRING(uwp,3,1) = '6' THEN 'Standard - No Gear Required'
        	WHEN SUBSTRING(uwp,3,1) = '5' THEN 'Thin - No Gear Required'
        	WHEN SUBSTRING(uwp,3,1) = '4' THEN 'Thin, Tainted - Filter Mask Required'
        	WHEN SUBSTRING(uwp,3,1) = '3' THEN 'Very Thin - Requires Respirator'
        	WHEN SUBSTRING(uwp,3,1) = '2' THEN 'Very Thin, Tainted - Requires Filter Mask and Respirator'
        	WHEN SUBSTRING(uwp,3,1) = '1' THEN 'Trace - Requires Vacc Suit'
        	WHEN SUBSTRING(uwp,3,1) = '0' THEN 'Vacuum - Requires Vacc Suit'
        	ELSE ''
        END AS 'atmosphere',
        
        CASE
        	WHEN SUBSTRING(uwp,4,1) = 'A' THEN 'Water World - 100%'
        	WHEN SUBSTRING(uwp,4,1) = '9' THEN 'Very Wet World - 95%'
        	WHEN SUBSTRING(uwp,4,1) = '8' THEN 'Very Wet World - 85%'
        	WHEN SUBSTRING(uwp,4,1) = '7' THEN 'Wet World - 75%'
        	WHEN SUBSTRING(uwp,4,1) = '6' THEN 'Wet World - 65%'
        	WHEN SUBSTRING(uwp,4,1) = '5' THEN 'Average Wet World - 55%'
        	WHEN SUBSTRING(uwp,4,1) = '4' THEN 'Wet World - 45%'
        	WHEN SUBSTRING(uwp,4,1) = '3' THEN 'Wet World - 35%'
        	WHEN SUBSTRING(uwp,4,1) = '2' THEN 'Dry World - 25%'
        	WHEN SUBSTRING(uwp,4,1) = '1' THEN 'Dry World - 15%'
        	WHEN SUBSTRING(uwp,4,1) = '0' THEN 'Desert World - 5%'
        	ELSE ''
        END AS 'hydrosphere',
        
        CASE
        	WHEN SUBSTRING(uwp,5,1) = 'C' THEN CONCAT(SUBSTRING(pbg,1,1), ' Trillion')
        	WHEN SUBSTRING(uwp,5,1) = 'B' THEN CONCAT(SUBSTRING(pbg,1,1), '00 Billion')
        	WHEN SUBSTRING(uwp,5,1) = 'A' THEN CONCAT(SUBSTRING(pbg,1,1), '0 Billion')
        	WHEN SUBSTRING(uwp,5,1) = '9' THEN CONCAT(SUBSTRING(pbg,1,1), ' Billion')
        	WHEN SUBSTRING(uwp,5,1) = '8' THEN CONCAT(SUBSTRING(pbg,1,1), '00 Million')
        	WHEN SUBSTRING(uwp,5,1) = '7' THEN CONCAT(SUBSTRING(pbg,1,1), '0 Million')
        	WHEN SUBSTRING(uwp,5,1) = '6' THEN CONCAT(SUBSTRING(pbg,1,1), ' Million')
        	WHEN SUBSTRING(uwp,5,1) = '5' THEN CONCAT(SUBSTRING(pbg,1,1), '00 Thousand')
        	WHEN SUBSTRING(uwp,5,1) = '4' THEN CONCAT(SUBSTRING(pbg,1,1), '0 Thousand')
        	WHEN SUBSTRING(uwp,5,1) = '3' THEN CONCAT(SUBSTRING(pbg,1,1), ' Thousand')
        	WHEN SUBSTRING(uwp,5,1) = '2' THEN CONCAT(SUBSTRING(pbg,1,1), '00')
        	WHEN SUBSTRING(uwp,5,1) = '1' THEN SUBSTRING(pbg,1,1) * 10
        	WHEN SUBSTRING(uwp,5,1) = '0' THEN 'None'
        	ELSE ''
        END AS 'population',
        
        CASE
        	WHEN SUBSTRING(uwp,6,1) = 'F' THEN 'Totalitarian Oligarchy - Government by an all-powerful minority which maintains absolute control through widespread coercion and oppression'
        	WHEN SUBSTRING(uwp,6,1) = 'E' THEN 'Religious Autocracy - Government by a single religious leader having absolute power over the citizenry.'
        	WHEN SUBSTRING(uwp,6,1) = 'D' THEN 'Religious Dictatorship - Government by a religious minority which has little regard for the needs of the citizenry.'
        	WHEN SUBSTRING(uwp,6,1) = 'C' THEN 'Charismatic Oligarchy - Government by a select group, organization, or class enjoying overwhelming confidence of the citizenry.'
        	WHEN SUBSTRING(uwp,6,1) = 'B' THEN 'Non-Charismatic Dictator - A previous charismatic dictator has been replaced by a leader through normal channels.'
        	WHEN SUBSTRING(uwp,6,1) = 'A' THEN 'Charismatic Dictator - Government by a single leader enjoying the confidence of the citizens.'
        	WHEN SUBSTRING(uwp,6,1) = '9' THEN 'Impersonal Bureaucracy - Government by agencies which are insulated from the governed.'
        	WHEN SUBSTRING(uwp,6,1) = '8' THEN 'Civil Service Bureaucracy - Government by agencies employing individuals selected for their expertise.'
        	WHEN SUBSTRING(uwp,6,1) = '7' THEN 'Balkanization - No central ruling authority exists. Rival governments compete for control.'
        	WHEN SUBSTRING(uwp,6,1) = '6' THEN 'Captive Government/Colony - Government by a leadership answerable to an outside group, a colony or conquered area.'
        	WHEN SUBSTRING(uwp,6,1) = '5' THEN 'Feudal Technocracy - Government by specific individuals for those who agree to be ruled. Relationships are based on the performance of technical activities which are mutually-beneficial.'
        	WHEN SUBSTRING(uwp,6,1) = '4' THEN 'Representative Democracy - Government by elected representatives.'
        	WHEN SUBSTRING(uwp,6,1) = '3' THEN 'Self-perpetuating Oligarchy - Government by a restricted minority, with little or no input from the masses.'
        	WHEN SUBSTRING(uwp,6,1) = '2' THEN 'Participating Democracy - Government by advice and consent of the citizen.'
        	WHEN SUBSTRING(uwp,6,1) = '1' THEN 'Company/Corporation - Government by a company managerial elite, citizens are company employees.'
        	WHEN SUBSTRING(uwp,6,1) = '0' THEN 'No Government Structure - In many cases, tribal, clan or family bonds predominate'
        	ELSE ''
        END AS 'goverment',
        
        CASE
        	WHEN SUBSTRING(uwp,6,1) = 'J' THEN 'Extreme - Routinely Oppressive and Restrictive'
        	WHEN SUBSTRING(uwp,6,1) = 'H' THEN 'Extreme - Legalized Oppressive Practices'
        	WHEN SUBSTRING(uwp,6,1) = 'G' THEN 'Extreme - Severe Punishment for Petty Crime'
        	WHEN SUBSTRING(uwp,6,1) = 'F' THEN 'Extreme - All facets of Daily Life Rigidly Controlled'
        	WHEN SUBSTRING(uwp,6,1) = 'E' THEN 'Extreme - Full-fledged Police State'
        	WHEN SUBSTRING(uwp,6,1) = 'D' THEN 'Extreme - Paramilitary Law Enforcement'
        	WHEN SUBSTRING(uwp,6,1) = 'C' THEN 'Extreme - Unrestricted Invasion of Privacy'
        	WHEN SUBSTRING(uwp,6,1) = 'B' THEN 'Extreme - Restricted Civilian Movement'
        	WHEN SUBSTRING(uwp,6,1) = 'A' THEN 'Extreme - Any Weapons'
        	WHEN SUBSTRING(uwp,6,1) = '9' THEN 'High - Any Weapons Outside of Home'
        	WHEN SUBSTRING(uwp,6,1) = '8' THEN 'High - All Bladed Weapons, Non-Lethals'
        	WHEN SUBSTRING(uwp,6,1) = '7' THEN 'Moderate - All Firearms'
        	WHEN SUBSTRING(uwp,6,1) = '6' THEN 'Moderate - All Firearms except Shotguns and Non-Lethals'
        	WHEN SUBSTRING(uwp,6,1) = '5' THEN 'Moderate - Concealed Weapons'
        	WHEN SUBSTRING(uwp,6,1) = '4' THEN 'Moderate - Light Assault Weapons, Submachine Guns'
        	WHEN SUBSTRING(uwp,6,1) = '3' THEN 'Low - Heavy Weapons'
        	WHEN SUBSTRING(uwp,6,1) = '2' THEN 'Low - Portable Energy Weapons'
        	WHEN SUBSTRING(uwp,6,1) = '1' THEN 'Low - Undetectable Weapons, WMD, Poison Gas'
        	WHEN SUBSTRING(uwp,6,1) = '0' THEN 'Lawless'
        	ELSE ''
        END AS 'law',
        
        CASE
        	WHEN SUBSTRING(uwp,7,1) = 'X' THEN 'Pocket Universes Age'
        	WHEN SUBSTRING(uwp,7,1) = 'W' THEN 'Remote Technology Age'
        	WHEN SUBSTRING(uwp,7,1) = 'V' THEN 'Dyson Sphere Age'
        	WHEN SUBSTRING(uwp,7,1) = 'U' THEN 'Reality Engineering Age'
        	WHEN SUBSTRING(uwp,7,1) = 'T' THEN 'Ringworlds Age'
        	WHEN SUBSTRING(uwp,7,1) = 'S' THEN 'Star Energy Age (KT2)'
        	WHEN SUBSTRING(uwp,7,1) = 'R' THEN 'Psionic Engineering Age'
        	WHEN SUBSTRING(uwp,7,1) = 'Q' THEN 'Engineered Societies Age'
        	WHEN SUBSTRING(uwp,7,1) = 'P' THEN 'Psychohistory Age'
        	WHEN SUBSTRING(uwp,7,1) = 'N' THEN 'Planet-Scrubber Age'
        	WHEN SUBSTRING(uwp,7,1) = 'M' THEN 'Stasis Age'
        	WHEN SUBSTRING(uwp,7,1) = 'L' THEN 'Skipdrive Age'
        	WHEN SUBSTRING(uwp,7,1) = 'K' THEN 'Matter Transport Age'
        	WHEN SUBSTRING(uwp,7,1) = 'J' THEN 'Exotics Age'
        	WHEN SUBSTRING(uwp,7,1) = 'H' THEN 'Personality Transfer Age'
        	WHEN SUBSTRING(uwp,7,1) = 'G' THEN 'Artificial Persons Age'
        	WHEN SUBSTRING(uwp,7,1) = 'F' THEN 'Anagathics Age'
        	WHEN SUBSTRING(uwp,7,1) = 'E' THEN 'Geneering Age'
        	WHEN SUBSTRING(uwp,7,1) = 'D' THEN 'Cloning Age'
        	WHEN SUBSTRING(uwp,7,1) = 'C' THEN 'Positronics Age'
        	WHEN SUBSTRING(uwp,7,1) = 'B' THEN 'FusionPlus Age'
        	WHEN SUBSTRING(uwp,7,1) = 'A' THEN 'Fusion Age'
        	WHEN SUBSTRING(uwp,7,1) = '9' THEN 'Gravitics Age'
        	WHEN SUBSTRING(uwp,7,1) = '8' THEN 'Information Age'
        	WHEN SUBSTRING(uwp,7,1) = '7' THEN 'Space Age'
        	WHEN SUBSTRING(uwp,7,1) = '6' THEN 'Atomic Age'
        	WHEN SUBSTRING(uwp,7,1) = '5' THEN 'Broadcast Age'
        	WHEN SUBSTRING(uwp,7,1) = '4' THEN 'Mechanized Age'
        	WHEN SUBSTRING(uwp,7,1) = '3' THEN 'Industrial Revolution Age'
        	WHEN SUBSTRING(uwp,7,1) = '2' THEN 'Age of Sail'
        	WHEN SUBSTRING(uwp,7,1) = '1' THEN 'Iron Age'
        	WHEN SUBSTRING(uwp,7,1) = '0' THEN 'Neolithic'
        	ELSE ''
        END AS 'tech_level',
        
        CASE
        	WHEN base = 'Z' THEN 'Shaper'
        	WHEN base = 'S' THEN 'Scout'
        	WHEN base = 'N' THEN 'Navel'
        	WHEN base = '2' THEN 'Scout and Navel'
        	ELSE ''
        END AS 'bases',
        
        CASE
        	WHEN SUBSTRING(notes,1,2) like '%Ab%' THEN 'Data Repository'
        	WHEN SUBSTRING(notes,1,2) like '%Ag%' THEN 'Agriculture'
        	WHEN SUBSTRING(notes,1,2) like '%An%' THEN 'Shaper Site'
        	WHEN SUBSTRING(notes,1,2) like '%As%' THEN 'Asteroid Belt'
        	WHEN SUBSTRING(notes,1,2) like '%Ax%' THEN 'Construct World'
        	WHEN SUBSTRING(notes,1,2) like '%Ba%' THEN 'Barren'
        	WHEN SUBSTRING(notes,1,2) like '%Co%' THEN 'Cold'
        	WHEN SUBSTRING(notes,1,2) like '%Cp%' THEN 'Subsector Capital'
        	WHEN SUBSTRING(notes,1,2) like '%Cs%' THEN 'Sector Capital'
        	WHEN SUBSTRING(notes,1,2) like '%Cx%' THEN 'Imperial Capital'
        	WHEN SUBSTRING(notes,1,2) like '%Cy%' THEN 'Colony'
        	WHEN SUBSTRING(notes,1,2) like '%Da%' THEN 'Dangerous'
        	WHEN SUBSTRING(notes,1,2) like '%De%' THEN 'Desert'
        	WHEN SUBSTRING(notes,1,2) like '%Di%' THEN 'Die Back'
        	WHEN SUBSTRING(notes,1,2) like '%Fa%' THEN 'Farming'
        	WHEN SUBSTRING(notes,1,2) like '%Fl%' THEN 'Fluid Oceans'
        	WHEN SUBSTRING(notes,1,2) like '%Fo%' THEN 'Forbidden'
        	WHEN SUBSTRING(notes,1,2) like '%Ga%' THEN 'Garden'
        	WHEN SUBSTRING(notes,1,2) like '%He%' THEN 'Hellworld'
        	WHEN SUBSTRING(notes,1,2) like '%Hi%' THEN 'High Population'
        	WHEN SUBSTRING(notes,1,2) like '%Ho%' THEN 'Hot'
        	WHEN SUBSTRING(notes,1,2) like '%Ht%' THEN 'High Tech'
        	WHEN SUBSTRING(notes,1,2) like '%Ic%' THEN 'Ice-Capped'
        	WHEN SUBSTRING(notes,1,2) like '%In%' THEN 'Industrial'
        	WHEN SUBSTRING(notes,1,2) like '%Lk%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,1,2) like '%Lo%' THEN 'Low Population'
        	WHEN SUBSTRING(notes,1,2) like '%Lt%' THEN 'Low Tech'
        	WHEN SUBSTRING(notes,1,2) like '%Mi%' THEN 'Mining'
        	WHEN SUBSTRING(notes,1,2) like '%Mr%' THEN 'Military Rule'
        	WHEN SUBSTRING(notes,1,2) like '%Na%' THEN 'Non-Agricultural'
        	WHEN SUBSTRING(notes,1,2) like '%Ni%' THEN 'Non-Industrial'
        	WHEN SUBSTRING(notes,1,2) like '%Oc%' THEN 'Ocean World'
        	WHEN SUBSTRING(notes,1,2) like '%Pa%' THEN 'Pre-Agricultural World'
        	WHEN SUBSTRING(notes,1,2) like '%Pe%' THEN 'Penal Colony'
        	WHEN SUBSTRING(notes,1,2) like '%Ph%' THEN 'Pre-High Population'
        	WHEN SUBSTRING(notes,1,2) like '%Pi%' THEN 'Pre-Industrial'
        	WHEN SUBSTRING(notes,1,2) like '%Po%' THEN 'Poor'
        	WHEN SUBSTRING(notes,1,2) like '%Pr%' THEN 'Pre-Rich'
        	WHEN SUBSTRING(notes,1,2) like '%Px%' THEN 'Prison Camp'
        	WHEN SUBSTRING(notes,1,2) like '%Pz%' THEN 'Puzzle World'
        	WHEN SUBSTRING(notes,1,2) like '%Re%' THEN 'Restricted'
        	WHEN SUBSTRING(notes,1,2) like '%Ri%' THEN 'Rich'
        	WHEN SUBSTRING(notes,1,2) like '%Rs%' THEN 'Research Station'
        	WHEN SUBSTRING(notes,1,2) like '%Sa%' THEN 'Satellite'
        	WHEN SUBSTRING(notes,1,2) like '%Tr%' THEN 'Tropical'
        	WHEN SUBSTRING(notes,1,2) like '%Tu%' THEN 'Tundra'
        	WHEN SUBSTRING(notes,1,2) like '%Tz%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,1,2) like '%Wa%' THEN 'Water World'
        	WHEN SUBSTRING(notes,1,2) like '%Va%' THEN 'Vacuum'
        	WHEN SUBSTRING(notes,1,2) like '%Xb%' THEN 'Rapid Message Transmission'
        	ELSE ''
        END AS 'notes1',
        
        CASE
        	WHEN SUBSTRING(notes,4,2) like '%Ab%' THEN 'Data Repository'
        	WHEN SUBSTRING(notes,4,2) like '%Ag%' THEN 'Agriculture'
        	WHEN SUBSTRING(notes,4,2) like '%An%' THEN 'Shaper Site'
        	WHEN SUBSTRING(notes,4,2) like '%As%' THEN 'Asteroid Belt'
        	WHEN SUBSTRING(notes,4,2) like '%Ax%' THEN 'Construct World'
        	WHEN SUBSTRING(notes,4,2) like '%Ba%' THEN 'Barren'
        	WHEN SUBSTRING(notes,4,2) like '%Co%' THEN 'Cold'
        	WHEN SUBSTRING(notes,4,2) like '%Cp%' THEN 'Subsector Capital'
        	WHEN SUBSTRING(notes,4,2) like '%Cs%' THEN 'Sector Capital'
        	WHEN SUBSTRING(notes,4,2) like '%Cx%' THEN 'Imperial Capital'
        	WHEN SUBSTRING(notes,4,2) like '%Cy%' THEN 'Colony'
        	WHEN SUBSTRING(notes,4,2) like '%Da%' THEN 'Dangerous'
        	WHEN SUBSTRING(notes,4,2) like '%De%' THEN 'Desert'
        	WHEN SUBSTRING(notes,4,2) like '%Di%' THEN 'Die Back'
        	WHEN SUBSTRING(notes,4,2) like '%Fa%' THEN 'Farming'
        	WHEN SUBSTRING(notes,4,2) like '%Fl%' THEN 'Fluid Oceans'
        	WHEN SUBSTRING(notes,4,2) like '%Fo%' THEN 'Forbidden'
        	WHEN SUBSTRING(notes,4,2) like '%Ga%' THEN 'Garden'
        	WHEN SUBSTRING(notes,4,2) like '%He%' THEN 'Hellworld'
        	WHEN SUBSTRING(notes,4,2) like '%Hi%' THEN 'High Population'
        	WHEN SUBSTRING(notes,4,2) like '%Ho%' THEN 'Hot'
        	WHEN SUBSTRING(notes,4,2) like '%Ht%' THEN 'High Tech'
        	WHEN SUBSTRING(notes,4,2) like '%Ic%' THEN 'Ice-Capped'
        	WHEN SUBSTRING(notes,4,2) like '%In%' THEN 'Industrial'
        	WHEN SUBSTRING(notes,4,2) like '%Lk%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,4,2) like '%Lo%' THEN 'Low Population'
        	WHEN SUBSTRING(notes,4,2) like '%Lt%' THEN 'Low Tech'
        	WHEN SUBSTRING(notes,4,2) like '%Mi%' THEN 'Mining'
        	WHEN SUBSTRING(notes,4,2) like '%Mr%' THEN 'Military Rule'
        	WHEN SUBSTRING(notes,4,2) like '%Na%' THEN 'Non-Agricultural'
        	WHEN SUBSTRING(notes,4,2) like '%Ni%' THEN 'Non-Industrial'
        	WHEN SUBSTRING(notes,4,2) like '%Oc%' THEN 'Ocean World'
        	WHEN SUBSTRING(notes,4,2) like '%Pa%' THEN 'Pre-Agricultural World'
        	WHEN SUBSTRING(notes,4,2) like '%Pe%' THEN 'Penal Colony'
        	WHEN SUBSTRING(notes,4,2) like '%Ph%' THEN 'Pre-High Population'
        	WHEN SUBSTRING(notes,4,2) like '%Pi%' THEN 'Pre-Industrial'
        	WHEN SUBSTRING(notes,4,2) like '%Po%' THEN 'Poor'
        	WHEN SUBSTRING(notes,4,2) like '%Pr%' THEN 'Pre-Rich'
        	WHEN SUBSTRING(notes,4,2) like '%Px%' THEN 'Prison Camp'
        	WHEN SUBSTRING(notes,4,2) like '%Pz%' THEN 'Puzzle World'
        	WHEN SUBSTRING(notes,4,2) like '%Re%' THEN 'Restricted'
        	WHEN SUBSTRING(notes,4,2) like '%Ri%' THEN 'Rich'
        	WHEN SUBSTRING(notes,4,2) like '%Rs%' THEN 'Research Station'
        	WHEN SUBSTRING(notes,4,2) like '%Sa%' THEN 'Satellite'
        	WHEN SUBSTRING(notes,4,2) like '%Tr%' THEN 'Tropical'
        	WHEN SUBSTRING(notes,4,2) like '%Tu%' THEN 'Tundra'
        	WHEN SUBSTRING(notes,4,2) like '%Tz%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,4,2) like '%Wa%' THEN 'Water World'
        	WHEN SUBSTRING(notes,4,2) like '%Va%' THEN 'Vacuum'
        	WHEN SUBSTRING(notes,4,2) like '%Xb%' THEN 'Rapid Message Transmission'
        	ELSE ''
        END AS 'notes2',
        
        CASE
        	WHEN SUBSTRING(notes,7,2) like '%Ab%' THEN 'Data Repository'
        	WHEN SUBSTRING(notes,7,2) like '%Ag%' THEN 'Agriculture'
        	WHEN SUBSTRING(notes,7,2) like '%An%' THEN 'Shaper Site'
        	WHEN SUBSTRING(notes,7,2) like '%As%' THEN 'Asteroid Belt'
        	WHEN SUBSTRING(notes,7,2) like '%Ax%' THEN 'Construct World'
        	WHEN SUBSTRING(notes,7,2) like '%Ba%' THEN 'Barren'
        	WHEN SUBSTRING(notes,7,2) like '%Co%' THEN 'Cold'
        	WHEN SUBSTRING(notes,7,2) like '%Cp%' THEN 'Subsector Capital'
        	WHEN SUBSTRING(notes,7,2) like '%Cs%' THEN 'Sector Capital'
        	WHEN SUBSTRING(notes,7,2) like '%Cx%' THEN 'Imperial Capital'
        	WHEN SUBSTRING(notes,7,2) like '%Cy%' THEN 'Colony'
        	WHEN SUBSTRING(notes,7,2) like '%Da%' THEN 'Dangerous'
        	WHEN SUBSTRING(notes,7,2) like '%De%' THEN 'Desert'
        	WHEN SUBSTRING(notes,7,2) like '%Di%' THEN 'Die Back'
        	WHEN SUBSTRING(notes,7,2) like '%Fa%' THEN 'Farming'
        	WHEN SUBSTRING(notes,7,2) like '%Fl%' THEN 'Fluid Oceans'
        	WHEN SUBSTRING(notes,7,2) like '%Fo%' THEN 'Forbidden'
        	WHEN SUBSTRING(notes,7,2) like '%Ga%' THEN 'Garden'
        	WHEN SUBSTRING(notes,7,2) like '%He%' THEN 'Hellworld'
        	WHEN SUBSTRING(notes,7,2) like '%Hi%' THEN 'High Population'
        	WHEN SUBSTRING(notes,7,2) like '%Ho%' THEN 'Hot'
        	WHEN SUBSTRING(notes,7,2) like '%Ht%' THEN 'High Tech'
        	WHEN SUBSTRING(notes,7,2) like '%Ic%' THEN 'Ice-Capped'
        	WHEN SUBSTRING(notes,7,2) like '%In%' THEN 'Industrial'
        	WHEN SUBSTRING(notes,7,2) like '%Lk%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,7,2) like '%Lo%' THEN 'Low Population'
        	WHEN SUBSTRING(notes,7,2) like '%Lt%' THEN 'Low Tech'
        	WHEN SUBSTRING(notes,7,2) like '%Mi%' THEN 'Mining'
        	WHEN SUBSTRING(notes,7,2) like '%Mr%' THEN 'Military Rule'
        	WHEN SUBSTRING(notes,7,2) like '%Na%' THEN 'Non-Agricultural'
        	WHEN SUBSTRING(notes,7,2) like '%Ni%' THEN 'Non-Industrial'
        	WHEN SUBSTRING(notes,7,2) like '%Oc%' THEN 'Ocean World'
        	WHEN SUBSTRING(notes,7,2) like '%Pa%' THEN 'Pre-Agricultural World'
        	WHEN SUBSTRING(notes,7,2) like '%Pe%' THEN 'Penal Colony'
        	WHEN SUBSTRING(notes,7,2) like '%Ph%' THEN 'Pre-High Population'
        	WHEN SUBSTRING(notes,7,2) like '%Pi%' THEN 'Pre-Industrial'
        	WHEN SUBSTRING(notes,7,2) like '%Po%' THEN 'Poor'
        	WHEN SUBSTRING(notes,7,2) like '%Pr%' THEN 'Pre-Rich'
        	WHEN SUBSTRING(notes,7,2) like '%Px%' THEN 'Prison Camp'
        	WHEN SUBSTRING(notes,7,2) like '%Pz%' THEN 'Puzzle World'
        	WHEN SUBSTRING(notes,7,2) like '%Re%' THEN 'Restricted'
        	WHEN SUBSTRING(notes,7,2) like '%Ri%' THEN 'Rich'
        	WHEN SUBSTRING(notes,7,2) like '%Rs%' THEN 'Research Station'
        	WHEN SUBSTRING(notes,7,2) like '%Sa%' THEN 'Satellite'
        	WHEN SUBSTRING(notes,7,2) like '%Tr%' THEN 'Tropical'
        	WHEN SUBSTRING(notes,7,2) like '%Tu%' THEN 'Tundra'
        	WHEN SUBSTRING(notes,7,2) like '%Tz%' THEN 'Tidally Locked'
        	WHEN SUBSTRING(notes,7,2) like '%Wa%' THEN 'Water World'
        	WHEN SUBSTRING(notes,7,2) like '%Va%' THEN 'Vacuum'
        	WHEN SUBSTRING(notes,7,2) like '%Xb%' THEN 'Rapid Message Transmission'
        	ELSE ''
        END AS 'notes3',
        
        ring AS travel_ring,
        SUBSTRING(pbg,2,1) AS asteroid_belts,
        SUBSTRING(pbg,3,1) AS gas_giants
        
        FROM traveller_systems.system
      SQL
      systems_translated = find_by_sql(sql)
  end
end
