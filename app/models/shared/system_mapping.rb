module Shared
  module SystemMapping

    ADVISORY_MAP = {
      'A' => 'Dangerous: Societal Upheaval, Hazardous Environment, Spacial Anomolies, or Pirate Activity',
      'R' => 'Restricted: Extreme Environmental Hazards, Navel Interdiction, Pirate Stronghold, or Similar',
      'P' => 'Pirate: Controlled By What is Generally Considered a Pirate Faction or Clan',
      'C' => 'Contested: Two or More Factions Currently Contest Ownership, Conflict Likely',
      nil => 'None: No Major Travel Risks',
      ""  => 'None: No Major Travel Risks',
      "*" => 'Unknown: Invalid mapping'
    }

    PORT_MAP = {
      'X' => 'None',
      'E' => 'Frontier - No Services', 
      'D' => 'Poor - Unrefined Fuel', 
      'C' => 'Routine - Unrefined Fuel, Basic Repair',
      'B' => 'Good - Refined Fuel, Advanced Repair, Basic Shipyard', 
      'A' => 'Excellent - Refined Fuel, Advanced Repair, Advanced Shipyard',
      "*" => 'Unknown - Invalid mapping'
    }

    SIZE_MAP = {
      'C' => 'Huge - 18,400+ KM',
      'B' => 'Huge - 16,800+ KM',
      'A' => 'Huge - 15,200+ KM',
      '9' => 'Large - 13,600+ KM',
      '8' => 'Large - 12,000+ KM, Venus, Terra',
      '7' => 'Large - 10,400+ KM',
      '6' => 'Medium - 8,800+ KM',
      '5' => 'Medium - 7,200+ KM',
      '4' => 'Medium - 5,600+ KM, Mars',
      '3' => 'Small - 4,000+ KM, Mercury',
      '2' => 'Small - 2,400+ KM, Luna',
      '1' => 'Small - 800+ KM',
      'S' => 'Very Small - 200+ KM',
      '0' => 'Asteroid Belt',
      'D' => 'Debris',
      'R' => 'Planetary Ring',
      "*" => 'Unknown - Invalid mapping'
    }

    ATMO_MAP = {
      "F" => "Thin, Low - Atmosphere in Valleys",
      "E" => "Ellipsoid - Uneven Atmosphere",
      "D" => "Dense, High - Extreme Pressure Below Sea Level",
      "C" => "Insidious - Extreme corrosion or similar",
      "B" => "Corrosive - Vacc or HazMat Suit Required",
      "A" => "Exotic - Unusual Gas Mix, Oxygen Tanks Required",
      "9" => "Dense, Tainted - Requires Filter Mask",
      "8" => "Dense - No Gear Required",
      "7" => "Standard, Tainted - Requires Filter Mask",
      "6" => "Standard - No Gear Required",
      "5" => "Thin - No Gear Required",
      "4" => "Thin, Tainted - Filter Mask Required",
      "3" => "Very Thin - Requires Respirator",
      "2" => "Very Thin, Tainted - Requires Filter Mask and Respirator",
      "1" => "Trace - Requires Vacc Suit",
      "0" => "Vacuum - Requires Vacc Suit",
      "*" => 'Unknown - Invalid mapping'
    }

    HYDRO_MAP = {
      "A" => "Water World - 100%",
      "9" => "Very Wet World - 95%",
      "8" => "Very Wet World - 85%",
      "7" => "Wet World - 75%",
      "6" => "Wet World - 65%",
      "5" => "Average Wet World - 55%",
      "4" => "Wet World - 45%",
      "3" => "Wet World - 35%",
      "2" => "Dry World - 25%",
      "1" => "Dry World - 15%",
      "0" => "Desert World - 5%",
      "*" => 'Unknown - Invalid mapping'
    }

    POP_MAP = {
      "C" => proc { |pbg| "#{pbg[0]} Trillion"},
      "B" => proc { |pbg| "#{pbg[0]}00 Billion"},
      "A" => proc { |pbg| "#{pbg[0]}0 Billion"},
      "9" => proc { |pbg| "#{pbg[0]} Billion"},
      "8" => proc { |pbg| "#{pbg[0]}00 Million"},
      "7" => proc { |pbg| "#{pbg[0]}0 Million"},
      "6" => proc { |pbg| "#{pbg[0]} Million"},
      "5" => proc { |pbg| "#{pbg[0]}00 Thousand"},
      "4" => proc { |pbg| "#{pbg[0]}0 Thousand"},
      "3" => proc { |pbg| "#{pbg[0]} Thousand"},
      "2" => proc { |pbg| "#{pbg[0]}00"},
      "1" => proc { |pbg| "#{pbg[0].to_i * 10}"},
      "0" => proc { |pbg| "None"},
      "*" => proc { |pbg| "Invalid mapping"}
    }

    GOV_MAP = {
        "F" => "Totalitarian Oligarchy - Government by an all-powerful minority which maintains absolute control through widespread coercion and oppression",
        "E" => "Religious Autocracy - Government by a single religious leader having absolute power over the citizenry.",
        "D" => "Religious Dictatorship - Government by a religious minority which has little regard for the needs of the citizenry.",
        "C" => "Charismatic Oligarchy - Government by a select group, organization, or class enjoying overwhelming confidence of the citizenry.",
        "B" => "Non-Charismatic Dictator - A previous charismatic dictator has been replaced by a leader through normal channels.",
        "A" => "Charismatic Dictator - Government by a single leader enjoying the confidence of the citizens.",
        "9" => "Impersonal Bureaucracy - Government by agencies which are insulated from the governed.",
        "8" => "Civil Service Bureaucracy - Government by agencies employing individuals selected for their expertise.",
        "7" => "Balkanization - No central ruling authority exists. Rival governments compete for control.",
        "6" => "Captive Government/Colony - Government by a leadership answerable to an outside group, a colony or conquered area.",
        "5" => "Feudal Technocracy - Government by specific individuals for those who agree to be ruled. Relationships are based on the performance of technical activities which are mutually-beneficial.",
        "4" => "Representative Democracy - Government by elected representatives.",
        "3" => "Self-perpetuating Oligarchy - Government by a restricted minority, with little or no input from the masses.",
        "2" => "Participating Democracy - Government by advice and consent of the citizen.",
        "1" => "Corporate - Government by a company managerial elite, citizens are company employees.",
        "0" => "No Government Structure - In many cases, tribal, clan or family bonds predominate",
        "*" => 'Unknown - Invalid mapping'
      }

    LAW_MAP = {
      	'J' => 'Extreme - Routinely Oppressive and Restrictive',
      	'H' => 'Extreme - Legalized Oppressive Practices',
      	'G' => 'Extreme - Severe Punishment for Petty Crime',
      	'F' => 'Extreme - All facets of Daily Life Rigidly Controlled',
      	'E' => 'Extreme - Full-fledged Police State',
      	'D' => 'Extreme - Paramilitary Law Enforcement',
      	'C' => 'Extreme - Unrestricted Invasion of Privacy',
      	'B' => 'Extreme - Restricted Civilian Movement',
      	'A' => 'Extreme - Any Weapons',
      	'9' => 'High - Any Weapons Outside of Home',
      	'8' => 'High - All Bladed Weapons, Non-Lethals',
      	'7' => 'Moderate - All Firearms',
      	'6' => 'Moderate - All Firearms except Shotguns and Non-Lethals',
      	'5' => 'Moderate - Concealed Weapons',
      	'4' => 'Moderate - Light Assault Weapons, Submachine Guns',
      	'3' => 'Low - Heavy Weapons',
      	'2' => 'Low - Portable Energy Weapons',
      	'1' => 'Low - Undetectable Weapons, WMD, Poison Gas',
      	'0' => 'Lawless',
      	"*" => 'Unknown - Invalid mapping'
      }

    TECH_MAP = {
        'X' => 'Pocket Universes Age',
        'W' => 'Remote Technology Age',
        'V' => 'Dyson Sphere Age',
        'U' => 'Reality Engineering Age',
        'T' => 'Ringworlds Age',
        'S' => 'Star Energy Age (KT2)',
        'R' => 'Psionic Engineering Age',
        'Q' => 'Engineered Societies Age',
        'P' => 'Psychohistory Age',
        'N' => 'Planet-Scrubber Age',
        'M' => 'Stasis Age',
        'L' => 'Skipdrive Age',
        'K' => 'Matter Transport Age',
        'J' => 'Exotics Age',
        'H' => 'Personality Transfer Age',
        'G' => 'Artificial Persons Age',
        'F' => 'Anagathics Age',
        'E' => 'Geneering Age',
        'D' => 'Cloning Age',
        'C' => 'Positronics Age',
        'B' => 'FusionPlus Age',
        'A' => 'Fusion Age',
        '9' => 'Gravitics Age',
        '8' => 'Information Age',
        '7' => 'Space Age',
        '6' => 'Atomic Age',
        '5' => 'Broadcast Age',
        '4' => 'Mechanized Age',
        '3' => 'Industrial Revolution Age',
        '2' => 'Age of Sail',
        '1' => 'Iron Age',
        '0' => 'Neolithic',
        "*" => 'Unknown - Invalid mapping'
      }

    BASES_MAP = {
        'Z' => 'Shaper Safehouse', 
        'S' => 'Scout', 
        'N' => 'Navel', 
        '2' => 'Scout and Navel',
        ""  => "None",
        nil => 'None',
        "*" => 'Unknown - Invalid mapping'
    }

    NOTES_MAP = {
        'Ab' => 'Data Repository',
        'Ag' => 'Agriculture',
        'An' => 'Shaper Site',
        'As' => 'Asteroid Belt',
        'Ax' => 'Construct World',
        'Ba' => 'Barren',
        'Co' => 'Cold',
        'Cp' => 'Subsector Capital',
        'Cs' => 'Sector Capital',
        'Cx' => 'Imperial Capital',
        'Cy' => 'Colony',
        'Da' => 'Dangerous',
        'De' => 'Desert',
        'Di' => 'Die Back',
        'Fa' => 'Farming',
        'Fl' => 'Fluid Oceans',
        'Fo' => 'Forbidden',
        'Ga' => 'Garden',
        'He' => 'Hellworld',
        'Hi' => 'High Population Density',
        'Ho' => 'Hot',
        'Ht' => 'High Tech',
        'Ic' => 'Ice-Capped',
        'In' => 'Industrial',
        'Lk' => 'Tidally Locked',
        'Lo' => 'Low Population Density',
        'Lt' => 'Low Tech',
        'Mi' => 'Mining',
        'Mr' => 'Military Rule',
        'Na' => 'Non-Agricultural',
        'Ni' => 'Non-Industrial',
        'Oc' => 'Ocean World',
        'Pa' => 'Pre-Agricultural World',
        'Pe' => 'Penal Colony',
        'Ph' => 'Pre-High Population',
        'Pi' => 'Pre-Industrial',
        'Po' => 'Poor',
        'Pr' => 'Pre-Rich',
        'Px' => 'Prison Camp',
        'Pz' => 'Puzzle World',
        'Re' => 'Restricted',
        'Ri' => 'Rich',
        'Rs' => 'Research Station',
        'Sa' => 'Satellite',
        'Tr' => 'Tropical',
        'Tu' => 'Tundra',
        'Tz' => 'Tidally Locked',
        'Wa' => 'Water World',
        'Va' => 'Vacuum',
        'Xb' => 'Rapid Message Transmission',
        ""   => '',
        nil  => '',
        "*"  => 'Unknown - Invalid mapping'
      }

  end
end