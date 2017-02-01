# features/koinos/kDBlankSpace.feature
Feature: kDBlankSpace macro

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario: using white space reference token
    Given I dump the meaning of "\kDBlankSpace" as "blankspace"
    Then compilation succeeds
    And the dumped "blankspace" is "blank space  "
