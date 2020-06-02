# features/ektropi/restore_key.feature
Feature: ektropi restore key restores the original handler

  Background: testing ektropi in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.ektropi" TikZ library

  Scenario Outline: undoing a single deviation
    Given the body is
    """
    \pgfkeys{
      /foo/bar/.code={}
    }
    \tikz\node[/ektropi/add=/foo]<keylists>{};
    """
    Then compilation <outcome>

  Examples: test key works as expected
    | keylists    | outcome  |
    | [bar]       | succeeds |

  Examples: handler is restored at call point
    | keylists                | outcome  |
    | [bar][/ektropi/restore] | succeeds |
    | [bar, /ektropi/restore] | succeeds |
    | [/ektropi/restore, bar] | fails    |
    | [/ektropi/restore][bar] | fails    |

  Scenario Outline: there is a naming conflict
    Given the body is
    """
    \pgfkeys{
      /tikz/foo/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
      /quux/foo/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
    }
    \tikz\node[/ektropi/add=/quux]<keylists>{};
    """
    Then compilation succeeds
    And the log includes <string>

  Examples: test keys work as expected
    | keylists    | string    |
    | [/tikz/foo] | /tikz/foo |
    | [/quux/foo] | /quux/foo |

  Examples: /tikz/* keys maintain precedence
    | keylists                | string    |
    | [foo][/ektropi/restore] | /tikz/foo |
    | [/ektropi/restore][foo] | /tikz/foo |
