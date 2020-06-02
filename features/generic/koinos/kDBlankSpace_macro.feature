# features/koinos/kDBlankSpace_macro.feature
Feature: kDBlankSpace macro means the blank space token

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario: checking the meaning of the macro
    Given the body is
    """
    \message{the meaning of the macro: [\meaning\kDBlankSpace]}
    """
    Then compilation succeeds
    And the log includes the meaning of the macro: [blank space  ]
