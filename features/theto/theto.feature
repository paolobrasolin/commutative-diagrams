# features/katharizo/kDDetokenize.feature
Feature: theto

  Background: compiling an MWE
    Given I have a "tex" document
    And I am compiling through "tex"
    Given I input the "tikz" file
    And I use the "kodi.theto" TikZ library

  Scenario Outline: using empty cells with options
    Given I want a debugging dump
    And the body is
    """
    \let\foo\relax
    \let\bar\relax
    \let\baz\relax
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
    | «foo  »    | «foo »    | «»      |
    | «foo  bar» | «foo bar» | «»      |
  Examples: macros
    | code         | content      | options |
    | «\foo»       | «\foo »      | «»      |
    | «  \foo»     | «\foo »      | «»      |
    | «\foo  »     | «\foo »      | «»      |
    | «\foo\bar»   | «\foo \bar » | «»      |
    | «\foo  \bar» | «\foo \bar » | «»      |
