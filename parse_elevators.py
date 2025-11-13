import json
import re

# Read the GeoJSON file
with open('cgcElevators2025.geojson', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Filter Saskatchewan elevators only
sk_elevators = []
for feature in data['features']:
    props = feature['properties']
    coords = feature['geometry']['coordinates']

    # Check if it's in Saskatchewan
    province = props.get('PR', '')

    if province == 'SK':
        sk_elevators.append({
            'name': props.get('Station', ''),
            'company': props.get('Licensee', ''),
            'lon': coords[0],
            'lat': coords[1],
            'capacity': props.get('Capacity_tonne', 0),
            'elevator_type': props.get('Elevator_type', 'Primary'),
            'railway': props.get('Railway', 'NO'),
            'car_spots': props.get('Car_Spot_Open', '< 25'),
            'grain_types': ''  # Not in this dataset
        })

# Sort by name
sk_elevators.sort(key=lambda x: x['name'])

# Generate SQL
sql_lines = []
sql_lines.append('-- Import Saskatchewan Grain Elevators from Agriculture Canada 2025 data')
sql_lines.append('-- Source: https://agriculture.canada.ca/atlas/data_donnees/cgcElevators/')
sql_lines.append('')
sql_lines.append('-- Clear existing elevator data (optional - comment out to keep existing data)')
sql_lines.append('-- DELETE FROM elevators;')
sql_lines.append('')
sql_lines.append('-- Insert all Saskatchewan elevators')
sql_lines.append('INSERT INTO elevators (name, company, location, address, capacity_tonnes, grain_types, railway, elevator_type, car_spots, created_at) VALUES')

insert_values = []
for elev in sk_elevators:
    # Clean up name
    name = elev['name'].replace("'", "''")
    company = elev['company'].replace("'", "''")

    # Elevator type
    elev_type = elev['elevator_type'] if elev['elevator_type'] else 'Primary'

    # Assign grain types based on elevator type and company
    company_lower = company.lower()
    if 'pulse' in company_lower or 'alliance' in company_lower:
        grain_array = "ARRAY['Peas', 'Lentils', 'Chickpeas']"
    elif 'malt' in company_lower:
        grain_array = "ARRAY['Barley', 'Wheat']"
    elif elev_type == 'Process':
        # Processing elevators often specialize
        if 'canola' in name.lower() or 'bunge' in company_lower:
            grain_array = "ARRAY['Canola']"
        elif 'oat' in company_lower or 'oat' in name.lower():
            grain_array = "ARRAY['Oats', 'Wheat']"
        else:
            grain_array = "ARRAY['Wheat', 'Canola']"
    else:
        # Primary elevators handle multiple grains
        grain_array = "ARRAY['Wheat', 'Canola', 'Barley']"

    # Format capacity
    try:
        capacity = int(float(elev['capacity']))
    except:
        capacity = 0

    # Railway
    railway = elev['railway'] if elev['railway'] else 'NO'

    # Car spots
    car_spots = elev['car_spots'] if elev['car_spots'] else '< 25'

    # Create address from name (extract city)
    address = name.split(' - ')[0] if ' - ' in name else name
    address = address + ', SK'
    address = address.replace("'", "''")

    value = f"('{name}', '{company}', ST_SetSRID(ST_MakePoint({elev['lon']}, {elev['lat']}), 4326)::geography, '{address}', {capacity}, {grain_array}, '{railway}', '{elev_type}', '{car_spots}', NOW())"
    insert_values.append(value)

# Join all values with commas
sql_lines.append(',\n'.join(insert_values) + ';')
sql_lines.append('')
sql_lines.append('-- Add indexes for better query performance')
sql_lines.append('CREATE INDEX IF NOT EXISTS idx_elevators_location ON elevators USING GIST(location);')
sql_lines.append('CREATE INDEX IF NOT EXISTS idx_elevators_company ON elevators(company);')
sql_lines.append('CREATE INDEX IF NOT EXISTS idx_elevators_capacity ON elevators(capacity_tonnes);')
sql_lines.append('')
sql_lines.append('-- Update statistics')
sql_lines.append('ANALYZE elevators;')

# Write to file
with open('import_elevators_complete.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql_lines))

print(f'Generated SQL import script with {len(sk_elevators)} Saskatchewan elevators')
print(f'Output: import_elevators_complete.sql')
