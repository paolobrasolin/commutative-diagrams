# features/koinos/kDFetchOptAndGrpThen_macro.feature
Feature: kDFetchOptAndGrpThen macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump


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
    """
    And I dump the "\kDOptTok" as "options"
    And I dump the "\kDGrpTok" as "group"
    Then compilation succeeds
    And the dumped "options" is "<options>"
    And the dumped "group" is "<group>"

    Examples: 
      | stream    | options | group   |
      | «{};»     | «»      | «»      |
      | « foo{};» | «foo»   | «»      |
      | «\foo{};» | «\foo » | «»      |
      | «{}{};»   | «{}»    | «»      |
      | «{foo};»  | «»      | «foo»   |
      | «{\foo};» | «»      | «\foo » |
      | «{{}};»   | «»      | «{}»    |
