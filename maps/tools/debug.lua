
global.debug = {
    enabled = false
}

local function _log(message) 
    if global.debug.enabled == true then
        log(message)
    end
end

local function logCallback(callback)
    if global.debug.enabled == true then
        log(callback())
    end
end

local function enable()
    global.debug.enabled = true
end

local function disable()
    global.debug.enabled = false
end


return {
    log = _log,
    logCallback = logCallback,
    enable = enable,
    disable = disable
}