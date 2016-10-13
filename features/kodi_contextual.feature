# features/kodi_contextual.feature
Feature: koDi works with LaTeX

  Background: compiling an MWE
    Given I'm in a context

  Scenario: using koDi as a TikZ library
    Given I require "tikz"
    And I use the "kodi" TikZ library
    And the body is
    """
    \tikzpicture[kodi]
    \endtikzpicture
    """
    Then compilation succeeds
