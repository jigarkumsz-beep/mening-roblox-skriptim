local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local heldPart = nil
local bodyPos = nil
local bodyGyro = nil
local holdDistance = 12 -- Narsani ushlab turish masofasi
local throwForce = 120  -- Uloqtirish kuchi

-- Sichqoncha bosilganda narsani ushlash
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local target = mouse.Target
		-- Faqat mahkamlanmagan (Anchored = false) narsalarni ushlash
		if target and not target.Anchored and target:IsA("BasePart") then
			heldPart = target
			
			bodyPos = Instance.new("BodyPosition")
			bodyPos.MaxForce = Vector3.new(10000, 10000, 10000)
			bodyPos.P = 15000
			bodyPos.D = 500
			bodyPos.Parent = heldPart
			
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
			bodyGyro.Parent = heldPart
		end
	elseif input.KeyCode == Enum.KeyCode.F and heldPart then
		-- "F" tugmasi bosilganda narsani oldinga uloqtirish
		local camera = workspace.CurrentCamera
		local throwDirection = camera.CFrame.LookVector
		local partToThrow = heldPart
		
		-- Ushlab turishni to'xtatish
		if bodyPos then bodyPos:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		heldPart = nil
		
		-- Kuch berish
		partToThrow.AssemblyLinearVelocity = throwDirection * throwForce
	end
end)

-- Sichqoncha qo'yib yuborilganda narsani tushirish
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and heldPart then
		if bodyPos then bodyPos:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		heldPart = nil
	end
end)

-- Har bir kadrda ushlangan narsani kamera oldida ushlab turish
RunService.RenderStepped:Connect(function()
	if heldPart and bodyPos then
		local camera = workspace.CurrentCamera
		local targetPosition = camera.CFrame.Position + (camera.CFrame.LookVector * holdDistance)
		bodyPos.Position = targetPosition
		bodyGyro.CFrame = camera.CFrame
	end
end)
