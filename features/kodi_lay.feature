# features/kodi_lay.feature
Feature: koDi grid layouting

  Background: working with koDi in a standalone LaTeX document
    Given I have a "latex" document
    And I am compiling through "pdflatex"
    And the preamble is
    """
    \documentclass{standalone}
    """
    And I use the "kodi" package
    And I'm inside a "kodi" environment


  Scenario: laying a 3x3 square grid
    Given the body is
    """
    \lay[square]{
      A & B & C \\
      D & E & F \\
      G & H & I \\
    };
    """
    Then compilation succeeds
