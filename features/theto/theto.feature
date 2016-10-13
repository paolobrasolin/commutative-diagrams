# features/theto/theto.feature
Feature: theto

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.theto" TikZ library

  @focus
  Scenario Outline: using cells with no node options
    Given I want a debugging dump
    And the body is
    """
    \let\foo\relax
    \let\bar\relax
    \tikz\matrix[theto]{%
    <code>&X&X\\
    X&<code>&X\\
    X&X&<code>\\
    };
    """
    Then compilation succeeds
    And the dump gives "<options>" and "<content>" for cells
      | row | col |
      | 1   | 1   |
      | 2   | 2   |
      | 3   | 3   |

  Examples: empty cell
    | code   | content | options |
    | «»     | «»      | «»      |
    | «    » | «»      | «»      |
  Examples: text
    | code       | content   | options |
    | «foo»      | «foo»     | «»      |
    | «  foo»    | «foo»     | «»      |
    | «foo  »    | «foo»     | «»      |
    | «foo  bar» | «foo bar» | «»      |
  Examples: macros
    | code         | content      | options |
    | «\foo»       | «\foo »      | «»      |
    | «  \foo»     | «\foo »      | «»      |
    | «\foo  »     | «\foo »      | «»      |
    | «\foo\bar»   | «\foo \bar » | «»      |
    | «\foo  \bar» | «\foo \bar » | «»      |

  Scenario Outline: using cells with node options
    Given I want a debugging dump
    And the body is
    """
    \let\foo\relax
    \tikz\matrix[theto]{%
    <code>&X&X\\
    X&<code>&X\\
    X&X&<code>\\
    };
    """
    Then compilation succeeds
    And the dump gives "<options>" and "<content>" for cells
      | row | col |
      | 1   | 1   |
      | 2   | 2   |
      | 3   | 3   |

  Examples: empty cell
    | code       | content | options |
    | «\|[]\|»   | «»      | «[]»    |
    | «  \|[]\|» | «»      | «[]»    |
    | «\|[]\|  » | «»      | «[]»    |
  Examples: text
    | code          | content | options |
    | «\|[]\|foo»   | «foo»   | «[]»    |
    | «  \|[]\|foo» | «foo»   | «[]»    |
    | «\|[]\|  foo» | «foo»   | «[]»    |
  Examples: macros
    | code           | content | options |
    | «\|[]\|\foo»   | «\foo » | «[]»    |
    | «  \|[]\|\foo» | «\foo » | «[]»    |
    | «\|[]\|  \foo» | «\foo » | «[]»    |
