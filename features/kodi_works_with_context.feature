# features/kodi_works_with_context.feature
Feature: koDi works with ConTeXt

  Background: compiling an MWE
    Given I have a "context" document
    And I am compiling through "context"

  Scenario: using koDi as a TikZ library
    Given I use the "tikz" module
    And I use the "kodi" TikZ library
    And the body is
    """
    \starttikzpicture[kodi]
    \stoptikzpicture
    """
    Then compilation succeeds

  Scenario: using koDi as a ConTeXt module
    Given I use the "kodi" module
    And the body is
    """
    \startkodi
    \stopkodi
    """
    Then compilation succeeds
