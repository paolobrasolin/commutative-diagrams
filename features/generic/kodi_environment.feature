# features/codi_environment.feature
Feature: CoDi environment

  Background: compiling an MWE
    Given I'm using any TeX flavour

  Scenario: using CoDi as a TikZ library
    Given I use "tikz"
    And I use the "commutative-diagrams" TikZ library
    And I'm inside a "tikzpicture" with options "[codi]"
    When the body is empty
    Then compilation succeeds

  Scenario: using CoDi as standalone
    Given I use "commutative-diagrams"
    And I'm inside a "codi"
    When the body is empty
    Then compilation succeeds
