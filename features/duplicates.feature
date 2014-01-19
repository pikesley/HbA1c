Feature: Handle duplicate entries with Last-Write-Wins

  Background:
    Given I send and accept JSON
    And I authenticate as the user "sam" with the password "insulin"
    When I send a POST request to "metrics/lantus" with the following:
    """
{
  "datetime": "2014-01-16T23:49:24+00:00",
  "category": "Bedtime",
  "value": "9.0"
}
    """

    And I send a POST request to "metrics/lantus" with the following:
    """
{
  "datetime": "2014-01-16T23:49:24+00:00",
  "category": "Bedtime",
  "value": "14.0"
}
    """

    And I send a POST request to "metrics/lantus" with the following:
    """
{
  "datetime": "2014-01-16T23:49:24+00:00",
  "category": "Bedtime",
  "value": "11.0"
}
    """

  Scenario: Should return the last value
    When I send a GET request to "metrics/lantus/2014-01-16T23:49:23+00:00/2014-01-16T23:49:25+00:00"
    Then the response status should be "200"
    And the JSON response should have "$.count" with the text "1"