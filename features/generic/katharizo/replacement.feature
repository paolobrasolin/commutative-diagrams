# features/katharizo/replacement.feature
Feature: katharizo's replacement control

  Background: testing katharizo in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I want a debugging dump

  Scenario Outline: using default replacements
    Given I code \pgfqkeys{/katharizo}{input=<input>}
    And I dump "\kDKatharizoOutput" as "output"
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

  Scenario Outline: using custom replacements
    Given the body is
    """
    \pgfqkeys{/katharizo/replacements}{.cd,
      space={1},
      dollar={2},
      left round brace={3},
      right round brace={4},
      comma={5},
      full stop={6},
      colon={7},
      backslash={8}
    }
    \pgfqkeys{/katharizo}{input=<input>}
    """
    And I dump "\kDKatharizoOutput" as "output"
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
