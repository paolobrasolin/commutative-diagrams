# features/bapto/overwrite_key.feature
Feature: bapto overwriting behaviour is configurable

  Background: testing bapto in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.bapto" TikZ library

  Scenario Outline: default behaviour (no overwriting, no expansion)
    Given I code \pgfkeys{/bapto/trigger/.forward to=/bapto/dispatcher}
    And I code \tikz\node[<options>]{};
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

  Scenario Outline: explicitly configured behaviour
    Given I code \pgfkeys{/bapto/trigger/.forward to=/bapto/dispatcher}
    And I code \pgfqkeys{/bapto}{<behaviour>}
    And I code \tikz\node[<options>]{};
    And I expect a node labeled "foo" to <foo label>
    And I expect a node labeled "bar" to <bar label>
    Then compilation succeeds

    Examples:
      | options                     | behaviour       | foo label | bar label | 
      | /bapto/input=bar            | overwrite=true  | not exist | exist     |
      | /bapto/input=bar            | overwrite=alias | not exist | exist     |
      | /bapto/input=bar            | overwrite=false | not exist | exist     |
      | name=foo, /bapto/input=bar  | overwrite=true  | not exist | exist     |
      | name=foo, /bapto/input=bar  | overwrite=alias | exist     | exist     |
      | name=foo, /bapto/input=bar  | overwrite=false | exist     | not exist |
      | alias=foo, /bapto/input=bar | overwrite=true  | exist     | exist     |
      | alias=foo, /bapto/input=bar | overwrite=alias | exist     | exist     |
      | alias=foo, /bapto/input=bar | overwrite=false | exist     | not exist |
      | /bapto/input=bar, name=foo  | overwrite=true  | exist     | not exist |
      | /bapto/input=bar, name=foo  | overwrite=alias | exist     | exist     |
      | /bapto/input=bar, name=foo  | overwrite=false | exist     | not exist |
      | /bapto/input=bar, alias=foo | overwrite=true  | exist     | exist     |
      | /bapto/input=bar, alias=foo | overwrite=alias | exist     | exist     |
      | /bapto/input=bar, alias=foo | overwrite=false | exist     | exist     |
