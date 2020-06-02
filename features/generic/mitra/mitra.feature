# features/mitra/mitra.feature
Feature: mitra

  Background: testing mitra in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.mitra" TikZ library
    And I want a debugging dump

  # Scenario Outline: using a cell with an unknown TikZ key
    # Given I code \tikz\matrix[mitra]{|[foo]|};
    # Then compilation fails

  Scenario Outline: using cells with no node options
    Given the body is
    """
    \let\FOO\relax
    \let\BAR\relax
    \tikz\kDMitra{%
    <code>&X&X\\
    X&<code>&X\\
    X&X&<code>\\
    };
    """
    Then compilation succeeds
    And the dump gives <options> and <content> for cells
      | row | col |
      | 1   | 1   |
      | 2   | 2   |
      | 3   | 3   |

  Examples: empty cell
    | code | content | options |
    | «»   | «»      | «»      |
    | «  » | «»      | «»      |
  Examples: text
    | code       | content   | options |
    | «foo»      | «foo»     | «»      |
    | «  foo»    | «foo»     | «»      |
    | «foo  »    | «foo»     | «»      |
    | «foo  bar» | «foo bar» | «»      |
  Examples: macros
    | code         | content      | options |
    | «\FOO»       | «\FOO »      | «»      |
    | «  \FOO»     | «\FOO »      | «»      |
    | «\FOO  »     | «\FOO »      | «»      |
    | «\FOO\BAR»   | «\FOO \BAR » | «»      |
    | «\FOO  \BAR» | «\FOO \BAR » | «»      |

  # Scenario Outline: using cells with node options
    # Given the body is
    # """
    # \let\FOO\relax
    # \tikz\kDMitra{%
    # <code>&X&X\\
    # X&<code>&X\\
    # X&X&<code>\\
    # };
    # """
    # Then compilation succeeds
    # And the dump gives <options> and <content> for cells
      # | row | col |
      # | 1   | 1   |
      # | 2   | 2   |
      # | 3   | 3   |
# 
  # Examples: empty cell
    # | code       | content | options |
    # | «\|[]\|»   | «»      | «[]»    |
    # | «  \|[]\|» | «»      | «[]»    |
    # | «\|[]\|  » | «»      | «[]»    |
  # Examples: text
    # | code          | content | options |
    # | «\|[]\|foo»   | «foo»   | «[]»    |
    # | «  \|[]\|foo» | «foo»   | «[]»    |
    # | «\|[]\|  foo» | «foo»   | «[]»    |
  # Examples: macros
    # | code           | content | options |
    # | «\|[]\|\FOO»   | «\FOO » | «[]»    |
    # | «  \|[]\|\FOO» | «\FOO » | «[]»    |
    # | «\|[]\|  \FOO» | «\FOO » | «[]»    |
