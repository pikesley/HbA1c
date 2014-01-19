Feature: Diaetes metrics

  Background:
    Given I send and accept JSON
  
  Scenario: GET list of all diabetes metrics
    Given there is a metric in the database with the name "glucose"
    And there is a metric in the database with the name "medication"
    When I send a GET request to "metrics"
    Then the response status should be "200"
    And the JSON response should have "$.metrics[0].name" with the text "glucose"
    And the JSON response should have "$.metrics[0].url" with the text "https://example.org/metrics/glucose.json"
    And the JSON response should have "$.metrics[1].name" with the text "medication"
    And the JSON response should have "$.metrics[1].url" with the text "https://example.org/metrics/medication.json"

#  Scenario: POSTing structured data
#    Given I authenticate as the user "foo" with the password "bar"
#    When I send a POST request to "metrics/glucose" with the following:
#      """
#      {
#        "type": "glucose",
#        "datetime": "2014-01-18T07:09:54+00:00",
#        "category": "Breakfast",
#        "value": "6.3"
#      }
#      """
#    Then the response status should be "201"
#    And the data should be stored in the "glucose" metric
#    And the datetime of the stored metric should be "2014-01-18T07:09:54+00:00"
#    And the category of the metric should be "Breakfast"
#    And the value of the metric should be "6.3"
#
#  Scenario: POSTing more structured data
#    Given I authenticate as the user "foo" with the password "bar"
#    When I send a POST request to "metrics/medication" with the following:
#    """
#    {
#      "type": "medication",
#      "datetime": "2014-01-18T07:17:56+00:00",
#      "subtype": "Humalog",
#      "category": "Breakfast",
#      "value": "4.5"
#    }
#    """
#    Then the response status should be "201"
#    And the data should be stored in the "medication" metric
#    And the datetime of the stored metric should be "2014-01-18T07:17:56+00:00"
#    And the subtype of the metric should be "Humalog"
#    And the category of the metric should be "Breakfast"
#    And the value of the metric should be "4.5"
#
#  Scenario: GETing structured data
#    Given there is a metric in the database with the name "glucose"
#    And it has a datetime of "2014-01-18T07:09:54+00:00"
#    And it has a category of "Breakfast"
#    And it has a value of "6.3"
#    And there is a metric in the database with the name "medication"
#    And it has a datetime of "2014-01-18T07:17:56+00:00"
#    And it has a subtype of "Humalog"
#    And it has a category of "Breakfast"
#    And it has a value of "4.5"
#    When I send a GET request to "metrics/glucose"
#    Then the response status should be "200"
#    And the JSON response should have "$.datetime" with the text "2014-01-18T07:09:54+00:00"
#    And the JSON response should have "$.category" with the text "Breakfast"
#    And the JSON response should have "$.value" with the text "6.3"
#    When I send a GET request to "metrics/medication"
#    Then the response status should be "200"
#    And the JSON response should have "$.datetime" with the text "2014-01-18T07:17:56+00:00"
#    And the JSON response should have "$.category" with the text "Breakfast"
#    And the JSON response should have "$.subtype" with the text "Humalog"
#    And the JSON response should have "$.value" with the text "4.5"
#
#  Scenario: GETing data for a single datetime
#    Given there is a metric in the database with the name "glucose"
#    And it has a datetime of "2014-01-17T19:09:07+00:00"
#    And it has a value of "6.8"
#    And there is a metric in the database with the name "glucose"
#    And it has a datetime of "2014-01-16T23:29:09+00:00"
#    And it has a value of "5.5"
#    And there is a metric in the database with the name "glucose"
#    And it has a datetime of "2014-01-15T17:40:30+00:00"
#    And it has a value of "4.8"
#    When I send a GET request to "metrics/glucose/2014-01-16T23:29:09+00:00"
#    Then the response status should be "200"
#    And the JSON response should have "$.datetime" with the text "2014-01-16T23:29:09+00:00"
#    And the JSON response should have "$.value" with the text "5.5"