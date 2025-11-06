-- =========================================
-- ✅ AUTO BUYER MODULE (Added by ChatGPT)
-- =========================================

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local network = remotes:WaitForChild("Network")
local remoteEvent = network:WaitForChild("RemoteEvent")

--// Items
local AVAILABLE_ITEMS = {
    "Watering Can",
    "Shovel",
    "Seeds Pack",
    "Fertilizer",
    "Golden Watering Can",
    "Super Shovel",
    "Magic Seeds",
    "Rainbow Fertilizer",
}

local selectedItems = {}
local autoBuyEnabled = false


-- */ Auto Buyer TAB /* --
local BuyerTab = Window:Tab({
    Title = "Auto Buyer",
    Icon = "shopping-bag"
})

BuyerTab:Section({
    Title = "Settings"
})

-- Auto-buy toggle
BuyerTab:Toggle({
    Title = "Enable Auto Buy",
    Desc = "Automatically purchase selected items",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
    end
})


BuyerTab:Space()

-- Section for item toggles
local ItemSection = BuyerTab:Section({
    Title = "Items"
})

for _, itemName in ipairs(AVAILABLE_ITEMS) do
    ItemSection:Toggle({
        Title = itemName,
        Callback = function(state)
            if state then
                table.insert(selectedItems, itemName)
            else
                for i,v in ipairs(selectedItems) do
                    if v == itemName then
                        table.remove(selectedItems, i)
                        break
                    end
                end
            end
        end
    })
end

BuyerTab:Space()

-- Button to manually purchase
BuyerTab:Button({
    Title = "Purchase Selected",
    Color = Color3.fromHex("#3fa8ff"),
    Callback = function()
        if #selectedItems == 0 then
            WindUI:Notify({
                Title = "Auto Buyer",
                Content = "No items selected!",
                Icon = "alert-triangle"
            })
            return
        end
        
        for _, item in ipairs(selectedItems) do
            remoteEvent:FireServer("PurchaseGearItem", item)
            task.wait(.12)
        end
    end
})


-- Auto loop
task.spawn(function()
    while task.wait(1) do
        if autoBuyEnabled and #selectedItems > 0 then
            for _, item in ipairs(selectedItems) do
                remoteEvent:FireServer("PurchaseGearItem", item)
                task.wait(.12)
            end
        end
    end
end)

-- Toggle keybind (H)
BuyerTab:Space()

BuyerTab:Keybind({
    Title = "Toggle UI",
    Desc = "Toggle the UI visibility",
    Value = "H",
    Callback = function(k)
        Window:SetToggleKey(Enum.KeyCode[k])
    end
})
