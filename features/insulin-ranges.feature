Feature: Diabetes time ranges

  Background:
    Given I send and accept JSON
    And there is a metric in the database with the name "medication"
    And it has a datetime of "2014-01-14T12:25:30+00:00"
    And it has a value of "7.5"
    And there is a metric in the database with the name "medication"
    And it has a datetime of "2014-01-14T18:47:19+00:00"
    And it has a value of "6.0"
    And there is a metric in the database with the name "medication"
    And it has a datetime of "2014-01-15T07:24:04+00:00"
    And it has a value of "4.0"
    And there is a metric in the database with the name "medication"
    And it has a datetime of "2014-01-15T12:50:38+00:00"
    And it has a value of "5.0"