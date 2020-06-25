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
    Escalate privileges to get flag

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | hash-buster     | 3.0         |
  Machine information:
    Given I have a website
    When I see that it has a string of characters

  Scenario: Fail: Decrypt Hash
    Given I have a hash
    """
    96719db60d8e3f498c98d94155e1296aac105ck4923290c89eeeb3ba26d3eef92
    """
    When I search the internet for an application to decipher it
    Then the result I generate is a HASH SH1
    And it didn't work.

  Scenario: Fail: hash text
    Given I don't have the text of the HASH
    When I use the "findmyhash" tool
    And the tool didn't work.

  Scenario: Success: Flag
    Given the tool didn't work
    When I find a tool named "hash-buster"
    And to execute
    """
    $ hash-buster -s 
      96719db60d8e3f498c98d94155e1296aac105ck4923290c89eeeb3ba26d3eef92
    """
    When I see that I have a plain text
    """
    4dM1n
    """
    So that text is not the answer to the challenge
    And the answer is a HASH SH1
    When I decide to use "sha1sum" to calculate HASH
    """
    $ echo -n 4dM1n | sha1sum 
    """
    When the HASH generated was the answer to the challenge
