# features/kodi.feature
Feature: koDi library

  Background: everything's ready, yo
    Given I have a "latex" document
    And I am compiling with "latex"
    And I use the "tikz" package
    And I use the "kodi" TikZ library

  Scenario: just trying out the MWE
    Then compilation succeeds
