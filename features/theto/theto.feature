# features/katharizo/kDDetokenize.feature
Feature: theto

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.theto" TikZ library

  Scenario: laying a 3x3 square grid
    Given the body is
    """
    \tikz\matrix[theto]{
      A & B & C \\
      D & E & F \\
      G & H & I \\
    };
    """
    Then compilation succeeds
