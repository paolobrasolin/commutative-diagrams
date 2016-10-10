# features/bapto/self_naming.feature
Feature: bapto's self naming nodes

  Background: testing on TeX
    Given I have a "tex" document
    And I am compiling through "tex"
    And I input the "tikz" file
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
