# features/velos/velos.feature
Feature: velos

  Background: testing ozos in a generic context
    Given I'm using any TeX flavour
    And I use "tikz"
    And I use the "commutative-diagrams.velos" TikZ library

  Scenario Outline: foobar
    Given I want a debugging dump
    And the body is
    """
    \tikzpicture
    \path node (A) {A} node (M N) {M N} node (Z) {Z};
    \kDVelos<code>;
    \endtikzpicture
    """
    Then compilation <outcome>

    Examples:
      | code          | outcome  |
      | « A ["f", red] ["g", blue]["h", white]: [dashed,->] Z»  | succeeds |

    Examples:
      | code          | outcome  |
      | « A -> Z»     | succeeds |
      | « {A} -> Z»   | succeeds |
      | « (A) -> Z»   | succeeds |
      | « M N -> Z»   | fails    |
      | « {M N} -> Z» | succeeds |
      | « (M N) -> Z» | succeeds |

    Examples:
      | code          | outcome  |
      | « A -> Z»     | succeeds |
      | « A -> {Z}»   | succeeds |
      | « A -> (Z)»   | succeeds |
      | « A -> M N»   | fails    |
      | « A -> {M N}» | succeeds |
      | « A -> (M N)» | succeeds |

    Examples:
      | code             | outcome  |
      | « A -> Z»        | succeeds |
      | « A [->] Z»      | succeeds |
      | « A [red, ->] Z» | succeeds |

    Examples:
      | code               | outcome  |
      | « A f:-> Z»        | succeeds |
      | « A {f}:-> Z»      | succeeds |
      | « A "f":-> Z»      | succeeds |
      | « A ["f"]:-> Z»    | succeeds |
      | « A foo:-> Z»      | succeeds |
      | « A {foo}:-> Z»    | succeeds |
      | « A "foo":-> Z»    | succeeds |
      | « A ["foo"]:-> Z»  | succeeds |
      | « A f x:-> Z»      | fails    |
      | « A {f x}:-> Z»    | succeeds |
      | « A "f x":-> Z»    | succeeds |
      | « A ["f x"]:-> Z»  | succeeds |

