Then(/^the data should be stored in the "(.*?)" metric$/) do |metric_name|
  @metric = Metric.where(name: metric_name).last
  @metric.name.should == metric_name
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
