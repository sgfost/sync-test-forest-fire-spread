# Forest Fire Spread Simulation

## Overview
This agent-based model simulates wildfire spread through a heterogeneous landscape, incorporating terrain features, weather conditions, vegetation types, and fire suppression efforts to demonstrate complex fire behavior dynamics.

## Environment

### Patch Attributes
- **`vegetation-type`**: Land cover classification (forest/grassland/water/bare)
- **`fuel-load`**: Amount of combustible material available
- **`moisture-content`**: Current moisture level affecting fire spread
- **`elevation`**: Terrain height influencing fire behavior
- **`fire-intensity`**: Current fire strength (0-100)
- **`burn-time`**: Duration patch has been actively burning
- **`recovery-time`**: Time since fire for vegetation regrowth

### Terrain Types
- **Forest** (Green): High fuel load, slower recovery
- **Grassland** (Yellow): Moderate fuel load, faster recovery  
- **Water** (Blue): No fuel, fire barrier
- **Bare** (Brown): No fuel, represents roads/clearings

## Fire Dynamics

### Ignition
- Manual ignition by clicking on patches
- Requires combustible vegetation and fuel load > 0
- Initial fire intensity set to maximum (100)

### Spread Mechanisms
Fire spread probability influenced by:
- **Fuel Load**: More fuel = higher spread probability
- **Moisture Content**: Higher moisture = reduced spread
- **Wind Speed & Direction**: Directional spread enhancement
- **Temperature**: Higher temperature = increased spread
- **Topography**: Fire spreads faster uphill
- **Base Spread Rate**: Fundamental fire propagation parameter

### Fire Progression
- Fire intensity decreases over time as fuel is consumed
- Visual progression: Red (intense) → Orange (moderate) → Yellow (dying) → Black (burned)
- Fire extinguishes when fuel depleted or intensity reaches zero

## Weather System

### Dynamic Weather Variables
- **Wind Speed**: Affects spread rate and direction (0-20+ units)
- **Wind Direction**: Determines preferential spread direction (0-360°)
- **Humidity**: Influences vegetation moisture content (10-90%)
- **Temperature**: Affects fire spread probability (0-45°C)

### Weather-Fire Interactions
- High humidity increases vegetation moisture
- Low humidity and high temperature create fire-prone conditions
- Wind creates directional bias in fire spread
- Weather variables change dynamically during simulation

## Fire Management

### Suppression Efforts
- Toggle `suppression-active` to enable/disable firefighting
- Suppression reduces fire intensity and increases local moisture
- Limited suppression capacity (5 patches per time step)
- Targets currently burning areas for intervention

### Natural Barriers
- Water bodies prevent fire spread
- Bare patches (roads, clearings) can act as firebreaks
- Elevation changes affect spread patterns

## Vegetation Recovery

### Post-Fire Regeneration
- Burned areas (black patches) begin recovery process
- **Grassland**: Faster recovery (50+ time steps)
- **Forest**: Slower recovery (200+ time steps)
- Fuel load gradually rebuilds over time

## Key Parameters
- `forest-density`: Controls forest fuel load variation
- `base-spread-rate`: Fundamental fire spread probability
- `suppression-active`: Enables/disables fire suppression

## Measured Outputs
- `total-burned`: Total number of burned patches
- `active-fires`: Current patches with active fire
- `fire-perimeter`: Fire edge length
- Real-time weather conditions (wind, humidity, temperature)

## Research Applications
This model can be used to study:
- Wildfire spread patterns under different weather conditions
- Effectiveness of firebreak placement and suppression strategies
- Impact of landscape heterogeneity on fire behavior
- Climate change effects on fire frequency and intensity
- Fuel management and prescribed burning strategies

## Usage
1. Click "Setup" to generate random landscape
2. Adjust `forest-density` and `base-spread-rate` parameters
3. Click on patches to ignite fires manually
4. Toggle `suppression-active` to test firefighting scenarios
5. Click "Go" for single time step or toggle for continuous simulation
6. Monitor fire statistics and weather conditions in real-time

## Advanced Features
- Multiple simultaneous fires possible
- Realistic topographic and weather influences
- Vegetation recovery and fuel accumulation cycles
- Spatially explicit fire suppression modeling 