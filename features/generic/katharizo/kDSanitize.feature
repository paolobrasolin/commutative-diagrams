# features/katharizo/kDSanitize.feature
Feature: katharizo's kDSanitize macro

  Background: testing katharizo in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: sanitizing with \kDSanitize
    Given I code \kDSanitize<input>\kDInto SANITIZED\kD
    And I dump "\SANITIZED" as "sanitized"
    Then compilation succeeds
    And the dumped "sanitized" is <output>

  Examples:
    | input    | output |
    | {}       | ""     |
    | { }      | ""     |
    | {  }     | ""     |
    | {X}      | "X"    |
    | {X }     | "X"    |
    | {X  }    | "X"    |
    | { X}     | "X"    |
    | {  X}    | "X"    |
    | {XY}     | "XY"   |
    | {X Y}    | "X Y"  |
    | {X  Y}   | "X Y"  |
    | {\X}     | "X"    |
    | {\X }    | "X"    |
    | {\X  }   | "X"    |
    | { \X}    | "X"    |
    | {  \X}   | "X"    |
    | {\X\Y}   | "X Y"  |
    | {\X \Y}  | "X Y"  |
    | {\X  \Y} | "X Y"  |
