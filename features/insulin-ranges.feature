Feature: Diabetes time ranges

  Background:
    Given I send and accept JSON
    And there is a metric in the database with the name "humalog"
    And it has a datetime of "2014-01-14T12:25:30+00:00"
    And it has a category of "Lunch"
    And it has a value of "7.5"
    And there is a metric in the database with the name "humalog"
    And it has a datetime of "2014-01-14T18:47:19+00:00"
    And it has a category of "Dinner"
    And it has a value of "6.0"
    And there is a metric in the database with the name "humalog"
    And it has a datetime of "2014-01-15T07:24:04+00:00"
    And it has a category of "Breakfast"
    And it has a value of "4.0"
    And there is a metric in the database with the name "humalog"
    And it has a datetime of "2014-01-15T12:50:38+00:00"
    And it has a category of "Lunch"
    And it has a value of "5.0"

  Scenario: From specific time to specific time
    When I send a GET request to "metrics/humalog/2014-01-14T00:00:00+00:00/2014-01-15T00:00:00+00:00"
    Then the response status should be "200"
    And the JSON response should have "$.count" with the text "2"
