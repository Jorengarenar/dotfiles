mp.observe_property("media-title", "string",
    function(name, val)
        pl_pos   = mp.get_property('playlist-pos', '')
        pl_title = mp.get_property("playlist/" .. pl_pos .. "/title", '')
        mp.set_property("force-media-title", pl_title)
    end)
