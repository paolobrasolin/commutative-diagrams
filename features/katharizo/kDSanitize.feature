# features/katharizo/kDSanitize.feature
Feature: katharizo's kDSanitize macro

  Background: testing on TeX
    Given I have a "tex" document
    And I am compiling through "tex"
    And I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library

  Scenario Outline: sanitizing with \kDSanitize
    Given I sanitize <input>
    Then compilation succeeds
    And the dumped "sanitized" is <output>

  Examples:
    | input    | output |
    | ""       | ""     |
    | " "      | ""     |
    | "  "     | ""     |
    | "X"      | "X"    |
    | "X "     | "X"    |
    | "X  "    | "X"    |
    | " X"     | "X"    |
    | "  X"    | "X"    |
    | "XY"     | "XY"   |
    | "X Y"    | "X Y"  |
    | "X  Y"   | "X Y"  |
    | "\X"     | "X"    |
    | "\X "    | "X"    |
    | "\X  "   | "X"    |
    | " \X"    | "X"    |
    | "  \X"   | "X"    |
    | "\X\Y"   | "X Y"  |
    | "\X \Y"  | "X Y"  |
    | "\X  \Y" | "X Y"  |
