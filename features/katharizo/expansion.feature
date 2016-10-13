# features/katharizo/expansion.feature
Feature: katharizo's expansion control

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library
    And I want a debugging dump

  Scenario Outline: using koDi as a TikZ library
    Given the body is
    """
    \def\EXPANDEDONCE{FULLYEXPANDED}
    \def\NOTEXPANDED{\EXPANDEDONCE}
    \pgfqkeys{/katharizo}{
      expand=<expand>,
      input={\NOTEXPANDED}
    }
    """
    And I dump "\kDKatharizoOutput" as "output"
    Then compilation succeeds
    And the dumped value of "output" is "<output>"

  Examples:
    | expand | output        |
    | none   | NOTEXPANDED   |
    | once   | EXPANDEDONCE  |
    | full   | FULLYEXPANDED |
