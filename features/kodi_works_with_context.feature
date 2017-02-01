# features/kodi_works_with_context.feature
Feature: koDi works with ConTeXt

  Background: compiling an MWE
    Given I have a "context" document
    And I am compiling through "context"

  Scenario: using koDi as a TikZ library
    Given the preamble is
    """
    \usemodule[tikz]
    \usetikzlibrary[kodi]
    """
    And the body is
    """
    \starttikzpicture[kodi]
    \stoptikzpicture
    """
    Then compilation succeeds

  Scenario: using koDi as a ConTeXt module
    Given the preamble is
    """
    \usemodule[kodi]
    """
    And the body is
    """
    \startkodi
    \stopkodi
    """
    Then compilation succeeds
