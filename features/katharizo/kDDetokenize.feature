# features/katharizo/kDDetokenize.feature
Feature: katharizo's kDDetokenize macro

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library

  Scenario Outline: detokenizing with \kDDetokenize
    Given I detokenize <input>
    Then compilation succeeds
    And the dumped "detokenized" is <output>

  Examples:
    | input    | output   |
    | ""       | ""       |
    | " "      | " "      |
    | "  "     | " "      |
    | "X"      | "X"      |
    | "X "     | "X "     |
    | "X  "    | "X "     |
    | " X"     | " X"     |
    | "  X"    | " X"     |
    | "XY"     | "XY"     |
    | "X Y"    | "X Y"    |
    | "X  Y"   | "X Y"    |
    | "\X"     | "\X "    |
    | "\X "    | "\X "    |
    | "\X  "   | "\X "    |
    | " \X"    | " \X "   |
    | "  \X"   | " \X "   |
    | "\X\Y"   | "\X \Y " |
    | "\X \Y"  | "\X \Y " |
    | "\X  \Y" | "\X \Y " |




  # Scenario Outline: using koDi as a TikZ library
    # Given I input the "tikz" file
    # And I use the "kodi.katharizo" TikZ library
    # And the body is
    # """
    # \def\EXPANDEDONCE{FULLYEXPANDED}
    # \def\UNEXPANDED{\EXPANDEDONCE}
    # \pgfqkeys{/katharizo}{
      # expand={<expand>},
      # input={\UNEXPANDED{}}
    # }
    # \newwrite\file
    # \immediate\openout\file=\jobname.yml
    # \immediate\write\file{output: '\kDKatharizoOutput'}
    # \closeout\file
    # """
    # Then compilation succeeds
    # And the dumped "output" is "<output>"
# 
  # Examples:
    # | expand | output        |
    # | none   | NOTEXPANDED   |
    # | once   | EXPANDEDONCE  |
    # | full   | FULLYEXPANDED |
