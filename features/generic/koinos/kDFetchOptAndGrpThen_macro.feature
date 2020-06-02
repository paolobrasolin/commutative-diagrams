# features/koinos/kDFetchOptAndGrpThen_macro.feature
Feature: kDFetchOptAndGrpThen macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: testing baseline syntax
    Given the body is
    """
    \kDFetchOptAndGrpThen<then><stream>
    """
    Then compilation <outcome>

    Examples: stream must terminate with a group and a semicolon character
      | then   | stream  | outcome  |
      | \relax | «;»     | fails    |
      | \relax | «{}»    | fails    |
      | \relax | «{};»   | succeeds |

    Examples: clause is executed
      | then   | stream  | outcome  |
      | \HALT  | «{};»   | fails    |


  Scenario Outline: testing token capturing
    Given the body is
    """
    \kDFetchOptAndGrpThen\relax<stream>
    \message{the captured options: [\the\kDOptTok]}
    \message{the captured group: [\the\kDGrpTok]}
    """
    Then compilation succeeds
    And the log includes the captured options: [<options>]
    And the log includes the captured group: [<group>]

    Examples: 
      | stream    | options | group   |
      | «{};»     | «»      | «»      |
      | « foo{};» | «foo»   | «»      |
      | «\foo{};» | «\foo » | «»      |
      | «{}{};»   | «{}»    | «»      |
      | «{foo};»  | «»      | «foo»   |
      | «{\foo};» | «»      | «\foo » |
      | «{{}};»   | «»      | «{}»    |
