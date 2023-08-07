module = "commutative-diagrams"


supportdir = "."


-- docfiledir       = "doc"
-- docfiles         = { "README" }
-- typesetfiles     = { "main.tex" }
-- typesetsuppfiles = { "doc/*.tex" }
-- typesetexe       = "pdflatex"
-- typesetopts      = "-interaction=nonstopmode -shell-escape"


-- sourcefiledir = "src"
-- sourcefiles   = { "*.sty", "*.tex" }


-- tdslocations = {
--     "tex/generic/" .. module .. "/*.code.tex",
--     "tex/context/third/" .. module .. "/t-*.tex",
--     "tex/latex/" .. module .. "/*.sty",
--     "tex/plain/" .. module .. "/*.tex",
-- }

-- packtdszip = true

checksuppfiles = { "support/generic-regression-test.tex" }
checkconfigs = {
    "check.latex",
    "check.tex",
    "check.context",
}
