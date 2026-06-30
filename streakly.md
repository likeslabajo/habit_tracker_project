# User Stories

---

## 1. Login / Registration Page

### Account registration

_As a User, I want to register with my email, username, and password, so that I can create an account and access the habit tracking features._

**Acceptance Criteria:**

Given I have entered my email, username, and password on the registration screen

When I click the Register button

Then a new account is successfully created and I am redirected to the home page

**Priority:** High

**Story Points:** 3

**Notes:**
- Use Firebase Authentication for account creation.

---

### Error feedback on login

_As a User, I want to see error messages when I input wrong credentials, so that I know what went wrong and can correct my input._

**Acceptance Criteria:**

Given I have entered an incorrect email or password on the login screen

When I click the Login button

Then an error message is displayed informing me that my credentials are invalid

**Priority:** Medium

**Story Points:** 2

**Notes:**
- Error message should not reveal which specific field (email or password) is wrong, for security reasons.

---

### Login user

_As a User, I want to log in using my email and password so that I can access my habit tracking data._

**Acceptance Criteria:**

Given I have entered my registered email and password on the login screen

When I click the Login button

Then I am successfully logged into my account and redirected to the home page

**Priority:** High

**Story Points:** 3

**Notes:**
- Use Firebase Authentication for login.

---

## 2. Home Page

### View welcome message

_As a User, I want to see a personalized welcome message with my name on the home page, so that I feel recognized and can confirm I am logged into the correct account._

**Acceptance Criteria:**

Given I am logged into my account

When I navigate to the home page

Then a welcome message is displayed that includes my name (e.g., "Welcome back, [Name]!")

**Priority:** High

**Story Points:** 2

**Notes:**
- Name shown in the welcome message should reflect the display name set in the user's profile.

---

### Display daily habits

_As a User, I want to see my habits to be completed for the day on the home page, so that I can easily monitor and act on my progress._

**Acceptance Criteria:**

Given I am logged into my account and have habits configured

When I navigate to the home page

Then all habits scheduled for today are displayed with their current completion status

**Priority:** High

**Story Points:** 5

**Notes:**
- Habits should be clearly separated into pending and completed states.
- Consider grouping by color.

---

### View completed habits

_As a User, I want to see a section for completed habits on the home page, so that I can track what I have already achieved today._

**Acceptance Criteria:**

Given I am logged into my account and have marked at least one habit as done

When I navigate to the home page

Then completed habits are displayed in a separate section, visually distinguished from pending ones

**Priority:** Medium

**Story Points:** 3

**Notes:**
- Completed habits can be shown with a strikethrough or check mark indicator.

---

## 3. Menu

### Access menu options

_As a User, I want to access a menu with options for configuring my habits, viewing reports, editing my profile, and signing out, so that I can easily navigate to different parts of the app._

**Acceptance Criteria:**

Given I am on the home page

When I click the menu button (hamburger icon)

Then a menu opens displaying options for Habits, Reports, Profile, Notifications, and Sign Out

**Priority:** High

**Story Points:** 2

**Notes:**
- Menu should be accessible from all main screens of the app.

---

### Navigate to profile

_As a User, I want to access my profile page from the menu so that I can view and update my account information._

**Acceptance Criteria:**

Given the menu is open

When I tap the Profile option

Then I am redirected to the Profile page

**Priority:** Medium

**Story Points:** 1

**Notes:**

---

### Navigate to habits page

_As a User, I want to access the habits configuration page from the menu so that I can manage my habits._

**Acceptance Criteria:**

Given the menu is open

When I tap the Habits option

Then I am redirected to the Habits page

**Priority:** Medium

**Story Points:** 1

**Notes:**

---

### Sign out from menu

_As a User, I want to sign out of my account using an option in the menu, so that I can securely log out when I am finished using the app._

**Acceptance Criteria:**

Given the menu is open

When I tap the Sign Out option

Then I am signed out and redirected to the Login page

**Priority:** High

**Story Points:** 1

**Notes:**
- The session should be cleared and the user should not be able to navigate back to the home page using the back button after signing out.

---

## 4. Profile Page

### View profile details

_As a User, I want to view my saved name, username, age, and country on my profile page, so that I can see the details I provided during registration._

**Acceptance Criteria:**

Given I am logged into my account and have navigated to the Profile page

When the Profile page loads

Then my saved Name, Username, Age, and Country are all displayed

**Priority:** High

**Story Points:** 2

**Notes:**

---

### Edit profile details

_As a User, I want to update my name, age, and country on my profile page, so that I can keep my information up to date._

**Acceptance Criteria:**

Given I am on the Profile page

When I click the Edit button

Then the Name, Age, and Country fields become editable input fields

**Priority:** Medium

**Story Points:** 2

**Notes:**
- Username should not be editable after registration.

---

### Save profile details

_As a User, I want the changes I make to my profile to be saved, so that my updated details are stored and reflected throughout the app._

**Acceptance Criteria:**

Given I have edited my Name, Age, or Country on the Profile page

When I click the Save button

Then the updated details are saved and displayed on the Profile page

**Priority:** Medium

**Story Points:** 2

**Notes:**
- Show a success message or toast notification after saving.

---

### Update name in header

_As a User, I want my updated name to be reflected in the app's welcome message immediately after saving, so that my changes are visible right away._

**Acceptance Criteria:**

Given I have updated my name on the Profile page and clicked Save

When I navigate back to the home page

Then the welcome message in the header displays my updated name

**Priority:** Low

**Story Points:** 1

**Notes:**
- Requires reactive state management so the name updates without requiring a full app restart.

---

## 5. Habits Page

### Add a new habit

_As a User, I want to add new habits on the habits page so that I can track them daily._

**Acceptance Criteria:**

Given I am on the Habits page

When I enter a habit name and click the Add button

Then the new habit is saved and appears in the habits list

**Priority:** High

**Story Points:** 3

**Notes:**
- Habit name should be required.
- Optionally allow the user to pick a color at the time of creation.

---

### Delete a habit

_As a User, I want to delete existing habits so that I can remove ones I no longer wish to track._

**Acceptance Criteria:**

Given I am on the Habits page and at least one habit exists

When I click the Delete button on a specific habit

Then that habit is removed from the list and no longer appears on the home page

**Priority:** High

**Story Points:** 2

**Notes:**
- Show a confirmation prompt before deleting to prevent accidental removal.

---

### Personalize a habit with color

_As a User, I want to assign a specific color to each habit so that I can visually distinguish between them._

**Acceptance Criteria:**

Given I am adding or editing a habit on the Habits page

When I select a color from the color picker and save

Then the habit is displayed with the chosen color as its background or accent

**Priority:** Low

**Story Points:** 2

**Notes:**
- Provide a set of predefined colors to choose from.
- Custom hex input is optional.

---

## 6. Reports / Stats Page

### View weekly report

_As a User, I want to see a report of my weekly habit progress so that I can understand how consistently I am maintaining my habits._

**Acceptance Criteria:**

Given I am on the Reports page

When the page loads

Then a weekly summary is displayed showing the number of habits completed vs. total habits for each day of the current week

**Priority:** High

**Story Points:** 5

**Notes:**
- Default view should show the current week.
- Consider allowing navigation to previous weeks.

---

### Visualize completed habits

_As a User, I want to see a chart of my completed habits for each day of the week so that I can quickly identify trends in my progress._

**Acceptance Criteria:**

Given I am on the Reports page

When the page loads

Then a bar or line chart is displayed showing the number of habits completed per day for the current week

**Priority:** Medium

**Story Points:** 5

**Notes:**
- Use a charting library (e.g., Chart.js or Recharts).
- Each day should be labeled on the X-axis.

---

### View all habits in report

_As a User, I want to see both completed and incomplete habits in my report so that I have a comprehensive view of my habit tracking performance._

**Acceptance Criteria:**

Given I am on the Reports page

When I view the weekly report

Then each day shows both the completed habits (with a check indicator) and incomplete habits (with a pending indicator)

**Priority:** Medium

**Story Points:** 3

**Notes:**
- Use color coding (e.g., green for completed, gray for incomplete) to make the report easy to scan.

---

## 7. Notifications Page

### Enable or disable notifications

_As a User, I want to be able to enable or disable notifications for the app, so that I can choose whether or not to receive habit reminders._

**Acceptance Criteria:**

Given I am on the Notifications page

When I toggle notifications on or off

Then notifications are enabled or disabled accordingly, and the toggle reflects the current state

**Priority:** Medium

**Story Points:** 3

**Notes:**
- Request notification permissions from the device if enabling for the first time.
- Respect the user's device notification settings.

---

### Add habits for notifications

_As a User, I want to select specific habits to receive notifications for, so that I only get reminders for the habits I am actively working on._

**Acceptance Criteria:**

Given notifications are enabled and I am on the Notifications page

When I select one or more habits from the list

Then only those selected habits will trigger reminders at the scheduled notification times

**Priority:** Medium

**Story Points:** 3

**Notes:**
- All habits should be listed with multi-select support.
- Unselected habits receive no reminders.

---

### Set notification times

_As a User, I want to have the option to receive notifications three times a day (morning, afternoon, and evening) for my selected habits, so that I get timely reminders throughout the day._

**Acceptance Criteria:**

Given notifications are enabled and I have selected habits to be notified about

When I configure the notification time slots (morning, afternoon, evening)

Then reminders are sent for the selected habits at the configured times each day

**Priority:** Low

**Story Points:** 5

**Notes:**
- Default times: Morning = 8:00 AM, Afternoon = 1:00 PM, Evening = 7:00 PM.
- Allow the user to customize each time slot.
