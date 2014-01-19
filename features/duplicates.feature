Feature: Handle duplicate entries with Last-Write-Wins
  Background:
    Given I send and accept JSON
    And there is a metric in the database with the name "lantus"
    And it has a datetime of "2014-01-16T23:49:24+00:00"
    And it has a category of "Bedtime"
    And it has a value of "9.0"
    And there is a metric in the database with the name "lantus"
    And it has a datetime of "2014-01-16T23:49:24+00:00"
    And it has a category of "Bedtime"
    And it has a value of "15.0"
    And there is a metric in the database with the name "lantus"
    And it has a datetime of "2014-01-16T23:49:24+00:00"
    And it has a category of "Bedtime"
    And it has a value of "11.0"

  Scenario: Should return the last value
    When I send a GET request to "metrics/lantus/2014-01-16T23:49:23+00:00/2014-01-16T23:49:25+00:00"
    Then the response status should be "200"
    And the JSON response should have "$.count" with the text "1"