import pandas as pd

# --- Function to convert D°MM.mmm format to decimal degrees ---
def dms_to_dd(dms_str):
    """
    Convert a string like '18°03.374' to decimal degrees
    """
    dms_str = dms_str.replace('Â', '')  # Remove any weird encoding artifacts
    parts = dms_str.split('°')
    degrees = float(parts[0])
    minutes = float(parts[1])
    decimal = degrees + minutes / 60
    return decimal

# --- Read CSV ---
csv_file = "CropBio_Data_Book_DrySeason2025_FINAL.xlsx - Soil Moisture.csv"  # Replace with your CSV path
df = pd.read_csv(csv_file)

# --- Convert Lat/Lon to decimal degrees ---
df['Lat_dd'] = df['Lat'].apply(dms_to_dd)
df['Lon_dd'] = df['Lon'].apply(dms_to_dd)

# --- Save as XYZ points ---
# Format: name,x,y,z
# We'll assume z = 0 (no elevation) unless provided
xyz_file = "points.xyz"
with open(xyz_file, 'w') as f:
    for _, row in df.iterrows():
        name = row['CODE']
        x = row['Lon_dd']
        y = row['Lat_dd']
        z = 0
        f.write(f"{name},{x},{y},{z}\n")

print(f"Saved XYZ points to {xyz_file}")