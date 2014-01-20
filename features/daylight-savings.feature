Feature: bloody BST

  Background:
    Given I send and accept JSON
    And I authenticate as the user "sam" with the password "insulin"
    And I send a POST request to "metrics/lantus" with the following:
    """
{
  "datetime": "2013-10-27T01:43:00+01:00",
  "category": "Bedtime",
  "value": "15.0"
}
    """
    And I send a POST request to "metrics/lantus" with the following:
    """
{
  "datetime": "2013-10-27T01:43:00+01:00",
  "category": "Bedtime",
  "value": "15.0"
}
    """

  Scenario: Should return a single value
    When I send a GET request to "metrics/lantus/*/*"
    Then the response status should be "200"
#    And the JSON response should have "$.count" with the text "1"
    And the JSON response should have "$.values[0].value" with the text "15.0"
    And the JSON response should have "$.values[0].datetime" with the text "2013-10-27T01:43:00+01:00"