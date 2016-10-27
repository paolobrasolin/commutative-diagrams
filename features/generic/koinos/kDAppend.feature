# features/koinos/kDAppend.feature
Feature: kDAppend macro

  Background: testing koinos in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: appending token lists
    Given the body is
    """
    \newtoks\foo\foo={<foo>}
    \newtoks\bar\bar={<bar>}
    \kDAppend\bar\foo
    """
    And I dump the "\foo" as "foo"
    Then compilation succeeds
    And the dumped "foo" is "<concatenation>"

    Examples:
      | foo | bar | concatenation |
      | foo | bar | foobar        |
