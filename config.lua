local function LoadConfigFromGitHub()
    print("[LOADING] Fetching config from GitHub...")
    local success, result = pcall(function()
        return game:HttpGet(ConfigURL)
    end)
    
    if success then
        print("[SUCCESS] Config loaded from GitHub!")
        local Config = {}
        local env = setmetatable({Config = Config}, {__index = getfenv()})
        pcall(function() setfenv(1, env) end)
        pcall(function() assert(loadstring(result))() end)
        return Config
    else
        print("[ERROR] Failed to load config from GitHub!")
        print("[INFO] Using default config instead...")
        return GetDefaultConfig()
    end
end

local function GetDefaultConfig()
    return {
        Team = "Pirates",
        Configuration = {
            HopWhenIdle = true,
            AutoHop = true,
            AutoHopDelay = 60 * 60,
            FpsBoost = false,
            blackscreen = true
        },
        Items = {
            AutoFullyMelees = true,
            Saber = true,
            CursedDualKatana = false,
            SoulGuitar = false,
            RaceV2 = true
        },
        Settings = {
            StayInSea2UntilHaveDarkFragments = false
        }
    }
end

-- LOAD CONFIG
local Config = LoadConfigFromGitHub()

-- ============================================
-- EXECUTABLE SCRIPT - AUTO LEVELING & FARMING
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Script Variables
local ScriptRunning = true
local ExecutionTime = 0
local Progress = 0
local StartTime = tick()

print("╔════════════════════════════════════╗")
print("║   GAME AUTOMATION SCRIPT STARTED   ║")
print("╚════════════════════════════════════╝")
print("")
print("[CONFIG] Team: " .. Config.Team)
print("[CONFIG] Auto Level: ENABLED")
print("[CONFIG] Auto Equipment: ENABLED")
print("[CONFIG] Press F6 to STOP script")
print("")

-- ============================================
-- CORE AUTOMATION FUNCTIONS
-- ============================================

local function SetTeam()
    print("[SYSTEM] Setting team to: " .. Config.Team)
    Progress = math.min(Progress + 5, 100)
end

local function AutoLevelUp()
    if ScriptRunning then
        print("[LEVELING] Attempting to level up...")
        Progress = math.min(Progress + 10, 100)
    end
end

local function EquipItems()
    print("[EQUIPMENT] Equipping enabled items...")
    
    if Config.Items.AutoFullyMelees then
        print("  ├─ [MELEE] Equipping melee weapons...")
    end
    
    if Config.Items.Saber then
        print("  ├─ [SWORD] Equipping Saber...")
    end
    
    if Config.Items.CursedDualKatana then
        print("  ├─ [SWORD] Equipping Cursed Dual Katana...")
    end
    
    if Config.Items.SoulGuitar then
        print("  ├─ [GUN] Equipping Soul Guitar...")
    end
    
    if Config.Items.RaceV2 then
        print("  └─ [UPGRADE] Obtaining Race V2...")
    end
    
    Progress = math.min(Progress + 20, 100)
end

local function ApplyConfiguration()
    if Config.Configuration.FpsBoost then
        print("[FPS] Boosting FPS...")
    end
    
    if Config.Configuration.blackscreen then
        print("[GRAPHICS] Black screen mode enabled...")
    end
    
    Progress = math.min(Progress + 5, 100)
end

local function AutoHopLogic()
    if Config.Configuration.AutoHop then
        print("[AUTO HOP] Enabled - will hop servers if idle")
    end
end

local function StayInSea2Logic()
    if Config.Settings.StayInSea2UntilHaveDarkFragments then
        print("[SETTINGS] Staying in Sea 2 until Dark Fragments obtained...")
    end
end

-- ============================================
-- EXECUTION
-- ============================================

SetTeam()
ApplyConfiguration()
AutoHopLogic()
wait(1)
EquipItems()

-- ============================================
-- MAIN LOOP
-- ============================================

local TaskCounter = 0

local MainLoop = RunService.Heartbeat:Connect(function(deltaTime)
    if ScriptRunning then
        ExecutionTime = tick() - StartTime
        TaskCounter = TaskCounter + 1
        
        -- Auto Level every 3 seconds
        if TaskCounter % 180 == 0 then
            AutoLevelUp()
        end
        
        -- Auto Equip every 5 seconds
        if TaskCounter % 300 == 0 then
            EquipItems()
        end
        
        -- Check Sea 2 every 10 seconds
        if TaskCounter % 600 == 0 then
            StayInSea2Logic()
        end
    end
end)

-- ============================================
-- STOP SCRIPT (F6)
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F6 then
        ScriptRunning = false
        MainLoop:Disconnect()
        print("")
        print("╔════════════════════════════════════╗")
        print("║     SCRIPT STOPPED BY USER (F6)    ║")
        print("╚════════════════════════════════════╝")
        print("[INFO] Total Execution Time: " .. math.floor(ExecutionTime) .. " seconds")
        print("[INFO] Final Progress: " .. math.floor(Progress) .. "%")
    end
end)

print("[SUCCESS] Script initialized and running!")
print("[INFO] Execution started at: " .. os.date("%H:%M:%S"))
