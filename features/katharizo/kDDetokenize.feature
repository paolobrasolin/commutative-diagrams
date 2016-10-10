# features/katharizo/kDDetokenize.feature
Feature: katharizo's kDDetokenize macro

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library
    And I want a debugging dump

  Scenario Outline: detokenizing with \kDDetokenize
    Given I code \kDDetokenize<input>\kDInto DETOKENIZED\kDRelax
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