# features/koinos/kDIfNextHardCh_macro.feature
Feature: kDIfNextHardCh macro performs "hard" token comparison

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: verifying comparison does ignore whitespace
    Given I code \kDIfNextHardCh<token>{<true>}{<false>}<code>
    Then compilation succeeds

    Examples: peeping a character stream
      | token         | true   | false  | code |
      | *             | \relax | \HALT  | «*»  |
      | *             | \relax | \HALT  | « *» |

    Examples: peeping for a terminator
      | token      | true             | false            | code   |
      | \relax     | \HALT            | \kDGobbleHardTok | «\kD»  |
      | \relax     | \HALT            | \kDGobbleHardTok | « \kD» |
      | \UNDEFINED | \kDGobbleHardTok | \HALT            | «\kD»  |
      | \UNDEFINED | \kDGobbleHardTok | \HALT            | « \kD» |
      # NOTE: Comparison uses \ifx, so ANY undefined will match an undefined.
