# features/koinos/kDGobbleSoftTok_macro.feature
Feature: kDGobbleSoftTok gobbles all spaces from the token stream

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: verifying the macro does gobble spaces
    Given the body is
    """
    \newtoks\TOKENS
    \TOKENS{<code>}
    \message{the input token list: [\the\TOKENS]}
    \expandafter\TOKENS\expandafter\expandafter
      \expandafter{\expandafter\kDGobbleSoftTok\the\TOKENS}
    \message{the output token list: [\the\TOKENS]}
    """
    Then compilation succeeds
    And the log includes the input token list: [<input toks>]
    And the log includes the output token list: [<output toks>]

    Examples:
      | code     | input toks | output toks |
      | « foo»   | « foo»     | «foo»       |
      | «  foo»  | « foo»     | «foo»       |
      | « \foo»  | « \foo »   | «\foo »     |
      | «  \foo» | « \foo »   | «\foo »     |
