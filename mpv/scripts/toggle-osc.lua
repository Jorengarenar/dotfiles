-- Toggle OSC

mp.add_forced_key_binding(null, "toggle-osc",
    function()
        local lavfi = "options/lavfi-complex"
        if mp.get_property_native("vid") ~= 1 then
            if mp.get_property(lavfi) == "" then
                mp.set_property(lavfi, "color[vo]")
            else
                mp.set_property(lavfi, "")
            end
        end
    end
)
