# features/foobar.feature
Feature: TeX testing suite

  Scenario Outline: compiling the MWEs
    Given I have a "<dialect>" document
    And I am compiling with "<compiler>"
    And the body is
    """
    Hello world.
    """
    Then compilation succeeds

  Examples:
    | dialect | compiler |
    | tex     | tex      |
    | latex   | latex    |
    # | context | context  |

  Scenario Outline: compiling the MnWEs
    Given I have a "<dialect>" document
    And I am compiling with "<compiler>"
    And the body is
    """
    \CeciNEstPasUneMacro
    """
    Then compilation fails

  Examples:
    | dialect | compiler |
    | tex     | tex      |
    | latex   | latex    |
    # | context | context  |
