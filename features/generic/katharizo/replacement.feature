# features/katharizo/replacement.feature
Feature: katharizo replaces arbitrary characters

  Background: testing katharizo
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library

  Scenario Outline: using default replacements
    Given the body is
    """
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      input={<input>}
    }
    \message{the output: [\OUTPUT]}
    """
    Then compilation succeeds
    And the log includes the output: [<output>]

  Examples:
    | input  | output |
    | «A Z»  | «A Z»  |
    | «$»    | «»     |
    | «(»    | «»     |
    | «)»    | «»     |
    | «,»    | «»     |
    | «.»    | «»     |
    | «:»    | «»     |
    | «\foo» | «foo»  |
    | «_»    | «_»    |

  Scenario Outline: using custom replacements
    Given the body is
    """
    \pgfqkeys{/katharizo}{
      replace charcode=32 with {1},
      replace character=$ with {2},
      replace character=( with {3},
      replace character=) with {4},
      replace charcode=44 with {5},
      replace character=. with {6},
      replace character=: with {7},
      replace charcode=92 with {8},
      replace character=_ with {9}
    }
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      input={<input>}
    }
    \message{the output: [\OUTPUT]}
    """
    Then compilation succeeds
    And the log includes the output: [<output>]

  Examples:
    | input  | output |
    | «A Z»  | «A1Z»  |
    | «$»    | «2»    |
    | «(»    | «3»    |
    | «)»    | «4»    |
    | «,»    | «5»    |
    | «.»    | «6»    |
    | «:»    | «7»    |
    | «\foo» | «8foo» |
    | «_»    | «9»    |
