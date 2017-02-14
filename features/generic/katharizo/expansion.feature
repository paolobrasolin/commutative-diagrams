# features/katharizo/expansion.feature
Feature: katharizo controls macro expansion

  Background: testing katharizo
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library

  Scenario: using default expansion behaviour
    Given the body is
    """
    \def\NOTEXPANDED{\EXPANDED}
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      input=\NOTEXPANDED,
    }
    \message{the output: \OUTPUT}
    """
    Then compilation succeeds
    And the log includes the output: NOTEXPANDED

  Scenario Outline: using custom expansion behaviour
    Given the body is
    """
    \def\EXPANDEDONCE{FULLYEXPANDED}
    \def\NOTEXPANDED{\EXPANDEDONCE}
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      expand=<expand>,
      input=\NOTEXPANDED,
    }
    \message{the output: \OUTPUT}
    """
    Then compilation succeeds
    And the log includes the output: <output>

  Examples:
    | expand | output        |
    | none   | NOTEXPANDED   |
    | once   | EXPANDEDONCE  |
    | full   | FULLYEXPANDED |
