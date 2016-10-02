# features/kodi_context.feature
Feature: koDi works with ConTeXt

  Background: trying to compile a MWE
    Given I have a "context" document
    And I am compiling with "context"

  Scenario: using koDi as a library
    Given I use the "tikz" module
    And I use the "kodi" TikZ library
    And the body is
    """
    \starttikzpicture[kodi]
    \stoptikzpicture
    """
    Then compilation succeeds

  Scenario: using koDi as a module
    Given I use the "kodi" module
    And the body is
    """
    \startkodi
    \stopkodi
    """
    Then compilation succeeds
