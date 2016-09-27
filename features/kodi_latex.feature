# features/kodi_latex.feature
Feature: koDi works with LaTeX

  Background: trying to compile a MWE
    Given I have a "latex" document
    And I am compiling with "latex"

  Scenario: using koDi as a library
    Given I use the "tikz" package
    And I use the "kodi" TikZ library
    And the body is
    """
    \begin{tikzpicture}[kodi]
    \end{tikzpicture}
    """
    Then compilation succeeds

  Scenario: using koDi as a package
    Given I use the "kodi" package
    And the body is
    """
    \begin{kodi}
    \end{kodi}
    """
    Then compilation succeeds
