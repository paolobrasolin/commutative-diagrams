# features/koinos/kDEscapechar__macros.feature
Feature: kDEscapechar* macros toggle escape character in output

  Background: testing koinos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.koinos" TikZ library

  Scenario: disabling and re-enabling escape character
    Given the body is
    """
    \edef\foo{\string\bar}
    \message{the default meaning of the macro: [\meaning\foo]} 
    \kDEscapecharDisable
    \edef\foo{\string\bar}
    \message{the meaning of the macro after disabling: [\meaning\foo]} 
    \kDEscapecharEnable
    \edef\foo{\string\bar}
    \message{the meaning of the macro after enabling: [\meaning\foo]} 
    """
    Then compilation succeeds
    And the log includes the default meaning of the macro: [macro:->\bar]
    And the log includes the meaning of the macro after disabling: [macro:->bar]
    And the log includes the meaning of the macro after enabling: [macro:->\bar]
