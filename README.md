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

settings.SmoothTransitions = true
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

settings.SmoothTransitions = true

m:ApplySettings(settings)

----------------------------
-- Alternatively, if you want to create the settings table yourself:

local m = require(script.ModuleScript)

local s = {
	SmoothTransitions = false;
	TransitionTime = 0.25;
	TransitionThreshold = 20;
	IgnoreGuiInset = true;
	RaycastParameters = p;
	RayLength = 200;
	CompatibilityForFirstPerson = true;
	NearIntensity = 0.35;
	FarIntensity = 0.65;
	FirstPersonThreshold = 2;
	MaxFocusDistance = 200;
	MinFocusDistance = 0.05;
	FilterTranslucentParts = true;
	InFocusRadius = 25;
}

m:ApplySettings(s)

m:Start()
m:ApplySettings(settings)
```

### Void DynamicDOF:Start()

Starts the module. Self-explanatory.

### Void DynamicDOF:Stop()

Stops the module. Self-explanatory.

## Module Settings

The module has many settings that you can play around with. Below explains what each setting does.

### Boolean SmoothTransitions (default: false)

If you find the jump of focus between, for example, looking at something far away to looking at something up-close too jarring, you can turn on SmoothTransitions. This basically tweens the FocusDistance property of the depth of field effect, emulating how your eyes take a second to adjust focus to something up-close/far away.

### Number TransitionTime (default: 0.25)

How long the tween is for the SmoothTransitions property. This takes time in seconds.

### Number TransitionThreshold (default: 20)

The distance required from your last looked-at location to your new looked-at location in studs required for the SmoothTransitions effect to actually take place.

### Boolean IgnoreGuiInset (default: true)

Tells the module to ignore the 36 pixel gap the top-bar creates when finding the center of the screen. This is set to true by default because your mouse also ignores the gui inset when in first person mode.

### RaycastParams RaycastParameters (default: RaycastParams p)

Want to make the module not ignore water, or make the raycast filter a whitelist instead of a blacklist? Create a new [RaycastParams](https://developer.roblox.com/en-us/api-reference/datatype/RaycastParams) objec and set this property to the aforementioned new object.

### Number RayLength (default: 200)

The length of the ray that is cast from the middle of the screen. This is by default 200 because the max the focus distance can be for a DepthOfFieldEffect is 200.

### Number NearIntensity (default: 0.35)

The intensity of the blur of objects in the foreground.

### Number FarIntensity (default: 0.65)

The intensity of the blur of objects in the background.

### Number FirstPersonThreshold (default: 2)

The maximum distance in studs the camera needs to be from the head of the character to determine if the player is in first person or not.

### Number MaxFocusDistance (default: 200)

The maximum distance the FocusDistance of the DepthOfFieldEffect can be set to. Anything higher than 200 or lower than 0.05 is futile, as those are the maximum and minimum numbers the DepthOfFieldEffect takes for it's FocusDistance respectively.

### Number MinFocusDistance (default: 0.05)

The minimum distance the FocusDistance of the DepthOfFieldEffect can be set to. Anything higher than 200 or lower than 0.05 is futile, as those are the maximum and minimum numbers the DepthOfFieldEffect takes for it's FocusDistance respectively.

### Boolean FilterTranslucentParts (default: true)

Tells the model to filter parts with a transparency greater than 0. This is useful if your RaycastParams' filter is on blacklist (which by default it is), as it'll ignore things like windows which usually are semi-transparent (or translucent). If you have your RaycastParams' filter on whitelist mode for whatever reason, you'll want to turn this off.

### Number InFocusRadius (default: 25) 

Determines the InFocusRadius property of the DepthOfFieldEffect.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
