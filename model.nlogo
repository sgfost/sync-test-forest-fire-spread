patches-own [
  vegetation-type     ; "forest", "grassland", "water", "bare"
  fuel-load          ; amount of combustible material
  moisture-content   ; current moisture level
  elevation          ; height above sea level
  fire-intensity     ; current fire strength
  burn-time          ; how long patch has been burning
  recovery-time      ; time since last fire for regrowth
]

globals [
  wind-speed
  wind-direction
  humidity
  temperature
  total-burned
  active-fires
  suppression-efforts
  fire-perimeter
]

to setup
  clear-all
  setup-terrain
  setup-vegetation
  setup-weather
  reset-ticks
end

to setup-terrain
  ask patches [
    ; Create elevation gradient
    set elevation (distancexy 0 0) + random-float 5
    
    ; Determine vegetation type based on elevation and moisture
    let moisture-factor random-float 1.0
    
    if elevation < 5 and moisture-factor > 0.7 [
      set vegetation-type "water"
      set fuel-load 0
      set pcolor blue
    ]
    [
      if elevation < 15 and moisture-factor > 0.3 [
        set vegetation-type "grassland"
        set fuel-load 20 + random 30
        set pcolor yellow
      ]
      [
        set vegetation-type "forest"
        set fuel-load 40 + random 40
        set pcolor green
      ]
    ]
    
    set moisture-content 30 + random 40
    set fire-intensity 0
    set burn-time 0
    set recovery-time 0
  ]
end

to setup-vegetation
  ; Add some variation to forest density
  ask patches with [vegetation-type = "forest"] [
    if random 100 < forest-density [
      set fuel-load fuel-load + 20
      set pcolor green - 1
    ]
  ]
  
  ; Create bare patches (roads, clearings)
  ask n-of (count patches * 0.05) patches [
    if vegetation-type != "water" [
      set vegetation-type "bare"
      set fuel-load 0
      set pcolor brown
    ]
  ]
end

to setup-weather
  set wind-speed 5 + random 15
  set wind-direction random 360
  set humidity 30 + random 40
  set temperature 20 + random 15
end

to go
  update-weather
  spread-fire
  burn-patches
  suppress-fires
  recover-vegetation
  update-statistics
  tick
end

to ignite-fire
  ; Manual fire ignition by clicking
  ask patch mouse-xcor mouse-ycor [
    if vegetation-type != "water" and fuel-load > 0 [
      set fire-intensity 100
      set burn-time 1
      set pcolor red
    ]
  ]
end

to update-weather
  ; Simple weather dynamics
  set wind-speed max (list 0 (wind-speed + random 4 - 2))
  set wind-direction wind-direction + random 20 - 10
  set humidity max (list 10 min (list 90 (humidity + random 6 - 3)))
  set temperature max (list 0 min (list 45 (temperature + random 4 - 2)))
  
  ; Update moisture content based on weather
  ask patches [
    let moisture-change (humidity - 50) / 10
    set moisture-content max (list 0 min (list 100 (moisture-content + moisture-change)))
  ]
end

to spread-fire
  ask patches with [fire-intensity > 0] [
    let fire-strength fire-intensity
    let spread-probability base-spread-rate
    
    ; Wind effects
    let wind-factor wind-speed / 20
    
    ask neighbors [
      if vegetation-type != "water" and fuel-load > 0 and fire-intensity = 0 [
        let ignition-prob spread-probability
        
        ; Fuel load increases fire spread
        set ignition-prob ignition-prob * (fuel-load / 50)
        
        ; Moisture reduces fire spread
        set ignition-prob ignition-prob * (1 - moisture-content / 100)
        
        ; Temperature increases fire spread
        set ignition-prob ignition-prob * (1 + (temperature - 20) / 50)
        
        ; Wind direction affects spread
        let wind-angle subtract-headings wind-direction towards myself
        let wind-boost 1 + (wind-factor * cos wind-angle)
        set ignition-prob ignition-prob * wind-boost
        
        ; Elevation affects spread (fire spreads uphill faster)
        let slope-factor ifelse-value (elevation > [elevation] of myself) [1.5] [0.8]
        set ignition-prob ignition-prob * slope-factor
        
        if random-float 1.0 < ignition-prob [
          set fire-intensity 80 + random 20
          set burn-time 1
          set pcolor red
        ]
      ]
    ]
  ]
end

to burn-patches
  ask patches with [fire-intensity > 0] [
    set burn-time burn-time + 1
    
    ; Fire intensity decreases over time
    set fire-intensity fire-intensity - (5 + random 5)
    
    ; Consume fuel
    set fuel-load max (list 0 (fuel-load - 2))
    
    ; Update visual representation
    if fire-intensity > 60 [
      set pcolor red
    ] [
      if fire-intensity > 30 [
        set pcolor orange
      ] [
        if fire-intensity > 0 [
          set pcolor yellow
        ] [
          ; Fire burns out
          set pcolor black
          set recovery-time 0
        ]
      ]
    ]
    
    ; Fire dies when fuel is consumed or intensity drops to zero
    if fuel-load <= 0 or fire-intensity <= 0 [
      set fire-intensity 0
      set burn-time 0
      set pcolor black
    ]
  ]
end

to suppress-fires
  ; Simple fire suppression model
  if suppression-active [
    ask n-of min (list 5 count patches with [fire-intensity > 0]) patches with [fire-intensity > 0] [
      set fire-intensity fire-intensity - 20
      set moisture-content moisture-content + 30
    ]
  ]
end

to recover-vegetation
  ask patches with [fire-intensity = 0 and pcolor = black] [
    set recovery-time recovery-time + 1
    
    ; Gradual vegetation recovery
    if recovery-time > 50 [
      if vegetation-type = "grassland" [
        set fuel-load fuel-load + 1
        if fuel-load >= 20 [
          set pcolor yellow
        ]
      ]
      
      if vegetation-type = "forest" and recovery-time > 200 [
        set fuel-load fuel-load + 0.5
        if fuel-load >= 30 [
          set pcolor green
        ]
      ]
    ]
  ]
end

to update-statistics
  set total-burned count patches with [pcolor = black]
  set active-fires count patches with [fire-intensity > 0]
  set fire-perimeter count patches with [fire-intensity > 0 and any? neighbors with [fire-intensity = 0]]
end 