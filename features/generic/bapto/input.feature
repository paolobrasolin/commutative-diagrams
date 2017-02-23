# features/bapto/input.feature
Feature: bapto input key labels nodes

  Background: testing bapto in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.bapto" TikZ library

  Scenario Outline: verifying default behaviour (no overwriting, no aliasing)
    Given I code \pgfkeys{/bapto/trigger/.forward to=/bapto/dispatcher}
    Given I code \tikz\node[<options>]{};
    And I expect a node labeled "foo" to <foo label>
    And I expect a node labeled "bar" to <bar label>
    Then compilation succeeds

    Examples:
      | options                     | foo label | bar label |
      | /bapto/input=bar            | not exist | exist     |
      | name=foo, /bapto/input=bar  | exist     | not exist |
      | alias=foo, /bapto/input=bar | exist     | not exist |
      | /bapto/input=bar, name=foo  | exist     | not exist |
      | /bapto/input=bar, alias=foo | exist     | exist     |
