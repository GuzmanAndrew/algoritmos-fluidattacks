## Version 2.0
## language: en

Feature:
  Site:
    TryHackMe
  Category:
    CTF
  User:
    Ar4m1r3z
  Goal:
    Obtain various of the image data

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Efixtool        | 12.00       |
  Machine information:
    Given I have an image
    When all I have to do is work on that image

  Scenario: Information gathering
    Given I have an image
    When I decide to search for information with the "Efixtool" tool
    """
    $ exiftool WindowsXP.jpg
    """
    And I get a good result
    When at TryHackMe I have to answer these questions
    """
    1. What is this users avatar of?

    2. What city is this person in?

    3. Whats the SSID of the WAP he connected to?

    4. What is his personal email address?

    5. What site did you find his email address on?

    6. Where has he gone on holiday?

    7. What is this persons password?
    """

  Scenario: Success: Get Avatar and City
    Given I perform a metadata scan
    When I get this result
    """
    Copyright : OWoodflint
    """
    Then I see that I have a user and search for information on Google
    When I found out that there are 3 URLs that are
    """
    - Twitter
    - Wordpress
    - GitHub
    """
    And I see that the avatar of "Twitter" is a "Cat"
    When I see on GitHub that he lives in "London"

  Scenario: Success: Get the SSID and Email
    Given I have the first two pieces of information
    When I go looking for the other data
    Then I decide to find the other data
    When I see that Twitter posts there's a "BSSID"
    Then I go to this URL to see what the SSID is
    """
    https://wigle.net/
    """
    And the result is this
    """
    UnileverWiFi
    """
    When I go to GitHub I get the mail
    Then the word GitHub helps me answer question "5"

  Scenario: Fail: get password
    Given I already have the answers from "1" to "5"
    When I decide to look in the source code for something interesting
    """
    d19880efda6c951cf284409705cf9fd7503e0938
    """
    Then I see that that string of characters is not a password

  Scenario: Success: Get the Passwod and Vacation City
    Given it wasn't the password
    When I look up more in the code
    And I find another string of characters that if it's the right one
    """
    pennYDr0pper. !
    """
    When I find city of holidays in the Wordpress
    """
    New York
    """
