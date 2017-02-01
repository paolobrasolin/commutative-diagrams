# features/kodi_works_with_latex.feature
Feature: koDi works with LaTeX

  Background: compiling an MWE
    Given I have a "latex" document
    And I am compiling through "latex"

  Scenario: using koDi as a TikZ library
    Given the preamble contains
    """
    \usepackage{tikz}
    \usetikzlibrary{kodi}
    """
    And the body is
    """
    \begin{tikzpicture}[kodi]
    \end{tikzpicture}
    """
    Then compilation succeeds

  Scenario: using koDi as a LaTeX package
    Given the preamble contains
    """
    \usepackage{kodi}
    """
    And the body is
    """
    \begin{kodi}
    \end{kodi}
    """
    Then compilation succeeds
