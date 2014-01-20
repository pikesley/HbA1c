Feature: Error handling

  Background:
    Given I send and accept JSON  
    
  Scenario: GETing data for a single date
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/wtf"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'wtf' is not a valid ISO8601 date/time."
    
  Scenario: GETing a range with invalid from date
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/wtf/2013-01-01"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'wtf' is not a valid ISO8601 date/time."
    
  Scenario: GETing a range with invalid to date
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/2013-01-01/wtf"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'wtf' is not a valid ISO8601 date/time."
    
  Scenario: GETing a range with two invalid dates
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/wtf/bbq"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'wtf' is not a valid ISO8601 date/time. 'bbq' is not a valid ISO8601 date/time."
    
  Scenario: GETing a range with from date after to date
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/2013-02-02/2013-01-01"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'from' date must be before 'to' date."
    
  Scenario: GETing a range with invalid from duration
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/P24H/2013-01-01"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'P24H' is not a valid ISO8601 duration."
  
  Scenario: GETing a range with invalid to duration
    Given I authenticate as the user "sam" with the password "insulin"
    When I send a GET request to "metrics/membership-coverage/2013-01-01/P24H"
    Then the response status should be "400"
    Then the JSON response should have "$.status" with the text "'P24H' is not a valid ISO8601 duration."
    
  Scenario: POSTing data with incorrect credentials
    When I authenticate as the user "fake" with the password "password"
    And I send a POST request to "metrics/membership-coverage"
    Then the response status should be "401"
  