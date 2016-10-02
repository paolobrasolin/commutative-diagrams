# features/kodi_works_with_tex.feature
Feature: koDi works with TeX

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"

  Scenario: using koDi as a TikZ library
    Given I input the "tikz.tex" file
    And I use the "kodi" TikZ library
    And the body is
    """
    \tikzpicture[kodi]
    \endtikzpicture
    """
    Then compilation succeeds

  Scenario: using koDi as a TeX input
    Given I input the "kodi.tex" file
    And the body is
    """
    \kodi
    \endkodi
    """
    Then compilation succeeds
