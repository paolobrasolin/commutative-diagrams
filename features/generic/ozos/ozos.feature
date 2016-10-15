# features/ozos/ozos.feature
Feature: ozos

  Background: testing ozos in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.ozos" TikZ library

  Scenario Outline: foobar
    Given I want a debugging dump
    And the body is
    """
    \kDOzosDebugtrue
    \tikz\kDOzos<code>;
    """
    Then compilation succeeds
    And the dumped "options" is "<options>"
    And the dumped "content" is "<content>"

  Examples:
    | code         | options | content |
    | «{foo}»      | «»      | «{foo}» |
    | «[red]{}»    | «[red]» | «{}»    |
    | «[red]{foo}» | «[red]» | «{foo}» |

  Scenario Outline: foobar
    Given the body is
    """
    \kDOzosDebugtrue
    \tikz\kDOzos<code>;
    """
    Then compilation fails

  Examples:
    | code    |
    | «»      |
    | «[red]» |
