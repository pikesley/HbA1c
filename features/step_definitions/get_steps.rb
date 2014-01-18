Given(/^there is a metric in the database with the name "(.*?)"$/) do |name|
  @metric = Metric.create(name: name)
end

Given(/^it has a time of "(.*?)"$/) do |time|
  @metric.time = time
  @metric.save
end

Given(/^it has a value of:$/) do |value|
  @metric.value = value.include?('{') ? JSON.parse(value) : value.to_i
  @metric.save
end

Given(/^it has a category of "(.*?)"$/) do |category|
  @metric.category = category
  @metric.save
end

Given(/^it has a subtype of "(.*?)"$/) do |subtype|
  @metric.subtype = subtype
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

Then(/^the JSON response should have "(.*?)" with the text:$/) do |arg1, string|
  pending # express the regexp above with the code you wish you had
end