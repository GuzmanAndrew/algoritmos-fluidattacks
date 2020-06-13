## Version 1.4.1
## language: en

Feature:
  TOE:
    Lin.security
  Category:
    Security System Nfs
  Location:
    182.168.0.22
  CWE:
    CWE-200: Exposure of Sensitive Information to an Unauthorized Actor
  Rule:
    REQ.181 Transmit data using secure protocols
  Goal:
    Gain root access
  Recommendation:
    setting up a trusted host

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.20esr    |
    | Nmap            | 7.80        |
    | showmount       | 1.3.3       |
    | John the ripper | 1.9.0       |
  TOE information:
    Given I'm accessing the server 192.168.0.22
    And the machine don't have a web service

  Scenario: Normal use case
    Given I'm scanning the server
    """
    $ nmap -sV 182.168.0.22 --open
    """
    When I see the open ports
    """
    22/tcp open ssh OpenSSH 7.6p1 Ubuntu 4
    111/tcp open rpcbind 2-4 (RPC #100000)
    2049/tcp open nfs_acl 3 (RPC #100227)
    """
    Then I decide to do some research on the NFS service
    And I saw that it's a file-sharing system on a LAN

  Scenario: Static detection
    Given the vulnerability is unrelated to the code
    Then I can't perform a static detection

  Scenario: Dynamic detection
    Given I found the "NFS" service
    When I decide to use "Nessus" to see if it has a vulnerability
    And it has a critical vulnerability and it's this
    """
    NFS Exported Share Information Disclosure
    """
    And his description is this
    """
    At least one of the NFS shares exported by the remote server could
    be mounted by the scanning host. An attacker may be able to leverage
    this to read (and possibly write) files on remote host.
    """
    When I researching more about NFS

  Scenario: Exploitation
    Given the machine has an "NFS" vulnerability
    When I decide to look up how "NFS" works
    Then I decide to do a proof of concept by creating an NFS system
    And it's to understand how it works
    When I see that the "showmount" command caught my attention
    Then I see in the documentation that your execution structure is this
    """
    $ showmount -ade host
    """
    Then I tried them out one by one and this is the result
    """
    $ showmount -a 192.168.0.22 “All mount points on 192.168.0.22:”
    $ showmount -d 192.168.0.22 “Directories on 192.168.0.22:”
    """
    And the "-e" option is the one that turned out to be interesting
    """
    $ showmount -e 192.168.0.22 Export list for 192.168.0.22: /home/peter *
    """
    Then I find for a way to mount that directory
    And I create a folder called "linsec" to mount inside
    When I see the "mount" command
    """
    $ mount -t nfs 192.168.0.22:/home/peter linsec
    """
    Then I see has her a directory called ".local"
    And inside it, it has another directory called "share"
    When I realize that "share" requires permission
    Then I start researching more "NFS"
    And I see that when you mount a "NFS" you will use the "UID"
    And "GUID" of the current user
    When I decide to look at the "UID" in the "peter" folder like this
    """
    $ stat linsec
    """
    Then I find out that
    When if I have a user with the same "UID" I can access the user "peter"
    When I decide to see the "UID" of my users
    Then I see that the user "root" has "UID" with value "0"
    And the user "mrandrew" has "UID" with a value of "1000"
    When I change the "UID" of the user "mrandrew" like this
    """
    $ usermod -u 1001 mrandrew
    """
    Then I enter the user as "su mrandrew"
    When I create an "ssh" to access the user "peter" with the same "UID"
    And it is with this command
    """
    $ ssh-keygen -t rsa -b 2048
    """
    When I go to the folder where the "peter" directory is mounted
    Then I create a folder called ".ssh"
    And I can see the hidden folders including the one I created así
    """
    ls -al
    """
    When I copy the SSH key to a file in the ".ssh" folder of the "NFS"
    """
    $ cp /home/mrandrew/.ssh/id_rsa.pub authorized_keys
    """
    Then I can connect to SSH like this
    """
    $ ssh peter@192.168.0.22
    """
    And I enter as user "Peter".
    When I decide to view the file "shadow" but I don't have permissions
    Then I decide to look at the file "passwd" and if I have access
    When I to copy in "Kali" all the contents of the file "passwd"
    And is for to discover the password with "John the Ripper"
    """
    $ john --wordlist=/root/rockyou.txt hashlinsec
    """
    When I get a password from the user "linsecurity"
    And it's a good thing because that user has the "UID"
    And the "GUID" for "root"
    When I execute the command "your linsecurity" inside the user "peter"
    And I'm already "root"

  Scenario: Remediation
    Given "NFS" has a version "3"
    When I research a way to correct the vulnerability
    And what you need to do is define the trusted IP
    """
    $ share -F nfs -o rw=IP_OF_TRUST SHARED_ROUTE
    """
    When the "-rw" is for read and write permission
    And the "-r" option is for read-only permissions

  Scenario: Scoring
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    6.8/10 (medium) - AV:P/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
  Temporal: Attributes that measure the exploit's popularity and fixability
    6.1/10 (medium) - E:F/RL:O/RC:R/CR:H/IR:H/AR:H
  Environmental: Unique and relevant attributes to a specific user environment
    6.1/10 (medium) - MAV:P/MAC:L/MPR:N/MUI:N/MS:U/MC:H/MI:H/MA:H

  Scenario: Correlations
    Given the version is no longer in use
    Then there is no correlation to date
