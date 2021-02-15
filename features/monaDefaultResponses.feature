Feature: I check the Mona backend API to match the snapshots

  Simple API requests, validate that the responses match the existing snapshots

  
  Scenario: I check the endpoints against snapshots
    Given I get an auth token
    Then I check the museums endpoint
    Then I check the search options endpoint
    Then I check the artworks endpoint
    Then I check the constituents endpoint
