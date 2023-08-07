checkengines = { "luametatex", "luatex" }
checkformat  = "context"


specialformats         = specialformats or {}
specialformats.context = {
    luametatex = { binary = "context", format = "" },
    luatex = { binary = "context", format = "", options = "--luatex" },
}
