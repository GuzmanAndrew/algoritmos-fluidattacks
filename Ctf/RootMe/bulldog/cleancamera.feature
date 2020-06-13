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
    | Nmap            | 7.80        |
    | John the ripper | 1.9.0       |
  Machine information:
    Given I am accessing the machine 212.83.175.138
    And is running on port 80 and 8080

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 212.83.175.138
    """
    Then I get the output
    """
    PORT     STATE SERVICE VERSION
    23/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2
    80/tcp   open  http    WSGIServer 0.1 (Python 2.7.12)
    8080/tcp open  http    WSGIServer 0.1 (Python 2.7.12)
    """
    Then I can see that it has a port 80
    And is using server HTTP

  Scenario: Fail: Shell
    Given I have a port 80
    When I decide to see the website and it is only information
    Then I use Dirb of directory scan
    And I got three interesting directories
    """
    http://212.83.175.138/admin
    http://212.83.175.138/dev
    http://212.83.175.138/dev/admin
    """
    When I enter the directory "/dev/shell" it asks me to log in first

  Scenario: Fail: Login panel
    Given I have a directory named "/admin"
    When I go to that directory I see that it's an admin login
    Then I try to do Sql Injection and it doesn't work

  Scenario: Fail: Shell reverse
    Given I have a directory named "/dev"
    When I go to that directory I see that it has information
    And some software development users
    When I see the source code, users have a hash
    Then with the "hash-identifier" tool I see that the HASH are SHA1
    And I use "John the ripper" to decipher them
    """
    $ sudo john hash.txt --format=Raw-SHA1
    """
    When I get the password "bulldog" from the user "nick"
    Then I go into the admin but there's nothing interesting
    And I go to the directory "/dev/shell" which already allows me to enter
    When I read the page and it only allows some basic commands
    Then I try to make a "shell-rever" with python
    And I see that it doesn't work

  Scenario: Success: Flag
    Given the shell-reverse didn't work
    When I search the directories for something that's interesting
    Then I found a file named "customPermissionApp"
    And I use the "Cat" command to view its contents
    When I see that the result is not in plain text
    Then I use the "Strings" command to see the most readable text
    When I see a word in the result it that says
    """
    SUPERultimatePASSWORDyouCANTget
    """
    Then I try that phrase with SSH
    And I already have a more interactive shell
    When I execute the instruction "sudo -l" I see that I have all the bin
    """
    (ALL : ALL)
    """
    Then when you run "sudo /bin/bash" I'm already a "root" user
    And with that I can pull out the Flag
