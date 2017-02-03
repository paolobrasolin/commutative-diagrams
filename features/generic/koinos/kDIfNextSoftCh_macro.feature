# features/koinos/kDIfNextSoftCh_macro.feature
Feature: kDIfNextSoftCh macro performs "soft" token comparison

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library

  Scenario Outline: verifying comparison does not ignore whitespace
    Given I code \kDIfNextSoftCh<token>{<true>}{<false>}<code>
    Then compilation <outcome>

    Examples:
      | token         | true   | false | code | outcome  |
      | *             | \relax | \HALT | «*»  | succeeds |
      | *             | \relax | \HALT | « *» | fails    |
      | \kDBlankSpace | \relax | \HALT | «*»  | fails    |
      | \kDBlankSpace | \relax | \HALT | « *» | succeeds |
