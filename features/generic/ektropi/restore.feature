# features/ektropi/restore.feature
Feature: ektropi can restore the original handler

  Background: testing ektropi in a generic context
    Given I'm in a context
    And I use "tikz"
    And I use the "kodi.ektropi" TikZ library
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

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
      /tikz/foo/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
      /quux/foo/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
    }
    \tikz\node[/ektropi/add=/quux]<keylists>{};
    """
    Then compilation succeeds
    And the dumped "path" is "<path>"

  Examples: test keys work as expected
    | keylists    | path      |
    | [/tikz/foo] | /tikz/foo |
    | [/quux/foo] | /quux/foo |

  Examples: /tikz/* keys maintain precedence
    | keylists                | path      |
    | [foo][/ektropi/restore] | /tikz/foo |
    | [/ektropi/restore][foo] | /tikz/foo |
