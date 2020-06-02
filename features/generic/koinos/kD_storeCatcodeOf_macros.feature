# features/koinos/kD_storeCatcodeOf_macros.feature
Feature: kD*storeCatcodeOf macros (re)store the catcode of a character

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario: storing, changing and restoring the catcode of a character
    Given the body is
    """
    \message{the default catcode of the character @: \the\catcode`@}
    \kDStoreCatcodeOf @
    \catcode`@=11
    \message{the changed catcode of the character @: \the\catcode`@}
    \kDRestoreCatcodeOf @
    \message{the restored catcode of the character @: \the\catcode`@}
    """
    Then compilation succeeds
    And the log includes the default catcode of the character @: 12
    And the log includes the changed catcode of the character @: 11
    And the log includes the restored catcode of the character @: 12

  Scenario: storing, changing and restoring the catcode of an escaped character
    Given the body is
    """
    \message{the default catcode of the character \%: \the\catcode`\%}
    \kDStoreCatcodeOf\%
    \catcode`\%=10
    \message{the changed catcode of the character \%: \the\catcode`\%}
    \kDRestoreCatcodeOf\%
    \message{the restored catcode of the character \%: \the\catcode`\%}
    """
    Then compilation succeeds
    And the log includes the default catcode of the character \%: 14
    And the log includes the changed catcode of the character \%: 10
    And the log includes the restored catcode of the character \%: 14
