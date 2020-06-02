# features/koinos/kDAppend_macro.feature
Feature: kDAppend macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: appending token lists
    Given the body is
    """
    \newtoks\FOO\FOO={<foo>}
    \newtoks\BAR\BAR={<bar>}
    \kDAppend\BAR\FOO
    \message{the concatenation: [\the\FOO]}
    """
    Then compilation succeeds
    And the log includes the concatenation: [<concatenation>]

    Examples:
      | foo  | bar  | concatenation |
      | foo  | bar  | «foobar»      |
      | \foo | bar  | «\foo bar»    |
      | foo  | \bar | «foo\bar »    |
      | \foo | \bar | «\foo \bar »  |
