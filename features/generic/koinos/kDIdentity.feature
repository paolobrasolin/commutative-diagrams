# features/koinos/kDIdentity.feature
Feature: kDIdentity macro

  Background: testing koinos in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: gobbling whitespace before next token
    Given the body is
    """
    \newtoks\foo
    \foo\expandafter{\kDIdentity<stream>}
    """
    And I dump the "\foo" as "tokenized"
    Then compilation succeeds
    And the dumped "tokenized" is "<tokenized>"

    Examples:
      | stream   | tokenized |
      | « foo»   | «foo»     |
      | «  foo»  | «foo»     |
      | « \foo»  | «\foo »   |
      | «  \foo» | «\foo »   |
