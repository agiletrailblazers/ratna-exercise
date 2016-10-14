Feature: Credit Dispute Capture

Scenario: User adds a case note to a checklist and clicks Save for Later
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds text to the Case Notes field
  And the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  And the user opens the checklist
  Then the user sees the case note in the case note history

Scenario: User adds a note to an application row and clicks Save for Later
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds text to the Application Notes field
  Then the application is marked as done
  When the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  And the user opens the checklist
  Then the application is marked as done
  And the application note count is 1

Scenario: User marks a checklist as saved
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  Then the checklist is marked as saved on the case page
  When the user opens the checklist
  Then the user sees the Case History has been updated by the save

Scenario: User marks a row as Not Applicable
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user marks a row as Not Applicable
  Then the notes field and paste section for the row are hidden

Scenario: User transfers a checklist
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user marks all rows as not Applicable
  And the user adds text to the Case Notes field
  Then the user sees a case note save success
  When the user clicks the transfer button
  Then the user sees the transfer form
  When the user enters a summary into the Transfer form
  And the user clicks the submit button on the Transfer form
  Then the checklist is marked as transferred on the case page
  When the user opens the checklist
  Then the user sees the Case History has been updated by the transfer

Scenario: User closes a checklist
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user marks all rows as not Applicable
  When the user adds text to the Case Notes field
  Then the user sees a case note save success
  When the user clicks the close button
  Then the user sees the close confirmation
  When the user clicks the confirm button on close confirmation
  Then the checklist is marked as closed on the case page
  When the user opens the checklist
  Then the user sees the Case History has been updated by the close

Scenario: User sees an error for transferring an unfinished checklist
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user clicks the transfer button
  Then an incomplete checklist transfer error is displayed

Scenario: User sees an error for closing an unfinished checklist
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user clicks the close button
  Then an incomplete checklist close error is displayed

Scenario: User archives a note for note history
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds text to the Application Notes field
  Then the application is marked as done
  When the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  And the user opens the checklist
  Then the application is marked as done
  And the application note count is 1
  When the user clicks the note count
  Then the user sees the note History
  And the user sees the application note in the note History

Scenario: User marks a note-only row as done by adding a note
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds a note to a row that requires a note only
  Then the application is marked as done

Scenario: User adds a note to an image-only row
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds a note to a row that requires an image only
  Then the application is marked as not done

Scenario: User answers a question row
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user answers a question by selecting the first answer
  Then the application is marked as done

Scenario: Answer to question should persist on checklist when Saved for Later
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user answers a question by selecting the first answer
  And the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  And the user opens the checklist
  Then the first answer is still selected

Scenario: Answer to question should persist on checklist when Transferred
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user answers a question by selecting the first answer
  And the user marks all rows as not Applicable
  And the user adds text to the Case Notes field
  Then the user sees a case note save success
  When the user clicks the transfer button
  Then the user sees the transfer form
  When the user enters a summary into the Transfer form
  And the user clicks the submit button on the Transfer form
  Then the checklist is marked as transferred on the case page
  And the user opens the checklist
  Then the first answer is still selected

Scenario: Answer to question should persist on checklist when Closed
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user adds text to the Case Notes field
  Then the user sees a case note save success
  When the user answers a question by selecting the first answer
  And the user marks all rows as not Applicable
  And the user clicks the close button
  Then the user sees the close confirmation
  When the user clicks the confirm button on close confirmation
  Then the checklist is marked as closed on the case page
  And the user opens the checklist
  Then the first answer is still selected

Scenario: User changes the checklist case number
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user clicks the edit case number icon
  Then the user sees the edit case number form
  When the user edits the case number
  And the user clicks the update case number button
  Then the user sees the update case number success
  And the user clicks the save for later button
  Then the user sees the Save for Later form
  When the user enters a summary into the Save for Later form
  And the user clicks the submit button on the Save for Later form
  Then the user is welcomed on home screen
  When the user opens the checklist with the new case number
  Then the user sees the checklist with the new case number

Scenario: User receives an error message for attempting to change the checklist case number to an existing case number
  Given the user navigates to the Credit Dispute Resolution application
  When the user logs into the application
  Then the user is welcomed on home screen
  When the user creates a new checklist
  Then the user sees the new checklist
  When the user clicks the Home button
  And the user creates a new checklist with a specific case number
  Then the user sees the new checklist with a specific case number
  When the user clicks the edit case number icon
  Then the user sees the edit case number form
  When the user changes the case number to a duplicate
  And the user clicks the update case number button
  Then the user sees the duplicate case number error

  Scenario: User receives an error message for attempting to change the checklist case number to the same case number
    Given the user navigates to the Credit Dispute Resolution application
    When the user logs into the application
    Then the user is welcomed on home screen
    When the user creates a new checklist
    Then the user sees the new checklist
    When the user clicks the edit case number icon
    Then the user sees the edit case number form
    When the user changes the case number to the same case number
    And the user clicks the update case number button
    Then the user sees the current case number error

  Scenario: User closes a checklist on Specialty Group tab
    Given the user navigates to the Credit Dispute Resolution application
    When the user logs into the application
    Then the user is welcomed on home screen
    When the user creates a new checklist
    Then the user sees the new checklist
    When the user clicks the specialty group tab
    Then the user sees the specialty group checklist
    When the user clicks the add row button
    Then the user sees an add row successfully added
    When the user adds a note to each specialty row and each row is marked done
    When the user adds text to the Case Notes field
    Then the user sees a case note save success
    When the user clicks the close button
    Then the user sees the close confirmation
    When the user clicks the confirm button on close confirmation
    Then the checklist is marked as closed on the case page
    When the user opens the checklist
    Then the user sees the Case History has been updated by the close


  Scenario: User transfers a checklist on Specialty Group tab
    Given the user navigates to the Credit Dispute Resolution application
    When the user logs into the application
    Then the user is welcomed on home screen
    When the user creates a new checklist
    Then the user sees the new checklist
    When the user clicks the specialty group tab
    Then the user sees the specialty group checklist
    When the user clicks the add row button
    Then the user sees an add row successfully added
    When the user adds a note to each specialty row and each row is marked done
    When the user clicks the transfer button
    Then the user sees the transfer form
    When the user enters a summary into the Transfer form
    And the user clicks the submit button on the Transfer form
    Then the checklist is marked as transferred on the case page
    When the user opens the checklist
    Then the user sees the Case History has been updated by the transfer
