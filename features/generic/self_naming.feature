# features/bapto/self_naming.feature
Feature: bapto's self naming key

  Background: testing bapto in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    # TODO: fix the broken dependencies
    And I use the "commutative-diagrams.katharizo" TikZ library
    And I use the "commutative-diagrams.bapto" TikZ library
    And I use the "commutative-diagrams.ramma" TikZ library

  Scenario Outline: using a self naming node
    Given I code \tikz\node[/codi/self naming, node contents=<contents>];
    And I expect a node labeled "<label>" to exist
    Then compilation succeeds

  Examples:
    | contents     | label     |
    | {foo}        | foo       |
    | {$\sum x_i$} | $sum x_i$ |
