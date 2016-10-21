require 'selenium-webdriver'
require 'securerandom'

$driver
$wait
$testString = 'This is an automated test note.'
$testTransferReasonString = 'This is an automated test transfer summary'

$testChecklistCaseNumber
$testApplicationName
$testChecklistCaseNumberEdited
$waitTimeout = 15; # seconds
$testUserName = "selenium"
$testUserPassword = "selenium"

# row for each case of 'doneness'
$donenessCriteriaRow
$donenessCriteriaRowIndex

# pass in a custom URL from the command line with: cucumber URL="[url to test on]" and/or DELETE_URL="[url for deleting case]"
$defaultUrl = "http://dev-cbd.agiletrailblazers.com/CreditBureauDispute_/index.html#/Login"
#$defaultUrl = "http://wavemaker.agiletrailblazers.com/run-t3t2b1yfst/CreditBureauDispute_/#/Login"
$deleteUrl = "http://dev-cbd.agiletrailblazers.com/CBD_AutomatedTestUtl/#/Main"

Before do |scenario|
  $driver = Selenium::WebDriver.for :firefox
  $wait = Selenium::WebDriver::Wait.new(:timeout => $waitTimeout)
  $driver.manage.timeouts.implicit_wait = $waitTimeout
  $driver.manage.window.resize_to(1024, 768)

  # create a UUID to use for the new case and app name
  $uuid = SecureRandom.uuid;
  $testChecklistCaseNumber = "test-case-" + $uuid;
  $testApplicationName = "test-app-" + $uuid;
  $testChecklistCaseNumberEdited = ''

  $donenessCriteriaRow = nil;
  $donenessCriteriaRowIndex = nil;
end

After do |scenario|
  # clean-up test data by deleting the checklist
  # configure from command line
  if ENV['DELETE_URL'].to_s.length != 0
    $driver.navigate.to ENV['DELETE_URL']
  else
    $driver.navigate.to $deleteUrl
  end

  # delete the case checklist created for the test scenario
  caseNumberToDeleteText =    $wait.until { $driver.find_element(:name,'caseNumberToDelete_formWidget') };
  caseNumberToDeleteText.clear();
  caseNumberToDeleteText.send_keys($testChecklistCaseNumber);
  deleteCaseButton = $driver.find_element(:name,'deleteCaseButton');
  deleteCaseButton.click();

  if $testChecklistCaseNumberEdited.length != 0 # not utilized in test, no need to delete otherwise
    # delete the extra case checklist created for duplicate ID test scenario
    caseNumberToDeleteText = $driver.find_element(:name,'caseNumberToDelete_formWidget');
    caseNumberToDeleteText.clear();
    caseNumberToDeleteText.send_keys($testChecklistCaseNumberEdited);
    deleteCaseButton = $driver.find_element(:name,'deleteCaseButton');
    deleteCaseButton.click();
  end

  $driver.quit
end

Given(/^the user navigates to the Credit Dispute Resolution application$/) do
  # configure from command line
  if ENV['URL'].to_s.length != 0
    $driver.navigate.to ENV['URL']
  else
    $driver.navigate.to $defaultUrl
  end
end

When(/^the user logs into the application$/) do
  usernameElement = $wait.until {$driver.find_element(:name, 'usernametext')}
  $wait.until { usernameElement.displayed? }
  usernameElement.send_keys($testUserName)
  $driver.find_element(:name, 'passwordtext').send_keys($testUserPassword)
  $driver.find_element(:name, 'loginButton').click();
end

Then(/^the user is welcomed on home screen$/) do
  # validate main screen is displaying user's creds. #Thanks Paul. "' + $testUserName+ '"
  $wait.until { $driver.find_element(:xpath, '//div[@class="panel-heading"]//div[text()= "' + $testUserName+ '"]' ).displayed? }
end

Then(/^the user sees the case list$/) do
  # validate main screen is displayed by looking for case accordion
  $wait.until { $driver.find_element(:name, 'caseList') }
end

When(/^the user creates a new checklist$/) do
  newCaseNumberTextField = $wait.until { $driver.find_element(:name, 'newCaseNumber_formWidget') }
  newCaseNumberTextField.clear();
  newCaseNumberTextField.send_keys($testChecklistCaseNumber);
  element = $wait.until { $driver.find_element(:name, 'createNewCaseButton') }
  element.click();
end

Then(/^the user sees the new checklist$/) do

    #wait until the rows show up
    $wait.until { $driver.find_elements(:name, 'appNotApplicableToggle') }

    # verify case number
    caseNumber = $driver.find_element(:name, 'caseNumber')
    $wait.until { caseNumber.displayed? }
    expect(caseNumber.text()).to eq($testChecklistCaseNumber)

    # verify status
    caseStatus = $wait.until { $driver.find_element(:name, 'status') }
    expect(caseStatus.text()).to eq("Active")

    # verify that the checklist is in an initialized state (no notes, no images)

    # verify all the image counts are 0
    imageCounts = $driver.find_elements(:name, 'imagesLabelsContainer')
    imageCounts.each do |imageCount|
      if(imageCount.displayed?)
        expect(imageCount.text()).to include("0")
      end
    end

    # verify all the note counts are 0
    noteCounts = $driver.find_elements(:name, 'noteCountLabel')
    noteCounts.each do |noteCount|
      if(noteCount.displayed?)
        expect(noteCount.text()).to include("0")
      end

    end

    # verify no case note
    caseNote = $wait.until { $driver.find_element(:id, 'case-notes') }
    expect(caseNote.attribute('value')).to eq("");
end

When(/^the user opens the checklist$/) do
  newCaseNumberTextField = $driver.find_element(:name, 'newCaseNumber_formWidget')
  $wait.until { newCaseNumberTextField.displayed? }
  newCaseNumberTextField.clear();
  newCaseNumberTextField.send_keys($testChecklistCaseNumber);
  element = $wait.until { $driver.find_element(:name, 'createNewCaseButton') }
  element.click();
  # verify status
  caseStatus = $driver.find_element(:name, 'status')
  $wait.until { caseStatus.displayed? }
  expect(caseStatus.text()).to eq("Active");
end

When(/^the user adds text to the Case Notes field$/) do
  notefield = $wait.until { $driver.find_element(:id, 'case-notes') }
  notefield.clear();
  notefield.send_keys($testString);
  # click onto the case number to trigger onBlur
  $wait.until { $driver.find_element(:name, 'caseNumber') }.click();
end

Then(/^the user sees the case note$/) do
  notefield =  $driver.find_element(:id, 'case-notes')
  $wait.until {notefield.displayed?}
  expect(notefield.attribute('value')).to eq($testString);
end

When(/^the user adds text to the Application Notes field$/) do
  # get the list of rows
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  $donenessCriteriaRowIndex = 0

  appnotefield = $wait.until { applicationRows[$donenessCriteriaRowIndex].find_element(:xpath, "//textarea[@name='caseAppNote']") }
  appnotefield.clear();
  appnotefield.send_keys($testString);
  # tab to next field to trigger blur event
  $driver.action.send_keys(appnotefield, :tab)
end

Then(/^the application is marked as done$/) do
  # get the list of rows
  sleep(1);
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  # get the specific row whose doneness is being checked
  $wait.until { applicationRows[$donenessCriteriaRowIndex].find_element(:name, 'checkMarkDoneIcon') }
end

Then(/^the application is marked as not done$/) do
  # get the list of rows
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  # get the specific row whose doneness is being checked
  $wait.until { applicationRows[$donenessCriteriaRowIndex].find_element(:name, 'checkMarkNotDoneIcon') }
end

And(/^the application note count is 1$/) do
  sleep(1) #Try commenting out, replaced by displayed?
  # get the relevant application rows
  applicationRow = $driver.find_elements(:xpath => "//div[@name='appRow']")[$donenessCriteriaRowIndex]
  $wait.until { applicationRow.displayed? }
  # get the specific row whose note count is being checked
  noteCount = applicationRow.find_element(:name, 'noteCountLabel')
  expect(noteCount.text()).to include("1")
end

And(/^the user clicks the save for later button$/) do
  element = $wait.until { $driver.find_element(:id, 'saveForLaterButton') }
  element.click();
end

Then(/^the user sees the Save for Later form$/) do
  $wait.until { $driver.find_element(:name, 'saveForLaterReason') }
end

When(/^the user enters a summary into the Save for Later form$/) do
  saveForLaterInput = $wait.until { $driver.find_element(:name, 'saveForLaterReason_formWidget') }
  saveForLaterInput.clear();
  saveForLaterInput.send_keys("this is an automated test save for later summary");
end

When(/^the user clicks the submit button on the Save for Later form$/) do
  saveForLaterSubmit = $wait.until { $driver.find_element(:name, 'saveForLaterSaveBtn') }
  saveForLaterSubmit.click();
end

When(/^the user clicks the submit button on the Save for Later form multistep$/) do
  saveForLaterSubmit = $wait.until { $driver.find_element(:name, 'saveForLaterSaveBtn') }
  saveForLaterSubmit.click();
end

Then(/^the checklist is marked as saved on the case page$/) do
  # xpath to select a list item that contains the case number and a status of 'saved'
  checklistRow = $wait.until {
    $driver.find_element(:xpath,
    '//li[//label[text()[contains(.,"' + $testChecklistCaseNumber+ '")]] and //label[text()[contains(.,"Saved")]]]')
  }
end

Then(/^the checklist is marked as transferred on the case page$/) do
  # xpath to select a list item that contains the case number and a status of 'Transferred'
  checklistRow = $wait.until {
    $driver.find_element(:xpath,
    '//li[//label[text()[contains(.,"' + $testChecklistCaseNumber+ '")]] and //label[text()[contains(.,"Transferred")]]]')
  }
end

Then(/^the checklist is marked as closed on the case page$/) do
  # xpath to select a list item that contains the case number and a status of 'Closed'
  checklistRow= $driver.find_element(:xpath,
    '//li[//label[text()[contains(.,"' + $testChecklistCaseNumber+ '")]] and //label[text()[contains(.,"Closed")]]]');
  $wait.until {checklistRow.displayed?}
end

Then(/^the user sees the Case History has been updated by the save$/) do
  caseHistoryRowOne =  $driver.find_element(:xpath, "//*[@data-row-id='0']")
  $wait.until {caseHistoryRowOne.displayed?}
  expect(caseHistoryRowOne.text).to include($testUserName +" Active Case opened");

  caseHistoryRowTwo = $driver.find_element(:xpath, "//*[@data-row-id='1']")
  $wait.until {caseHistoryRowTwo.displayed?}
  expect(caseHistoryRowTwo.text).to include($testUserName +" Saved this is an automated test save for later summary");
end

Then(/^the user sees the Case History has been updated by the transfer$/) do
  caseHistoryRowOne = $driver.find_element(:xpath, "//*[@data-row-id='0']")
  $wait.until { caseHistoryRowOne.displayed? }
  expect(caseHistoryRowOne.text).to include($testUserName +" Active Case opened");

  caseHistoryRowTwo = $driver.find_element(:xpath, "//*[@data-row-id='1']")
  $wait.until { caseHistoryRowTwo.displayed? }
  expect(caseHistoryRowTwo.text).to include($testUserName + " Transferred " + $testTransferReasonString);
end

Then(/^the user sees the Case History has been updated by the close$/) do
  caseHistoryRowOne =  $driver.find_element(:xpath, "//*[@data-row-id='0']")
  $wait.until {caseHistoryRowOne.displayed?}
  expect(caseHistoryRowOne.text).to include($testUserName + " Active Case opened");

  caseHistoryRowTwo = $driver.find_element(:xpath, "//*[@data-row-id='1']")
  $wait.until {caseHistoryRowTwo.displayed? }
  expect(caseHistoryRowTwo.text).to include($testUserName + " Closed");
end

When(/^the user marks a row as Not Applicable$/) do
  checklistRowOne = $wait.until { $driver.find_element(:name, "appRow") }
  # verify comment, not-done checkmark and image attachment fields are present in the row
  caseAppNote = $wait.until { checklistRowOne.find_element(:name, "caseAppNote") }
  expect(caseAppNote.displayed?).to be true

  pasteTarget = $wait.until { checklistRowOne.find_element(:name, "pasteTarget") }
  expect(pasteTarget.displayed?).to be true

  checkmarkNoteDoneIcon = $wait.until { checklistRowOne.find_element(:name, "checkMarkNotDoneIcon") }
  expect(checkmarkNoteDoneIcon.displayed?).to be true

  notApplicableToggle = $wait.until { checklistRowOne.find_element(:name, "appNotApplicableToggle") }
  notApplicableToggle.click()
end

Then(/^the notes field and paste section for the row are hidden$/) do
  # this step assumes the row has been marked as N/A
  checklistRowOne = $wait.until { $driver.find_element(:name, "appRow") }

  # wait until the app note is hidden to continue - this is needed as the click event on the toggle is slow
  $wait.until { !checklistRowOne.find_element(:name, "caseAppNote").displayed? }

  # verify that elemenents in the row are not displayed
  caseAppNote = $wait.until { checklistRowOne.find_element(:name, "caseAppNote") }
  expect(caseAppNote.displayed?).to be false

  checkmarkNoteDoneIcon = $wait.until { checklistRowOne.find_element(:name, "checkMarkNotDoneIcon") }
  expect(checkmarkNoteDoneIcon.displayed?).to be false

  pasteTarget = $wait.until { checklistRowOne.find_element(:name, "pasteTarget") }
  expect(pasteTarget.displayed?).to be false
end

When(/^the user marks all rows as not Applicable$/) do
  # get the initial list of rows so that we have the total count
  toggles = $wait.until { $driver.find_elements(:xpath => "//div[@name='cardCbdTab']//input[@name='appNotApplicableToggle']") }
  rowCount = toggles.count

  for i in 0..(rowCount - 1) do
    rowToToggle = toggles[i]
    rowToToggle.click();
    # the data that drives the state of each row needs to refresh after each row is updated,
    # re-find the elements so that we have the dom with the updated state(i.e. state)
    toggles = $wait.until { $driver.find_elements(:xpath => "//div[@name='cardCbdTab']//input[@name='appNotApplicableToggle']") }
  end
end

And(/^the user clicks the transfer button$/) do
  transferButton = $wait.until { $driver.find_element(:name, "transferButton") }
  transferButton.click();
end

Then(/^the user sees the transfer form$/) do
  transferForm = $wait.until { $driver.find_element(:name, 'transferReason') }
  $wait.until {transferForm.displayed?}
  expect(transferForm.displayed?).to be true
end

Then(/^the user enters a summary into the Transfer form/) do
  transferInput = $wait.until { $driver.find_element(:name, 'transferReason_formWidget') }
  transferInput.clear();
  transferInput.send_keys($testTransferReasonString);
end

When(/^the user clicks the submit button on the Transfer form$/) do
  transferSaveButton = $wait.until { $driver.find_element(:name, "transferSaveButton") }
  transferSaveButton.click();
end

Then(/^an incomplete checklist close error is displayed$/) do
  $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope'][text()= 'You must complete all checklist rows and enter a case note to close a case']" ).displayed? }
  $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope']" ) }.click();
end

Then(/^the user sees a case note save success$/) do
  $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope'][text()= 'Case note has been saved successfully']" )}.click()
end

Then(/^the user sees the update case number success$/) do
  $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope'][text()= 'The case number has successfully been updated.']" ).displayed? }
  $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope']").click()
end


Then(/^an incomplete checklist transfer error is displayed$/) do
  # Get the toast-container and then find the div which holds the message within the container.
  $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope'][text()= 'You must complete all checklist rows to transfer a case']" ).displayed? }
  $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope']").click()
end

Then(/^the user sees the close confirmation$/) do
  # wait until the close confirmation comes up
  $wait.until { $driver.find_element(:name, 'closeConfirmationDialogHeader').displayed? }
end

And(/^the user clicks the close button$/) do
  closeButton = $wait.until { $driver.find_element(:name, 'closeButton') }
  closeButton.click()
end

When(/^the user clicks the confirm button on close confirmation$/) do
  $wait.until { $driver.find_element(:name, 'closeConfirmationDialogHeader') }
  confirmButton = $wait.until { $driver.find_element(:name, 'closeConfirmButton') }
  confirmButton.click()
end

When(/^the user clicks the note count$/) do
  noteCount = $wait.until { $driver.find_elements(:name, 'noteCountLabel')[0] }
  noteCount.click()
end

Then(/^the user sees the note History$/) do
  $wait.until { $driver.find_element(:name, 'noteHistoryDialog') }
end

Then(/^the user sees the application note in the note History$/) do
  notesHistoryDialog = $wait.until { $driver.find_element(:name,'noteHistoryDialog'); }
  $wait.until { notesHistoryDialog.find_element(:xpath, '//td[text()[contains(.,"' + $testString + '")]]') }
  closeButton = $wait.until { notesHistoryDialog.find_element(:tag_name, "button") }
  closeButton.click()
end

When(/^the user adds a note to a row that requires a note only$/) do
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  index = 0

  begin
    # all the rows are already displayed, reduce the wait time while looping through them looking for required row
    $driver.manage.timeouts.implicit_wait = 1

    applicationRows.each do |applicationRow|
      # the data that drives the state of each row needs to refresh after each row is updated,
      # re-find the elements so that we have the dom with the updated state(i.e. state)
      imageRequiredLabel = applicationRow.find_element(:name, 'imageRequiredAsteriskLabel')
      noteRequiredLabel = applicationRow.find_element(:name, 'notesRequiredAsteriskLabel')

      if((imageRequiredLabel.text != '*')&&(noteRequiredLabel.text == '*'))
        $donenessCriteriaRow = applicationRow
        $donenessCriteriaRowIndex = index
        break
      end
      index += 1
    end

    noteField = $donenessCriteriaRow.find_element(:name, 'caseAppNote')
    noteField.send_keys('this is an automated test note')
  ensure
    # restore the origin implicit wait
    $driver.manage.timeouts.implicit_wait = $waitTimeout
  end
  expect($donenessCriteriaRow).to be_truthy
end

When(/^the user adds a note to a row that requires an image only$/) do
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  index = 0

  begin
    # all the rows are already displayed, reduce the wait time while looping through them looking for required row
    $driver.manage.timeouts.implicit_wait = 1

    applicationRows.each do |applicationRow|
      # the data that drives the state of each row needs to refresh after each row is updated,
      # re-find the elements so that we have the dom with the updated state(i.e. state)
      imageRequiredLabel = applicationRow.find_element(:name, 'imageRequiredAsteriskLabel')
      noteRequiredLabel = applicationRow.find_element(:name, 'notesRequiredAsteriskLabel')

      if((imageRequiredLabel.text == '*')&&(noteRequiredLabel.text != '*'))
        $donenessCriteriaRow = applicationRow
        $donenessCriteriaRowIndex = index
        break
      end
      index += 1
    end

    noteField = $donenessCriteriaRow.find_element(:name, 'caseAppNote')
    noteField.send_keys('this is an automated test note')
  ensure
    # restore the origin implicit wait
    $driver.manage.timeouts.implicit_wait = $waitTimeout
  end
  expect($donenessCriteriaRow).to be_truthy
end

When(/^the user adds a note to a row that requires a note and image only$/) do
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  index = 0;

  begin
    # all the rows are already displayed, reduce the wait time while looping through them looking for required row
    $driver.manage.timeouts.implicit_wait = 1

    applicationRows.each do |applicationRow|
      # the data that drives the state of each row needs to refresh after each row is updated,
      # re-find the elements so that we have the dom with the updated state(i.e. state)
      imageRequiredLabel = applicationRow.find_element(:name, 'imageRequiredAsteriskLabel')
      noteRequiredLabel = applicationRow.find_element(:name, 'notesRequiredAsteriskLabel')

      if((imageRequiredLabel.text == '*')&&(noteRequiredLabel.text == '*'))
        $donenessCriteriaRow = applicationRow
        $donenessCriteriaRowIndex = index
        break
      end
      index += 1
    end

    noteField = $donenessCriteriaRow.find_element(:name, 'caseAppNote')
    noteField.send_keys('this is an automated test note')
  ensure
    # restore the origin implicit wait
    $driver.manage.timeouts.implicit_wait = $waitTimeout
  end
  expect($donenessCriteriaRow).to be_truthy
end

When(/^the user answers a question by selecting the first answer$/) do
  # get the list of rows
  applicationRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") }
  index = 0
  begin
      # all the rows are already displayed, reduce the wait time while looping through them looking for a question
      $driver.manage.timeouts.implicit_wait = 1
      applicationRows.each do |applicationRow|
        # look for a row that has a question/answers
        begin
          answerCheckbox1 = applicationRow.find_element(:xpath, "//input[@name='answerCheckbox1']")
          answerCheckbox1.click();
          $donenessCriteriaRow = applicationRow
          $donenessCriteriaRowIndex = index
          break
        rescue
          # didn't find a question on this row, continue
          index += 1
        end
      end
  ensure
    # restore the origin implicit wait
    $driver.manage.timeouts.implicit_wait = $waitTimeout
  end
  expect($donenessCriteriaRow).to be_truthy
end

Then(/^the first answer is still selected$/) do

  # get the row that contains the question that was answered
  applicationRow = $wait.until { $driver.find_elements(:xpath => "//div[@name='appRow']") [$donenessCriteriaRowIndex] };
  answerCheckbox1 = $wait.until {applicationRow.find_element(:xpath, "//input[@name='answerCheckbox1']") };
  $wait.until { answerCheckbox1.selected? }
end

Then(/^the user sees the case note in the case note history$/) do
  caseNoteHistoryRowOne = $wait.until { $driver.find_element(:xpath, "//div[@name='caseNoteHistoryGrid']//tr[@data-row-id='0']") }
  $wait.until { caseNoteHistoryRowOne.displayed? }
  expect(caseNoteHistoryRowOne.text).to include($testString);
end

When(/^the user clicks the edit case number icon$/) do
  editIdIcon = $wait.until { $driver.find_element(:name, "editCaseNumberButton") }
  editIdIcon.click()
end

Then(/^the user sees the edit case number form$/) do
  editIdForm = $driver.find_element(:name, "caseNumberHeader")
  $wait.until { editIdForm.displayed? }
end

When(/^the user edits the case number/) do
  editIdField = $wait.until { $driver.find_element(:name, "newCaseNumber_formWidget") }
  $uuid = SecureRandom.uuid;
  $testChecklistCaseNumberEdited = "new-case-id-" + $uuid;
  editIdField.send_keys($testChecklistCaseNumberEdited)
end

When(/^the user clicks the update case number button$/) do
  editIdUpdateButton = $wait.until { $driver.find_element(:name, "updateCaseNumberSaveButton") }
  editIdUpdateButton.click()
end

When(/^the user opens the checklist with the new case number$/) do
  newCaseNumberTextField = $driver.find_element(:name, 'newCaseNumber_formWidget')
  $wait.until { newCaseNumberTextField.displayed? }
  newCaseNumberTextField.clear();
  newCaseNumberTextField.send_keys($testChecklistCaseNumberEdited);
  element = $wait.until { $driver.find_element(:name, 'createNewCaseButton') }
  element.click();
end

Then(/^the user sees the checklist with the new case number$/) do
  caseHistoryRowThree= $driver.find_element(:xpath, "//*[@data-row-id='2']")
  $wait.until {caseHistoryRowThree.displayed? }
  expect(caseHistoryRowThree.text).to include("changed to: '" + $testChecklistCaseNumberEdited);
end

When(/^the user creates a new checklist with a specific case number$/) do
  $uuid = SecureRandom.uuid;
  $testChecklistCaseNumberEdited = "new-case-id-" + $uuid;

  newCaseNumberTextField = $wait.until { $driver.find_element(:name, 'newCaseNumber_formWidget') }
  newCaseNumberTextField.clear();
  newCaseNumberTextField.send_keys($testChecklistCaseNumberEdited);
  element = $wait.until { $driver.find_element(:name, 'createNewCaseButton') }
  element.click();
end

Then(/^the user sees the new checklist with a specific case number$/) do
  # verify case number
  caseNumber =  $driver.find_element(:name, 'caseNumber')
  $wait.until {caseNumber.displayed?}
  expect(caseNumber.text()).to eq($testChecklistCaseNumberEdited)
end

When(/^the user changes the case number to a duplicate$/) do
  editIdField = $wait.until { $driver.find_element(:name, "newCaseNumber_formWidget") }
  editIdField.send_keys($testChecklistCaseNumber)
end

When(/^the user changes the case number to the same case number$/) do
  editIdField = $wait.until { $driver.find_element(:name, "newCaseNumber_formWidget") }
  editIdField.send_keys($testChecklistCaseNumber)
end

When(/^the user clicks the Home button$/) do
  homeButton = $wait.until { $driver.find_element(:name, "homeButton") }
  homeButton.click()
end

Then(/^the user sees the duplicate case number error$/) do
  duplicateCaseNumberError =  $driver.find_element(:xpath, "//p[@ng-class='messageClass']")
  $wait.until {duplicateCaseNumberError.displayed?}
  expect(duplicateCaseNumberError.text()).to include("The case number you entered is already in use. Please try a different case number")
end

Then(/^the user sees the current case number error$/) do
  sameCaseNumberError =$driver.find_element(:xpath, "//p[@ng-class='messageClass']")
  $wait.until { sameCaseNumberError.displayed? }
  expect(sameCaseNumberError.text()).to include("The case number you entered is the current case number. Please try a different case number")
end

When(/^the user clicks the specialty group tab$/) do
  # Selector below finds the inactive tab and will break if there are more than 2 tabs
  specialtyGroup = $wait.until { $driver.find_element(:xpath, "//li[@class='tab-header ng-scope']") }
  specialtyGroup.click()
end

Then(/^the user sees the specialty group checklist$/) do
  #wait until the rows show up

  # verify the row labels labels are not visible
  appLabel = $wait.until { $driver.find_element(:xpath => "//div[@name='specialtyGroupTab']//label[@name='checklistGroupName']") }
  expect(appLabel.displayed?).to eq(true);

  # verify row is in a clean state - the image count is 0
  imageCount = $wait.until { $driver.find_element(:xpath => "//div[@name='specialtyGroupTab']//label[@name='ImageCount']") }
  expect(imageCount.text()).to include("0")

  # verify row is in a clean state - verify the note count is 0
  noteCount = $wait.until { $driver.find_element(:xpath => "//div[@name='specialtyGroupTab']//label[@name='noteCountLabel']") }
  expect(noteCount.text()).to include("0")
end

When(/^the user clicks the add row button$/) do
  addRowButton = $wait.until { $driver.find_element(:xpath => "//div[@name='specialtyGroupTab']//button[@name='addRowButton']") }
  $wait.until { addRowButton.displayed? }
  addRowButton.click();
end

Then(/^the user sees an add row successfully added$/) do
  alertToaster = $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope']") }
  $wait.until { alertToaster.displayed? }
  expect(alertToaster.text).to include("Row added successfully.");
  alertToaster.click();

  appLabels = $wait.until { $driver.find_elements(:xpath => "//div[@name='specialtyGroupTab']//label[@name='checklistGroupName']") }
  specialtyRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='specialtyGroupTab']//div[@name='appRow']") }
  expect(specialtyRows.size). to equal(2);
end

When(/^the user adds a note to each specialty row and each row is marked done$/) do
  specialtyRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='specialtyGroupTab']//div[@name='appRow']") }
  rowCount = specialtyRows.size
  caseNumber  = $wait.until { $driver.find_element(:name, 'caseNumber') }

  for i in 0..(rowCount - 1) do
    specialtyRow = specialtyRows[i]
    noteField = specialtyRow.find_element(:name, 'caseAppNote')
    noteField.send_keys('this is an automated test note')
    caseNumber.click(); #Lose Focus
    $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope'][text()= 'Application note has been saved successfully']" ).displayed? }
    $wait.until { $driver.find_element(:xpath, "//div[@id='toast-container']//div[@class='ng-binding ng-scope']" ) }.click();
    # the data that drives the state of each row needs to refresh after each row is updated,
    # re-find the elements so that we have the dom with the updated state(i.e. state)
    specialtyRows = $wait.until { $driver.find_elements(:xpath => "//div[@name='specialtyGroupTab']//div[@name='appRow']") }
    expect(specialtyRows[i]).to be_truthy
  end
end
