# features/kodi_environment.feature
Feature: koDi environment

  Background: compiling an MWE
    Given I'm using any TeX flavour

  Scenario: using koDi as a TikZ library
    Given I use "tikz"
    And I use the "commutative-diagrams" TikZ library
    And I'm inside a "tikzpicture" with options "[kodi]"
    When the body is empty
    Then compilation succeeds

  Scenario: using koDi as standalone
    Given I use "commutative-diagrams"
    And I'm inside a "kodi"
    When the body is empty
    Then compilation succeeds
