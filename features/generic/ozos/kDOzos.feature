# features/ozos/kDOzos.feature
Feature: kDOzos macro

  Background: testing ozos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.ozos" TikZ library
    And I want a debugging dump

  Scenario Outline: testing baseline parsing
    Given the body is
    """
    \tikz\kDOzos<code>;
    """
    Then compilation succeeds
    And the dumped «options» is <options>
    And the dumped «content» is <content>

    Examples:
      | code         | options | content |
      | «{foo}»      | «»      | «foo»   |
      | «[red]{}»    | «[red]» | «»      |
      | «[red]{foo}» | «[red]» | «foo»   |

  Scenario Outline: testing correct expansion of code
    Given the body is
    """
    \tikz\kDOzos<code>;
    """
    Then compilation fails

    Examples:
      | code         |
      | «{\HALT}»    |
      | «[HALT]{}»   |

  Scenario: testing execution of universal styles
    Given the body is
    """
    \pgfkeys{/ozos/every node/.code={\HALT}}
    \tikz\kDOzos{};
    """
    Then compilation fails
