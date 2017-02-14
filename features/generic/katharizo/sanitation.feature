# features/katharizo/sanitation.feature
Feature: katharizo can sanitize tokens to safe strings

  Background: testing katharizo in a generic context
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
      | input    | output |
      | «»       | «»     |
      | « »      | «»     |
      | «  »     | «»     |
      | «X»      | «X»    |
      | «X »     | «X»    |
      | «X  »    | «X»    |
      | « X»     | «X»    |
      | «  X»    | «X»    |
      | «XY»     | «XY»   |
      | «X Y»    | «X Y»  |
      | «X  Y»   | «X Y»  |
      | «\X»     | «X»    |
      | «\X »    | «X»    |
      | «\X  »   | «X»    |
      | « \X»    | «X»    |
      | «  \X»   | «X»    |
      | «\X\Y»   | «X Y»  |
      | «\X \Y»  | «X Y»  |
      | «\X  \Y» | «X Y»  |
