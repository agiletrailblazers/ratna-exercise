# Wavemaker Cucumber UI Tests and DDL

## Languages and Technologies
* Ruby (or Java)
* Selenium
* Cucumber/Gherkin
* Text Editor or IDE (SublimeText, Atom, Notepad++, Eclipse, IntelliJ)
* Firefox

## Browser Setup
Install Firefox version 45.0: [Firefox 45 Installations](https://ftp.mozilla.org/pub/firefox/releases/45.0/)

Note: Later versions of Firefox may not support Selenium.

## Installing Ruby & Cucumber
### Mac OSX
`$> brew install ruby`

`$> gem install bundler`

`$> sudo gem install selenium-webdriver`

`$> gem install cucumber`

`$> gem install rspec`

### Windows
Follow the instructions listed here: [Ruby Installer](http://rubyinstaller.org/)

## Running The Tests
CD into ATDD-tests directory then execute:
`$> cucumber`

## Configuring The URL
You can configure what URL the tests run on via the command line with the following command:

`cucumber URL="[url to test on]"`

The tests default to the dev URL: http://ec2-54-174-7-191.compute-1.amazonaws.com:8080/CreditBureauDispute_/#/Login

## Running specific test scenario
You can run an individual test scenario from the command line:

`cucumber features --name "[name of feature to run]"`

## Test Teardown
At the beginning of each scenario, the tests create a new checklist. At the end of each scenario, the tests navigate to a separate WM app to delete the checklist. The URL to this separate checklist deletion map can be configured similarly:

`cucumber DELETE_URL="[]"`

The tests default to: http://dev-cbd.agiletrailblazers.com/CBD_AutomatedTestUtl/#/Main
