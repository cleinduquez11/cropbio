import pandas as pd
import geopandas as gpd
from shapely.geometry import Point

# --- Function to convert D°MM.SSS format to decimal degrees ---
# def dms_to_dd(dms_str):
#     """
#     Convert a string like '18°03.374' to decimal degrees.
#     18 = degrees, 03 = minutes, 0.374 = seconds
#     """
#     dms_str = dms_str.replace('Â', '')  # Remove encoding artifacts
#     parts = dms_str.split('°')
#     parts1 = parts[1].split('.')
#     degrees = float(parts[0])
    
#     minutes = int(parts1[0])/60
#     seconds = float(parts1[1])/1000/3600
#     print(degrees, minutes , seconds)
#     decimal_degrees = degrees + (minutes) + (seconds)
    
#     return decimal_degrees

# --- Read CSV ---
csv_file = "CropBio_Data_Book_DrySeason2025_FINAL.xlsx - Soil Moisture.csv"  # Replace with your CSV path
df = pd.read_csv(csv_file)

# # --- Convert Lat/Lon to decimal degrees ---
# df['Lat_dd'] = df['Lat'].apply(dms_to_dd)
# df['Lon_dd'] = df['Lon'].apply(dms_to_dd)

# --- Create geometry column ---
geometry = [Point(xy) for xy in zip(df['Lon'], df['Lat'])]
gdf = gpd.GeoDataFrame(df, geometry=geometry)

# --- Set CRS to WGS84 ---
gdf.set_crs(epsg=4326, inplace=True)

# --- Save as shapefile ---
shapefile_path = "crop_points_with_id.shp"
gdf.to_file(shapefile_path)

print(f"Saved shapefile as {shapefile_path}")