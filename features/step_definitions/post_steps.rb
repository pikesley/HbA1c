Then(/^the data should be stored in the "(.*?)" metric$/) do |metric_name|
  @metric = Metric.where(name: metric_name).last
  @metric.name.should == metric_name
end

Then(/^the time of the stored metric should be "(.*?)"$/) do |time|
  @metric.time.should == DateTime.parse(time)
end

Then(/^the value of the metric should be:$/) do |string|
  @metric.value.to_json.should == string
end

Then(/^the content of the metric should be:$/) do |string|
  @metric.content.to_json.should == string
end

Then(/^the datetime of the stored metric should be "(.*?)"$/) do |time|
  @metric.datetime.should == DateTime.parse(time)
end

Then(/^the category of the metric should be "(.*?)"$/) do |category|
  @metric.category.should == category
end

Then(/^the value of the metric should be "(.*?)"$/) do |value|
  @metric.value.to_s.should == value
end

Then(/^the subtype of the metric should be "(.*?)"$/) do |subtype|
  @metric.subtype.should == subtype
end