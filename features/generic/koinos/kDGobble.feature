# features/koinos/kDGobble.feature
Feature: kDGobble macro

  Background: testing koinos in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: gobbling next token
    Given I code <code>
    Then compilation <outcome>

    Examples:
      | code                | outcome  |
      | \HALT               | fails    |
      | \kDGobble\HALT      | succeeds |
      | \kDGobble\HALT\HALT | fails    |
      | \kDGobble \HALT     | succeeds |
