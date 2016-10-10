# features/bapto/self_naming.feature
Feature: bapto's self naming nodes

  Background: testing on TeX
    Given I have a "tex" document
    And I am compiling through "tex"
    And I input the "tikz" file
    And I use the "kodi.katharizo" TikZ library
    And I use the "kodi.bapto" TikZ library
    And I want a debugging dump

  Scenario Outline: hurr durr
    Given I create a self naming node containing "<contents>"
    And I require a node labeled "<label>" to exist
    Then compilation succeeds

  Examples:
    | contents     | label   |
    | {foo}        | foo     |
    | {$\sum x_i$} | sum x_i |
