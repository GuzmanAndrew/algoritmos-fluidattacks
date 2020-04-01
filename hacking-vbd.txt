## Version 1.4.1
## language: en

#Keep comments if they start with double sharp ##

#M: Mandatory
#O: Optional

#{} are template tags. A final feature should not contain any of these.
#<> are gherkin tags. They allow creating variables and are commonly used in
#tables (e.g: Background and Extraction scenarios.)

Feature: #M
  """
  This section is intended for the hacker to provide general information about
  the site he is trying to hack, what his goal is and recommendations on how to
  remediate the vulnerability.
  """
  TOE: #M: TOE containing the vulnerability
    {toe}
  Category: #O: Category containing the vulnerability
    {cat}
  Location: #M: Location of the page/endpoint/server/file with the vulnerability
    {url - field} #For web apps. e.g: http://sdfsdf.com/login.php - user (field)
    #OR
    {url - header} #For web apps. e.g: http://asdf.com/qwe.php - Cookie (header)
    #OR
    {ip:port TCP/UDP} #For servers. e.g: 192.168.1.1:80 TCP
    #OR
    {filepath:line} #For applications. e.g: /path/of/file.c:34 (34 is the line)
  CWE: #M: Vulnerability type according to the Common Weakness Ennumeration:
    CWE-{CWE-codenumber}: {codename} #link:https://cwe.mitre.org/data/index.html
  Rule: #M: Fluid Attacks' non-compliant rule
    REQ.{rule-number}: {rule-link} #link:https://fluidattacks.com/web/en/rules/
  Goal: #M: One-liner description of what you are intending to achieve
    {description}
  Recommendation:  #M: One-liner advice on how to fix the vulnerability
    {recommendation}

  Background: #M
  """
  In this section the hacker has to provide a list containing versions and names
  of the software he used for the attack (OS, Browser, etc).
  Also, detailed information about the TOE like: Relevant services with their
  versions, OS and kernel with their versions, and any other information
  that might be relevant to the context has to be provided
  """
  Hacker's software:
    | <Software name> | <Version>   |
    | {os}            | {version 1} |
    | {browser}       | {version 2} |
    | {name1}         | {version 3} |
  TOE information:
    Given I am accessing the site {www.site.com}
    And enter a php site that allows me {A}
    And the server is running MySQL version {B}
    And PHP version {C}
    And SSH version {D}
    And is running on Ubuntu {E} with kernel {F}


  Scenario: Normal use case #M
    """
    In this section the hacker has to describe what the site
    does under normal circumstances.
    """
  {descrption} #Brief description of what this section does
    Given I access {A}
    And open {B}
    Then I can see [evidence](image1.png)
    And [evidence](image2.png) #See evidences at the end of the file

  Scenario: Static detection #M (Only optional if code is unnaccesible)
  """
  In this scenario the hacker has to identify the portion of code that is
  causing the vulnerabilty and cite it. This helps the hacker to be able to
  provide a fix for the vulnerability in future sections.
  The explicit line(s) generating the vulerability have to be cited.
  Formats for citing multiple lines are:
  1 - lines 1, 2, 3, 4, ..., n
  2 - line 1 to line n
  """
  {cause} #Brief description of what is causing the vulnerability
    When I look at the code {A} #How did you find the vulnerability in the code?
    Then I can see that the vulnerability is being caused by {FUNCTION1} from
    line 141 to line 142
    And {FUNCTION2} in lines 143, 144
    """
    141  CODE
    142  CODE
    143  CODE
    144  CODE
    """
    Then I can conclude {C} #What conclusions can you draw from this?

  Scenario: Dynamic detection #M
  """
  In this scenario the hacker has to detect the vulnerability in a practical
  way. Meaning that he has to be able to identify the attack vector that
  would allow to deliver a payload. Tools like Burp, Msfconsole or SQLmap are
  often used in this section.
  """
  {cause} #Brief description of the vulnerability
    Given {A}
    And {B}
    Then I can execute the following command:
    """
    $ COMMAND
    """
    Then I get the output:
    """
    ... #Unimportant lines
    OUTPUT
    ... #Unimportant lines
    """
    Then I can conclude that {C} #What conclusions can you draw from this?

  Scenario: Exploitation #M
  """
  After dynamically detecting the vulnerability, the next step is to exploit it:
  This section allows the hacker to exploit the target and try to achieve the
  goal that was described previously in the file.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement the exploit?
    And {B}
    Then I can execute the following command:
    """
    $ COMMAND
    """
    Then I get the output:
    """
    ... #Unimportant lines
    OUTPUT
    ... #Unimportant lines
    """
    Then I can conclude that {C} #What can you conclude from the exploitation?

  Scenario: Maintaining access #O
  """
  If it is necessary to add additional information about deploying additional
  malware in order to keep access to the target even if the vulnerabilty used
  in the first place gets patched, this section has to be included.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement this?
    And {B}
    Then I can upload the file {C}:
    Then I get access by running:
    """
    $ COMMAND
    """
    Then I can conclude that {D} #What can you conclude from this?

  Scenario Outline: Extraction #O
  """
  If it is necessary to add additional information about extracting sensitive
  information, this section has to be included.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement this?
    And {B}
    Then I can access <file> and read <output>
    Examples:
      | <file>      | <output> | <evidence>     |
      | /etc/passwd |   OUTPUT | etc-passwd.png |
      | /etc/shadow |   OUTPUT | etc-shadow.png |
    Then I can conclude that {C} #What can you conclude from this?
    #See evidences at the end of the file

  Scenario: Destruction #O
  """
  If it is necessary to add additional information about destroying protected
  data from the target, this section has to be included.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement this?
    And {B}
    Then remove files {C} with command:
    """
    $ COMMAND
    """
    Then I can conclude that {D} #What can you conclude from this?

  Scenario: Covering tracks #O
  """
  If it is necessary to add additional information about dealing with logs or
  other information that could reveal the hacker's presence, this section has
  to be included.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement this?
    And {B}
    Then I can modify or delete files {C} with command:
    """
    $ COMMAND
    """
    Then I can conclude that {D} #What can you conclude from this?

  Scenario: Denial of service #O
  """
  If it is necessary to add additional information about generating a denial of
  service attack in the target, this section has to be included.
  """
  {descrption} #Brief description of what this section does
    Given {A} #What conditions are needed in order to implement this?
    And {B}
    Then I can stress the target by doing {C} with command:
    """
    $ COMMAND
    """
    Then If I try to access the site by doing {D}, it does not load
    Then I can conclude that {E} #What can you conclude from this?

  Scenario: Remediation #M
  """
  In this section the hacker takes the code provided in the Static detection
  scenario and modifies it in order to patch the vulnerability.
  The same attack vector has to be ran on the target with the patched code
  in order to prove that the vulnerability was fixed.
  If the source code is not available, this scenario has to include
  a high-level explanation on how such vulnerability is usually fixed.
  """
  {descrption} #Brief description of what is done to remediate the vulnerability
    Given I have patched the code by doing {A}
    And {B}
    """
    141 CODE
    142 CODE
    143 CODE
    """
    Then If I re-run my exploit {C} with command:
    """
    $ COMMAND
    """
    Then I get:
    """
    ... #Uninmportant lines
    FAILED EXPLOIT OUTPUT
    ... #Unimportant lines
    """
    Then I can confirm that the vulnerability was successfully patched

  Scenario: Scoring #M
  """
  Scoring allows the hacker to provide a sandardized metric that reflects
  how dangerous the vulnerability is from three different perspectives.
  """
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    {basenumber}/10 ({baseword}) - {basevectorstring}
  Temporal: Attributes that measure the exploit's popularity and fixability
    {tempnumber}/10 ({tempword}) - {tempvectorstring}
  Environmental: Unique and relevant attributes to a specific user environment
    {envnumber}/10 ({envword}) - {envvectorstring}
  #Example
  Severity scoring according to CVSSv3 standard
  Base: Attributes that are constants over time and organizations
    8.3/10 (High) - AV:N/AC:H/PR:N/UI:R/S:C/C:H/I:H/A:H/
  Temporal: Attributes that measure the exploit's popularity and fixability
    7.9/10 (High) - E:H/RL:O/RC:C/
  Environmental: Unique and relevant attributes to a specific user environment
    6.4/10 (Medium) - CR:L/IR:L/AR:L

  Scenario: Correlations #M
  """
  This section is intended to provide the hacker with the capability of adding
  references to other discovered vulnerabilities that, combined with the current
  one, could lead to a more powerful attack vector.
  """
    #If no correlations have been found:
    No correlations have been found to this date {yyyy-mm-dd}
    #If there are one or more correlations:
    vbd/{toe}/{vulnerability1}
      Given I do {A} #Provided by this vulnerability
      And {B} provided by {vulnerability1}
      When {C}
      Then I get {D}
      And {E}
    vbd/{toe}/{vulnerability2}
      Given I did {A}
      And {B}
      And {C} provided by {vulnerability2}
      Then I can do {E}
      Then I get {F}


  """
  Folder Naming Convention:
  In the folder structure training/vbd/toe/vulnerability/feature
  Hackers will often have to create vulnerabilty folders for discovered
  vulnerabilities in a TOE. Vulnerability folders will contain:
    - Only one feature file for the specific vulnerability
    - A LINK.lst file with a link to the site containing the vulnerability
    - (Optional) Evidence folder if necessary

  The following standard has been definied for vulneraility folders:
  {CWE-codenumber}-{location}-{difficulty} where:
    - {CWE-codenumber} is the codenumber of the vulnerability according to the
      Common Weakness Ennumeration (link:https://cwe.mitre.org/data/index.html)
    - {location} has to be a pointer to the vulnerability's location.
    - (optional) {difficulty} is the difficulty in which the vulnerability was
      found. All TOEs might not have a difficulty setting, that is why this is
      optional
  Some examples are (they do not necessarily exist in the repo but illustrate
  the point):
    - training/vbd/bwapp/352-xss-stored-2-medium/
    - training/vbd/dvwa/006-weak-session-ids-low/
    - training/vbd/webgoat/352-stored-xss/ #webgoat does not have difficulty
  """

  """
  Evidences:
  Presenting evidence of some kind of graphical output, like websites,
  might be difficult when using plain feature files.
  Think, for example, of a hacked blog via XSS that ended up with different font
  styles and such.
  Evidences are a way to include PNG pictures associated to a feature file so
  the hacker can graphically show anything he might consider relevant

  How they work?
  - Any feature file {name}.feature can have a {name} evidences folder in the
  same directory.
  - Evidence folders only accept PNG images
  - Evidences are referenced in two different ways:
    - Creating an <evidence> tag in a table inside a Scenario Outline like shown
      on the Extraction Scenario example
      (useful for referencing multiple evidences).
    - By using the following syntax: [evidence](image.png) like shown on the
      Normal use case Scenario example.
      (useful for referencing one or two evidences at most.)
  """
