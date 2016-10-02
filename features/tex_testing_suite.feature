# features/texworld_dialects_and_pipelines.feature
Feature: basic dialects and pipelines

  Scenario Outline: compiling the MWEs
    Given I have a "<dialect>" document
    And I am compiling through "<pipeline>"
    Then compilation succeeds
    And I want a screenshot

  Examples:
    | dialect | pipeline |
    | tex     | tex      |
    | latex   | latex    |
    | context | context  |

  Scenario Outline: compiling the MnWEs
    Given I have a "<dialect>" document
    And I am compiling through "<pipeline>"
    And the body is
    """
    \CeciNEstPasUneMacro
    """
    Then compilation fails

  Examples:
    | dialect | pipeline |
    | tex     | tex      |
    | latex   | latex    |
    | context | context  |
