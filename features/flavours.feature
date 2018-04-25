# features/texworld_dialects_and_pipelines.feature
@flavours
Feature: TeXWorld dialects and pipelines

  Scenario Outline: compiling the MWEs
    Given I have a <FLAVOUR> document
    Then compilation succeeds

  Examples:
    | FLAVOUR  |
    | tex      |
    | xetex    |
    | pdftex   |
    | luatex   |
    | latex    |
    | xelatex  |
    | pdflatex |
    | lualatex |
    | context  |

  Scenario Outline: compiling the MnWEs
    Given I have a <FLAVOUR> document
    And the body is
    """
    \CeciNEstPasUneMacro
    """
    Then compilation fails

  Examples:
    | FLAVOUR  |
    | tex      |
    | xetex    |
    | pdftex   |
    | luatex   |
    | latex    |
    | xelatex  |
    | pdflatex |
    | lualatex |
    | context  |