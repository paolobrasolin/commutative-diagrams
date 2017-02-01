# features/koinos/kDAppend.feature
Feature: kDAppend macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: appending token lists
    Given the body is
    """
    \newtoks\FOO\FOO={<foo>}
    \newtoks\BAR\BAR={<bar>}
    \kDAppend\BAR\FOO
    """
    And I dump the "\FOO" as "foo"
    Then compilation succeeds
    And the dumped "foo" is "<concatenation>"

    Examples:
      | foo | bar | concatenation |
      | foo | bar | foobar        |
