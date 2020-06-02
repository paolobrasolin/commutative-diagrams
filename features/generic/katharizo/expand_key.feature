# features/katharizo/expand_key.feature
Feature: katharizo expansion behaviour is configurable

  Background: testing katharizo in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.katharizo" TikZ library

  Scenario: default behaviour (no expansion)
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

  Scenario Outline: explicitly configured behaviour
    Given the body is
    """
    \def\EXPANDEDONCE{FULLYEXPANDED}
    \def\NOTEXPANDED{\EXPANDEDONCE}
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      <behaviour>,
      input=\NOTEXPANDED,
    }
    \message{the output: \OUTPUT}
    """
    Then compilation succeeds
    And the log includes the output: <output>

  Examples:
    | behaviour   | output        |
    | expand=none | NOTEXPANDED   |
    | expand=once | EXPANDEDONCE  |
    | expand=full | FULLYEXPANDED |
