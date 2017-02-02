# features/bapto/bapto_keys.feature
Feature: bapto keys

  Background: testing bapto in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.bapto" TikZ library

  Scenario Outline: using default behaviour (overwrite=false)
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

  Scenario Outline: setting overwriting behaviour
    Given I code \pgfqkeys{/bapto}{overwrite=<overwrite>}
    And I code \tikz\node[<options>]{};
    And I expect a node labeled "foo" to <foo label>
    And I expect a node labeled "bar" to <bar label>
    Then compilation succeeds

    Examples:
      | options                     | overwrite | foo label | bar label |
      | /bapto/input=bar            | true      | not exist | exist     |
      | /bapto/input=bar            | alias     | not exist | exist     |
      | /bapto/input=bar            | false     | not exist | exist     |
      | name=foo, /bapto/input=bar  | true      | not exist | exist     |
      | name=foo, /bapto/input=bar  | alias     | exist     | exist     |
      | name=foo, /bapto/input=bar  | false     | exist     | not exist |
      | alias=foo, /bapto/input=bar | true      | exist     | exist     |
      | alias=foo, /bapto/input=bar | alias     | exist     | exist     |
      | alias=foo, /bapto/input=bar | false     | exist     | not exist |
      | /bapto/input=bar, name=foo  | true      | exist     | not exist |
      | /bapto/input=bar, name=foo  | alias     | exist     | exist     |
      | /bapto/input=bar, name=foo  | false     | exist     | not exist |
      | /bapto/input=bar, alias=foo | true      | exist     | exist     |
      | /bapto/input=bar, alias=foo | alias     | exist     | exist     |
      | /bapto/input=bar, alias=foo | false     | exist     | exist     |
