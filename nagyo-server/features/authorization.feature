Feature: Authorization

  Scenario: Allow anyone to show

    User login should not be required for simple show and index actions and the 
    main rails_admin dashboard.

    Given I navigate to dashboard
    Then the response should be OK

  Scenario: Require login for edits, updates

    User login required for creating new records and editing existing records.

    Given I navigate to new contact page
    Then the response should be Authorization Required


