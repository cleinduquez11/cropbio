import geopandas as gpd

# --- INPUT FILES ---
# Shapefile 1: Source of attributes
shapefile_a = "crop_points_with_id.shp"

# Shapefile 2: Target (geometry will be preserved here)
shapefile_b = "cropbio_data_2025_dry_plots_final.shp"

# --- OUTPUT FILE ---
output_file = "cropbio_dry_data_2025_plots.shp"

# --- FIELD NAME USED FOR JOIN ---
# Must exist in BOTH shapefiles
join_field = "id"

# --- READ FILES ---
gdf_a = gpd.read_file(shapefile_a)
gdf_b = gpd.read_file(shapefile_b)

# --- REMOVE GEOMETRY FROM A (we only want attributes) ---
gdf_a_no_geom = gdf_a.drop(columns="geometry")

# --- JOIN ATTRIBUTES ---
# This adds fields from shapefile A into shapefile B
gdf_joined = gdf_b.merge(
    gdf_a_no_geom,
    on=join_field,
    how="left"  # keeps all features from shapefile B
)

# --- SAVE OUTPUT ---
gdf_joined.to_file(output_file)

print("Join completed successfully.")
print(f"Output saved to: {output_file}")