Feature: Hear Shout

  Shouts have a range up to 1000m

  Scenario: In range shout is heard
    Given Lucy is at 0, 0
    And Sean is at 0, 900
    When Sean shouts
    Then Lucy should hear Sean

  # Rule: One Rule to rule them all, One Rule to find them, One Rule to bring them all, and in the darkness bind them.

    Scenario: Out of range shout may not be heard
      Given Lucy is at 0, 0
      And Sean is at 800, 800
      When Sean shouts
      Then Lucy should hear nothing
