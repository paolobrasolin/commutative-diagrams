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
      replace character=( with {2},
      replace character=) with {3},
      replace charcode=44 with {4},
      replace character=. with {5},
      replace character=: with {6},
      replace charcode=92 with {7},
      replace character=_ with {8}
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
    | «(»    | «2»    |
    | «)»    | «3»    |
    | «,»    | «4»    |
    | «.»    | «5»    |
    | «:»    | «6»    |
    | «\foo» | «7foo» |
    | «_»    | «8»    |

  Scenario Outline: using custom replacements
    Given the body is
    """
    \pgfqkeys{/katharizo}{
      remove character=b,
      remove characters=c,
      remove characters=def,
      remove characters=g h i,
      remove charcode=66,
      remove charcodes=67,
      remove charcodes=68 69 70,
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
    | input   | output |
    | «a z»   | «a z»  |
    | «abz»   | «az»   |
    | «acz»   | «az»   |
    | «adefz» | «az»   |
    | «aghiz» | «az»   |
    | «ABZ»   | «AZ»   |
    | «ACZ»   | «AZ»   |
    | «ADEFZ» | «AZ»   |
