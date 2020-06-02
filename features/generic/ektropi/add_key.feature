# features/ektropi/add_key.feature
Feature: ektropi add key adds deviations to handler

  Background: testing ektropi in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.ektropi" TikZ library

  Scenario Outline: adding a simple deviation
    Given the body is
    """
    \pgfkeys{
      /foo/bar/.code={#1},
      /ektropi/add=/foo
    }
    \tikz<keylist>;
    """
    Then compilation <outcome>
    And the log matches <regexp>

    Examples: test key work as expected
      | keylist      | outcome  | regexp                                |
      | [bar=\relax] | succeeds |                                       |
      | [bar=\HALT]  | fails    | Undefined control sequence.*\n.*\HALT |

  Scenario Outline: using deviations in a series of keylists
    Given the body is
    """
    \pgfkeys{/foo/bar/.code={}}
    \tikz<keylists>;
    """
    Then compilation <outcome>
    And the log matches <regexp>

    Examples: key is found at any point after the call
      | keylists                 | outcome  | regexp                            |
      | [bar][/ektropi/add=/foo] | fails    | I do not know the key '/tikz/bar' |
      | [bar, /ektropi/add=/foo] | fails    | I do not know the key '/tikz/bar' |
      | [/ektropi/add=/foo, bar] | succeeds |                                   |
      | [/ektropi/add=/foo][bar] | succeeds |                                   |

  Scenario Outline: using multiple deviations
    Given the body is
    """
    \pgfkeys{
      /foo/bar/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
      /foo/baz/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
      /qux/baz/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}}
    }
    \tikz<keylist>;
    """
    Then compilation succeeds
    And the log matches <regexp>

    Examples: test keys logging works as expected
      | keylist    | regexp           |
      | [/foo/bar] | path: '/foo/bar' |
      | [/foo/baz] | path: '/foo/baz' |
      | [/qux/baz] | path: '/qux/baz' |

    Examples: previous deviations are preserved
      | keylist                                       | regexp           |
      | [/ektropi/.cd, add=/foo, add=/qux, /tikz/bar] | path: '/foo/bar' |

    Examples: latest deviations have higher precedence
      | keylist                                       | regexp           |
      | [/ektropi/.cd, add=/foo, add=/qux, /tikz/baz] | path: '/qux/baz' |
      | [/ektropi/.cd, add=/qux, add=/foo, /tikz/baz] | path: '/foo/baz' |

  Scenario Outline: naming conflict with a /tikz/* key
    Given the body is
    """
    \pgfkeys{
      /tikz/foo/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
      /quux/foo/.ecode={\noexpand\message{path: '\pgfkeyscurrentpath'}},
    }
    \tikz<keylist>;
    """
    Then compilation succeeds
    And the log includes <string>

    Examples: test keys logging works as expected
      | keylist     | string            |
      | [/tikz/foo] | path: '/tikz/foo' |
      | [/quux/foo] | path: '/quux/foo' |

    Examples: /tikz/* keys always maintain precedence
      | keylist                   | string            |
      | [/ektropi/add=/quux, foo] | path: '/tikz/foo' |
