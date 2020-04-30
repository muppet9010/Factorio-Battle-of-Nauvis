--[[
    This module is designed to facilitate my personal approach to initilising a mod through the various loading scenarios.
    If this module is called then all vanilla script.X events will be registered this way. So its an all or nothing.
    Setup Events is used to register one or more functions to be run when one a custom setup event occurs, ie. onStartup, onSettingsChanged.
    Intended for use with a fully modular script design to avoid having any links to each modulars functions in a centralised event handler.
    Setup Events:
        - OnStartup: triggered to initilise the mod on a new game, or mod change to an existing game. Any map start modualr script activity is called from here. The setup function will call CreateGlobals, OnLoad and OnSettingsChanged automatically before any subscribed functions are called.
        - CreateGlobals: used to create globals before any functions are called that may try to use them. Should have default values populated that can be overridden in a later Setup Event. Called at the start of OnStartup setup event.
        - OnLoad: used to register any events and remote interfaces. Called when a player joins an existing game (script_on_load) and also during OnStartup setup event.
        - OnSettingsChanged: called by the defines.events.on_runtime_mod_setting_changed but also by the OnStartup setup event. Used to call all modules functions that have a mod setting activity and need to check/apply a posisble change. Either passed through the vanilla event mod setting changed table or nil when called by OnStartup. The nil is specifically to allow startup behaviour.
]]
--local Logging = require("utility/logging")

local SetupEvents = {}
MOD = MOD or {}

--Called from the root of Control.lua before any other registration of setup events can occur.
SetupEvents.Setup = function()
    MOD.setupEvents = {}
    MOD.setupEvents.onStartup = MOD.setupEvents.onStartup or {}
    MOD.setupEvents.onStartup["UTILSSETUPEVENTS_CREATEGLOBALS"] = SetupEvents._HandleCreateGlobalsEvent
    MOD.setupEvents.onStartup["UTILSSETUPEVENTS_ONLOAD"] = SetupEvents._HandleOnLoadEvent
    MOD.setupEvents.onStartup["UTILSSETUPEVENTS_ONSETTINGSCHANGED"] = SetupEvents._HandleOnSettingsChangedEvent
    MOD.setupEvents.createGlobals = MOD.setupEvents.createGlobals or {}
    MOD.setupEvents.onLoad = MOD.setupEvents.onLoad or {}
    MOD.setupEvents.onSettingsChanged = MOD.setupEvents.onSettingsChanged or {}
    script.on_init(SetupEvents._HandleOnStartupEvent)
    script.on_configuration_changed(SetupEvents._HandleOnStartupEvent)
    script.on_event(defines.events.on_runtime_mod_setting_changed, SetupEvents._HandleOnSettingsChangedEvent)
    script.on_load(SetupEvents._HandleOnLoadEvent)
end

--Called from the root of each script file, including Control.lua to register a function to be run on this script event.
SetupEvents.RegisterOnStartupHandler = function(handlerName, handlerFunction)
    if handlerName == nil or handlerFunction == nil then
        error("SetupEvents.RegisterOnStartupHandler called with missing arguments")
    end
    MOD.setupEvents.onStartup[handlerName] = handlerFunction
end

--Called from the root of each script file, including Control.lua to register a function to be run on this script event.
SetupEvents.RegisterCreateGlobalsHandler = function(handlerName, handlerFunction)
    if handlerName == nil or handlerFunction == nil then
        error("SetupEvents.RegisterCreateGlobalsHandler called with missing arguments")
    end
    MOD.setupEvents.createGlobals[handlerName] = handlerFunction
end

--Called from the root of each script file, including Control.lua to register a function to be run on this script event.
SetupEvents.RegisterOnLoadHandler = function(handlerName, handlerFunction)
    if handlerName == nil or handlerFunction == nil then
        error("SetupEvents.RegisterOnLoadHandler called with missing arguments")
    end
    MOD.setupEvents.onLoad[handlerName] = handlerFunction
end

--Called from the root of each script file, including Control.lua to register a function to be run on this script event.
SetupEvents.RegisterOnSettingsChangedHandler = function(handlerName, handlerFunction)
    if handlerName == nil or handlerFunction == nil then
        error("SetupEvents.RegisterOnSettingsChangedHandler called with missing arguments")
    end
    MOD.setupEvents.onSettingsChanged[handlerName] = handlerFunction
end

SetupEvents._HandleOnStartupEvent = function()
    for _, handlerFunction in pairs(MOD.setupEvents.onStartup) do
        handlerFunction()
    end
end

SetupEvents._HandleCreateGlobalsEvent = function()
    for _, handlerFunction in pairs(MOD.setupEvents.createGlobals) do
        handlerFunction()
    end
end

SetupEvents._HandleOnLoadEvent = function()
    for _, handlerFunction in pairs(MOD.setupEvents.onLoad) do
        handlerFunction()
    end
end

SetupEvents._HandleOnSettingsChangedEvent = function()
    for _, handlerFunction in pairs(MOD.setupEvents.onSettingsChanged) do
        handlerFunction()
    end
end

return SetupEvents
