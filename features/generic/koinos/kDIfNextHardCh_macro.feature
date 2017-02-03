# features/koinos/kDIfNextHardCh_macro.feature
Feature: kDIfNextHardCh macro performs "hard" token comparison

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library

  Scenario Outline: verifying comparison does ignore whitespace
    Given I code \kDIfNextHardCh<token>{<true>}{<false>}<code>
    Then compilation <outcome>

    Examples:
      | token         | true   | false | code | outcome  |
      | *             | \relax | \HALT | «*»  | succeeds |
      | *             | \relax | \HALT | « *» | succeeds |
      | \kDBlankSpace | \relax | \HALT | «*»  | fails    |
      | \kDBlankSpace | \relax | \HALT | « *» | fails    |
