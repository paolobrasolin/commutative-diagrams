# features/ektropi/add.feature
Feature: ektropi can add deviations

  Background: testing ektropi in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "kodi.ektropi" TikZ library
    And I use the "kodi.koinos" TikZ library
    And I want a debugging dump

  Scenario Outline: adding a simple deviation
    Given the body is
    """
    \pgfkeys{
      /foo/bar/.code={}
    }
    \tikz\node<keylists>{};
    """
    Then compilation <outcome>

  Examples: test key work as expected
    | keylists    | outcome  |
    | [/foo/bar]  | succeeds |

  Examples: key is found at any point after the call
    | keylists                 | outcome  |
    | [bar][/ektropi/add=/foo] | fails    |
    | [bar, /ektropi/add=/foo] | fails    |
    | [/ektropi/add=/foo, bar] | succeeds |
    | [/ektropi/add=/foo][bar] | succeeds |

  Scenario Outline: adding multiple deviations
    Given the body is
    """
    \pgfkeys{
      /foo/bar/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
      /foo/baz/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
      /qux/baz/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}}
    }
    \tikz\node<keylists>{};
    """
    Then compilation succeeds
    And the dumped "path" is "<path>"

  Examples: test keys work as expected
    | keylists   | path     |
    | [/foo/bar] | /foo/bar |
    | [/foo/baz] | /foo/baz |
    | [/qux/baz] | /qux/baz |

  Examples: previous deviations are preserved
    | keylists                                | path     |
    | [/ektropi/.cd, add=/foo, add=/qux][bar] | /foo/bar |

  Examples: latest deviations have higher precedence
    | keylists                                | path     |
    | [/ektropi/.cd, add=/foo, add=/qux][baz] | /qux/baz |
    | [/ektropi/.cd, add=/qux, add=/foo][baz] | /foo/baz |

  Scenario Outline: there is a naming conflict
    Given the body is
    """
    \pgfkeys{
      /tikz/foo/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
      /quux/foo/.ecode={\noexpand\kDDump{path: '\pgfkeyscurrentpath'}},
    }
    \tikz\node<keylists>{};
    """
    Then compilation succeeds
    And the dumped "path" is "<path>"

  Examples: test keys work as expected
    | keylists    | path      |
    | [/tikz/foo] | /tikz/foo |
    | [/quux/foo] | /quux/foo |

  Examples: /tikz/* keys maintain precedence
    | keylists                  | path      |
    | [/ektropi/add=/quux, foo] | /tikz/foo |
