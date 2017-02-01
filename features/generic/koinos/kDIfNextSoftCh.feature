# features/koinos/kDIfNextDoftCh.feature
Feature: kDIfNextSoftCh macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: comparing token with next token in stream
    Given the body is
    """
    \kDIfNextSoftCh<token>{<true>}{<false>}<stream>
    """
    Then compilation <outcome>

    Examples:
      | token         | true   | false | stream | outcome  |
      | *             | \relax | \HALT | «*»    | succeeds |
      | *             | \relax | \HALT | « *»   | fails    |
      | \kDBlankSpace | \relax | \HALT | «*»    | fails    |
      | \kDBlankSpace | \relax | \HALT | « *»   | succeeds |
