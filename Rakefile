require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "features --format pretty"
end

Cucumber::Rake::Task.new(:cucumber_ci) do |t|
  t.cucumber_opts = "features --format pretty  --format json --out cucumber.json"
end

Cucumber::Rake::Task.new(:cucumber_ci_env_test) do |t|
  t.cucumber_opts = "features --format pretty  --format json --out cucumber.json URL='http://test-cbd.agiletrailblazers.com/CreditBureauDispute_/index.html#/Login'"
end

Cucumber::Rake::Task.new(:cucumber_ci_env_dev) do |t|
  t.cucumber_opts = "features --format pretty  --format json --out cucumber.json URL='http://dev-cbd.agiletrailblazers.com/CreditBureauDispute_/index.html#/Login'"
end
