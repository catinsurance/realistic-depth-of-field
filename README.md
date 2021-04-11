# realistic-depth-of-field
A module for realistic depth of field for Roblox.

## Installation

Download the file to your computer and import to Roblox. A link to get it from the Roblox catalog will be available soon.
After you have installed it and imported it to Roblox Studio, place it somewhere that a local script can access. For this example, I'll be using *ReplicatedStorage.*

```lua
local DynamicDepthOfField = require(game:GetService("ReplicatedStorage").path.to.module)

DynamicDepthOfField:Start()
```

## Usage

Below is an example of starting the module.

```lua
local m = require(path.to.module)

local settings = m:GetDefaultSettings()

settings.IgnoreGuiInset = false
settings.InFocusRadius = 30

m:ApplySettings(settings)

m:Start()
```

## Documentation

### Dictionary DynamicDOF:GetDefaultSettings()

Returns a dictionary of the default settings for the module.

### Dictionary DynamicDOF:GetSettings()

Returns the settings currently in use by the module.

### Array DynamicDOF:AddToRaycastFilter( Instance item )

Adds an item to the raycast filter that the module uses for the dynamic depth of field. Returns the updated raycast filter.

### Void DynamicDOF:RemoveFromRaycastFilter( Instance item )

Removes an item from the raycast filter that the module uses for the dynamic depth of field.

### Void DynamicDOF:ApplySettings( Dictionary settings )

Overwrites the current settings with the supplied `settings`. **Every field must be present, so it is recommended to first get the default settings and change them from there.**

Example:

```lua
local m = require(path.to.module)

local settings = m:GetDefaultSettings()

settings.IgnoreCharacter = true

m:ApplySettings(settings)

----------------------------
-- Alternatively, if you want to create the settings table yourself:

local m = require(path.to.module)

local settings = {
	IgnoreGuiInset = true;
	RaycastParameters = RaycastParams.new();
	RayLength = 200;
	CompatibilityForFirstPerson = true;
	NearIntensity = 0.35;
	IgnoreCharacter = false;
	FarIntensity = 0.65;
	FirstPersonThreshold = 2;
	MaxFocusDistance = 200;
	MinFocusDistance = 0.05;
	FilterTranslucentParts = true;
	InFocusRadius = 25;
}

m:ApplySettings(settings)
```

### Void DynamicDOF:Start()

Starts the module. Self-explanatory.

### Void DynamicDOF:Stop()

Stops the module. Self-explanatory.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
