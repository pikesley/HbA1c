Feature: Handle duplicate entries

  Background:
    Given I send and accept JSON
    And there is a metric in the database with the name "lantus"
    And it has a datetime of "2014-01-16T23:49:24+00:00"
    And it has a category of "Bedtime"
    And it has a value of "11.0"