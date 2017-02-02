# features/katharizo/replacement.feature
Feature: katharizo controls dangerous characters replacement

  Background: testing katharizo
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: using default replacements
    Given the body is
    """
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      input=<input>
    }
    """
    And I dump "\OUTPUT" as "output"
    Then compilation succeeds
    And the dumped "output" is <output>

  Examples:
    | input  | output |
    | {A Z}  | "A Z"  |
    | {$}    | ""     |
    | {(}    | ""     |
    | {)}    | ""     |
    | {,}    | ""     |
    | {.}    | ""     |
    | {:}    | ""     |
    | {\foo} | "foo"  |
    | {_}    | "_"    |

  Scenario Outline: using custom replacements
    Given the body is
    """
    \pgfqkeys{/katharizo/replace}{.cd,
      space={1},
      dollar={2},
      left round brace={3},
      right round brace={4},
      comma={5},
      full stop={6},
      colon={7},
      backslash={8},
      underscore={9}
    }
    \pgfqkeys{/katharizo}{
      output/.store in=\OUTPUT,
      input=<input>
    }
    """
    And I dump "\OUTPUT" as "output"
    Then compilation succeeds
    And the dumped "output" is <output>

  Examples:
    | input  | output |
    | {A Z}  | "A1Z"  |
    | {$}    | "2"    |
    | {(}    | "3"    |
    | {)}    | "4"    |
    | {,}    | "5"    |
    | {.}    | "6"    |
    | {:}    | "7"    |
    | {\foo} | "8foo" |
    | {_}    | "9"    |
