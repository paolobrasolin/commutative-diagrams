# features/koinos/kDTrimTrailingSpace_macro.feature
Feature: kDTrimTrailingSpace trims trailing spaces from a token list

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario Outline: using (un)defined macros in token list
    Given the body is
    """
    \let\DEFINED\relax
    \newtoks\TOKENS
    \TOKENS{<code>}
    \kDTrimTrailingSpace\TOKENS
    """
    Then compilation <outcome>

    Examples:
      | code         | outcome  |
      | «\DEFINED»   | succeeds |
      | «\UNDEFINED» | fails    |
      # NOTE: i.e. this only works when everything is defined,
      #   the reason being the internal use of \ifx to search
      #   for an undefined terminator.
  
  Scenario Outline: verifying the macro does trim trailing spaces
    Given the body is
    """
    \let\foo\relax
    \newtoks\TOKENS
    \TOKENS{<code>}
    \message{the input token list: [\the\TOKENS]}
    \kDTrimTrailingSpace\TOKENS
    \message{the output token list: [\the\TOKENS]}
    """
    Then compilation succeeds
    And the log includes the input token list: [<input toks>]
    And the log includes the output token list: [<output toks>]

    Examples:
      | code     | input toks | output toks |
      | «»       | «»         | «»          |
      | « »      | « »        | «»          |
      | « »      | « »        | «»          |
      | «  »     | « »        | «»          |
      | «foo»    | «foo»      | «foo»       |
      | «foo »   | «foo »     | «foo»       |
      | «foo  »  | «foo »     | «foo»       |
      | «\foo»   | «\foo »    | «\foo »     |
      | «\foo »  | «\foo »    | «\foo »     |
      | «\foo  » | «\foo »    | «\foo »     |
