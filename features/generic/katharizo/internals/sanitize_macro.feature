# features/katharizo/sanitize_macro.feature
Feature: \kDKatharizoSanitize macro

  Background: testing katharizo in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library

  Scenario Outline: sanitizing with \kDSanitize
    Given the body is
    """
    \kDKatharizoSanitize<input>\kDInto SANITIZED\kD
    \message{the sanitized output: [\SANITIZED]}
    """
    Then compilation succeeds
    And the log includes the sanitized output: <output>

  Examples:
    | input    | output |
    | {}       | []     |
    | { }      | []     |
    | {  }     | []     |
    | {X}      | [X]    |
    | {X }     | [X]    |
    | {X  }    | [X]    |
    | { X}     | [X]    |
    | {  X}    | [X]    |
    | {XY}     | [XY]   |
    | {X Y}    | [X Y]  |
    | {X  Y}   | [X Y]  |
    | {\X}     | [X]    |
    | {\X }    | [X]    |
    | {\X  }   | [X]    |
    | { \X}    | [X]    |
    | {  \X}   | [X]    |
    | {\X\Y}   | [X Y]  |
    | {\X \Y}  | [X Y]  |
    | {\X  \Y} | [X Y]  |
