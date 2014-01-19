Given(/^there is a metric in the database with the name "(.*?)"$/) do |name|
  @metric = Metric.create(name: name)
end

Given(/^it has a category of "(.*?)"$/) do |category|
  @metric.category = category
  @metric.save
end

Given(/^it has a value of "(.*?)"$/) do |value|
  @metric.value = value
  @metric.save
end

Given(/^it has a datetime of "(.*?)"$/) do |datetime|
  @metric.datetime = datetime
  @metric.save
end
