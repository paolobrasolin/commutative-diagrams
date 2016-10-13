# features/bapto/self_naming.feature
Feature: bapto's self naming key

  Background: testing bapto in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.bapto" TikZ library

  Scenario Outline: using a self naming node
    Given I code \tikz\node[self naming, node contents=<contents>];
    And I expect a node labeled "<label>" to exist
    Then compilation succeeds

  Examples:
    | contents     | label   |
    | {foo}        | foo     |
    | {$\sum x_i$} | sum x_i |
