# features/kodi_works_with_tex.feature
Feature: koDi works with TeX

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"

  Scenario: using koDi as a TikZ library
    Given the preamble is
    """
    \input tikz
    \usetikzlibrary{kodi}
    """
    And the body is
    """
    \tikzpicture[kodi]
    \endtikzpicture
    """
    Then compilation succeeds

  Scenario: using koDi as a TeX input
    Given the preamble is
    """
    \input kodi
    """
    And the body is
    """
    \kodi
    \endkodi
    """
    Then compilation succeeds
