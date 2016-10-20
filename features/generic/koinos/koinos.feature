# features/koinos/koinos.feature
Feature: koinos

  Background: testing koinos in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library

  Scenario Outline: foobar
    Given I want a debugging dump
    And the body is
    """
    \kDIfNext<tact>Ch<token>{<true>}{<false>}<code>
    """
    Then compilation <outcome>

    Examples:
      | tact | token         | true   | false | code  | outcome  |
      | Soft | *             | \relax | \HALT | «*»   | succeeds |
      | Soft | *             | \relax | \HALT | « *»  | fails    |
      | Soft | \kDBlankSpace | \relax | \HALT | «*»   | fails    |
      | Soft | \kDBlankSpace | \relax | \HALT | « *»  | succeeds |
      | Hard | *             | \relax | \HALT | «*»   | succeeds |
      | Hard | *             | \relax | \HALT | « *»  | succeeds |
      | Hard | \kDBlankSpace | \relax | \HALT | «*»   | fails    |
      | Hard | \kDBlankSpace | \relax | \HALT | « *»  | fails    |

