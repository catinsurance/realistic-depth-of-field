local m = {}
m.__index = m

local rs = game:GetService("RunService")
local players = game:GetService("Players")
local gui = game:GetService("GuiService")


local settings = nil
local data = {}
local plr = players.LocalPlayer 

-- Get default settings of the module.
function m:GetDefaultSettings()
	local p = RaycastParams.new()
	p.IgnoreWater = true
	p.FilterType = Enum.RaycastFilterType.Blacklist

	return {
		IgnoreGuiInset = true;
		RaycastParameters = p;
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
end

-- Initialize stuff
do
	data.AlreadyFiltered = {}
	data.Count = 0
	settings = m:GetDefaultSettings()
end

-- Get the current settings
function m:GetSettings()
	local x = settings
	return x
end

-- ADd to the RaycastParams' FilterDescendantsInstances
function m:AddToRaycastFilter(item)
	local x = settings.RaycastParameters.FilterDescendantsInstances
	table.insert(x, item)
	settings.RaycastParameters.FilterDescendantsInstances = x
	data.FilterCache = x
	return x
end

-- Remove from the RaycastParams' FilterDescendantsInstances
function m:RemoveFromRaycastFilter(item)
	local x = settings.RaycastParameters.FilterDescendantsInstances
	local found = false
	for i,v in pairs(x) do
		if v == item then
			found = true
			table.remove(x, i)
			break
		end
	end
	
	if found then
		data.FilterCache = x
		settings.RaycastParameters.FilterDescendantsInstances = x
		return x
	end
end

-- Sets the module's settings
function m:SetSettings(preferences)
	assert(type(preferences) == "table", "Function SetSettings takes a table as an argument! You gave: " .. type(preferences))
	assert(preferences.IgnoreGuiInset == nil or type(preferences.IgnoreGuiInset) == "boolean", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "IgnoreGuiInset"))
	assert(preferences.RaycastParameters == nil or typeof(preferences.RaycastParameters) == "RaycastParams", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "RaycastParameters"))
	assert(preferences.RayLength == nil or type(preferences.RayLength) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "RayLength"))
	assert(preferences.NearIntensity == nil or type(preferences.NearIntensity) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "NearIntensity"))
	assert(preferences.FarIntensity == nil or type(preferences.FarIntensity) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "FarIntensity"))
	assert(preferences.CompatibilityForFirstPerson ~= nil or type(preferences.CompatibilityForFirstPerson) == "boolean", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "CompatibilityForFirstPerson"))
	assert(preferences.IgnoreCharacter == nil or type(preferences.IgnoreCharacter) == "boolean", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "IgnoreCharacter"))
	assert(preferences.FirstPersonThreshold == nil or type(preferences.FirstPersonThreshold) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "FirstPersonThreshold"))
	assert(preferences.MaxFocusDistance == nil or type(preferences.MaxFocusDistance) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "MaxFocusDistance"))
	assert(preferences.MinFocusDistance == nil or type(preferences.MinFocusDistance) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "MinFocusDistance"))
	assert(preferences.FilterTranslucentParts == nil or type(preferences.FilterTranslucentParts) == "boolean", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "FilterTranslucentParts"))
	assert(preferences.InFocusRadius == nil or type(preferences.InFocusRadius) == "number", string.format("Argument 1 of Function SetSetting's %q property is missing, nil, or of incorrect type.", "InFocusRadius"))
	-- i really hope all these asserts are necessary
	
	settings = preferences
end

local function CreateDOF(cam)
	local dof = Instance.new("DepthOfFieldEffect")
	dof.Name = "DynamicDepthOfField"
	dof.Parent = cam
	dof.NearIntensity = settings.NearIntensity
	dof.FarIntensity = settings.FarIntensity
	dof.InFocusRadius = settings.InFocusRadius
	return dof
end

-- Calls a ray
local function CreateRay(char, pos, direction)
	local cam = data.Camera
	local viewportsize = cam.ViewportSize / 2
	local screensize = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2  - (gui:GetGuiInset().Y/2))
	local unitRay
	if pos and direction then
		unitRay = Ray.new(pos, data.Camera.CFrame.LookVector * (direction * 2))
	else
		if settings.IgnoreGuiInset then
			unitRay = cam:ViewportPointToRay(viewportsize.X, viewportsize.Y)
		else
			unitRay = cam:ScreenPointToRay(screensize.X, screensize.Y)
		end
	end

	if settings.IgnoreCharacter then
		if char then
			if not data.InsertCharacterToBlacklist2 then
				data.InsertCharacterToBlacklist2 = true
				m:AddToRaycastFilter(char)
			end
		end
	end

	if settings.CompatibilityForFirstPerson and not settings.IgnoreCharacter then
		if char then
			local head = char:FindFirstChild("Head") or char.PrimaryPart -- primarypart in case theyre using a custom rig with no head
			if (head.CFrame.Position - cam.CFrame.Position).Magnitude <= settings.FirstPersonThreshold then
				
				if not data.FilterCache then
					data.FilterCache = settings.RaycastParameters.FilterDescendantsInstances
				end
				if not data.InsertCharacterToBlacklist then
					print(direction)
					data.InsertCharacterToBlacklist = true
					m:AddToRaycastFilter(char)
				end
			else
				data.InsertCharacterToBlacklist = false
				m:RemoveFromRaycastFilter(char)
				settings.RaycastParameters.FilterDescendantsInstances = data.FilterCache or settings.RaycastParameters.FilterDescendantsInstances
			end
		end
	end

	local ray = workspace:Raycast(unitRay.Origin, unitRay.Direction * settings.RayLength, settings.RaycastParameters)
	return ray, unitRay.Direction
end

-- Call the function that creates a ray from the middle of the camera. If it hits a translucent part and that
-- configuration is enabled, it will call itself again and ignore the translucent part this time.
function RecursiveRay(cam, pos, direction)
	data.Count += 1
	if data.Count < 5 then
		local ray, dir = CreateRay(data.Character, pos, direction)
		if ray then
			local distance = (ray.Position - cam.CFrame.Position).Magnitude
			if ray.Instance then
				local instance = ray.Instance
				if instance:IsA("BasePart") then
					if instance.Transparency > 0 and settings.FilterTranslucentParts then
						if not data.AlreadyFiltered[instance] then
							data.AlreadyFiltered[instance] = true
							m:AddToRaycastFilter(instance)
						end
						RecursiveRay(cam, ray.Position, distance)
					else -- its not translucent
						if data.AlreadyFiltered[instance] then -- it used to be transparent but now its not. lets stop filtering it
							data.AlreadyFiltered[instance] = false
							m:RemoveFromRaycastFilter(instance)
						end
						data.dof.FocusDistance = math.clamp(distance, settings.MinFocusDistance, settings.MaxFocusDistance)
						data.Count = 0
					end
				else -- its terrain
					data.dof.FocusDistance = math.clamp(distance, settings.MinFocusDistance, settings.MaxFocusDistance)
					data.Count = 0
				end
			else
				data.dof.FocusDistance = math.clamp(distance, settings.MinFocusDistance, settings.MaxFocusDistance)
				data.Count = 0
			end
		else
			data.dof.FocusDistance = settings.MaxFocusDistance
			data.Count = 0
		end
	end -- its stuck inside a translucent part. this can happen for example if youre looking straight down into translucent part, and there
		-- is a barrier beneath the translucent part.
end

-- Start the module
function m:Start()
	if not settings then
		settings = m:GetDefaultSettings()
	end
	
	if not data.RunEvent then
	
		data.RunEvent = rs.Heartbeat:Connect(function(dt)
			data.Camera = workspace.CurrentCamera
			data.Character = plr.Character
			local cam = data.Camera
			if cam then
				data.dof = data.dof or CreateDOF(cam)
				RecursiveRay(cam, nil, nil)
			end
		end)
		
	else
		warn("You already started the module!")
	end
end

-- Stop the module
function m:Stop()
	assert(data.RunEvent ~= nil, "You can't stop the realistic depth of field if you never started it...")
	
	data.RunEvent:Disconnect()
	data.RunEvent = nil
end

return m
