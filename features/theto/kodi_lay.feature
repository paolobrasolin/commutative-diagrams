# features/katharizo/kDDetokenize.feature
Feature: katharizo's kDDetokenize macro

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library
    And I want a debugging dump

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
