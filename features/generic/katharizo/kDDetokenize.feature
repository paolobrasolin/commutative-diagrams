# features/katharizo/kDDetokenize.feature
Feature: katharizo's kDDetokenize macro

  Background: testing katharizo in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: detokenizing with \kDDetokenize
    Given I code \kDDetokenize<input>\kDInto DETOKENIZED\kD
    And I dump "\DETOKENIZED" as "detokenized"
    Then compilation succeeds
    And the dumped "detokenized" is <output>

  Examples:
    | input    | output   |
    | {}       | ""       |
    | { }      | " "      |
    | {  }     | " "      |
    | {X}      | "X"      |
    | {X }     | "X "     |
    | {X  }    | "X "     |
    | { X}     | " X"     |
    | {  X}    | " X"     |
    | {XY}     | "XY"     |
    | {X Y}    | "X Y"    |
    | {X  Y}   | "X Y"    |
    | {\X}     | "\X "    |
    | {\X }    | "\X "    |
    | {\X  }   | "\X "    |
    | { \X}    | " \X "   |
    | {  \X}   | " \X "   |
    | {\X\Y}   | "\X \Y " |
    | {\X \Y}  | "\X \Y " |
    | {\X  \Y} | "\X \Y " |
