# features/koinos/kDIfNextSoftCh_macro.feature
Feature: kDIfNextSoftCh macro performs "soft" token comparison

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: verifying comparison does not ignore whitespace
    Given I code \kDIfNextSoftCh<token>{<true>}{<false>}<code>
    Then compilation succeeds

    Examples: peeping a character stream
      | token         | true   | false  | code |
      | \kDBlankSpace | \HALT  | \relax | «*»  |
      | \kDBlankSpace | \relax | \HALT  | « *» |
      | *             | \relax | \HALT  | «*»  |
      | *             | \HALT  | \relax | « *» |

    Examples: peeping for a terminator
      | token         | true             | false            | code   |
      | \kDBlankSpace | \HALT            | \kDGobbleHardTok | «\kD»  |
      | \kDBlankSpace | \kDGobbleHardTok | \HALT            | « \kD» |
      | \relax        | \HALT            | \kDGobbleHardTok | «\kD»  |
      | \relax        | \HALT            | \kDGobbleHardTok | « \kD» |
      | \UNDEFINED    | \kDGobbleHardTok | \HALT            | «\kD»  |
      | \UNDEFINED    | \HALT            | \kDGobbleHardTok | « \kD» |
      # NOTE: Comparison uses \ifx, so ANY undefined will match an undefined.
