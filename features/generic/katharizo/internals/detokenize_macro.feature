# features/katharizo/detokenize_macro.feature
Feature: \kDKatharizoDetokenize macro

  Background: testing katharizo in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library

  Scenario Outline: detokenizing with \kDDetokenize
    Given the body is
    """
    \kDKatharizoDetokenize<input>\kDInto DETOKENIZED\kD
    \message{the detokenized output: [\DETOKENIZED]}
    """
    Then compilation succeeds
    And the log includes the detokenized output: <output>

  Examples:
    | input    | output   |
    | {}       | []       |
    | { }      | [ ]      |
    | {  }     | [ ]      |
    | {X}      | [X]      |
    | {X }     | [X ]     |
    | {X  }    | [X ]     |
    | { X}     | [ X]     |
    | {  X}    | [ X]     |
    | {XY}     | [XY]     |
    | {X Y}    | [X Y]    |
    | {X  Y}   | [X Y]    |
    | {\X}     | [\X ]    |
    | {\X }    | [\X ]    |
    | {\X  }   | [\X ]    |
    | { \X}    | [ \X ]   |
    | {  \X}   | [ \X ]   |
    | {\X\Y}   | [\X \Y ] |
    | {\X \Y}  | [\X \Y ] |
    | {\X  \Y} | [\X \Y ] |
