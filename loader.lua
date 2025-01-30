local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local KEY_URL = "https://raw.githubusercontent.com/MyZann/loader/refs/heads/main/key.txt" -- Replace with your keys.txt URL

local function CheckKey(key)
    local success, response = pcall(HttpService.GetAsync, KEY_URL) -- pcall for error handling

    if success then
        local keys = response:split("\n") -- Split the response into lines (keys)

        for _, validKey in ipairs(keys) do
            if key == validKey then
                return true -- Key is valid
            end
        end

        return false -- Key is invalid
    else
        warn("Error fetching keys: " .. response) -- Log the error
        return false -- Treat as invalid if there's an error
    end
end

-- Example Usage (Prompt the player for a key):
local keyPrompt = Instance.new("TextBox")
keyPrompt.Parent = Player.PlayerGui
keyPrompt.PlaceholderText = "Enter Key"
keyPrompt.Size = UDim2.new(0, 200, 0, 50)
keyPrompt.Position = UDim2.new(0.5, -100, 0.5, -25) -- Center the textbox

keyPrompt.FocusLost:Connect(function()
    local enteredKey = keyPrompt.Text

    if CheckKey(enteredKey) then
        print("Key is valid!")
        keyPrompt:Destroy() -- Remove the prompt
        -- Grant access to your game's features here
        -- ... your game logic ...
    else
        print("Invalid key.")
        keyPrompt.Text = "" -- Clear the textbox
        -- Optionally, display an error message to the player
    end
end)

-- (Optional) Automatically check for a saved key:
local savedKey = game:GetService("DataStoreService"):GetGlobalDataStore():GetAsync("key")

if savedKey then
  if CheckKey(savedKey) then
    print("Saved key is valid!")
    -- Grant access to your game's features here
  else
    print("Saved key is invalid. Please enter a new key.")
    -- Display key prompt
  end
end
