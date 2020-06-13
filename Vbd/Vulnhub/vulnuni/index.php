<?php session_start(); 
/*
      +----------------------------------------------------------------------+
      | GUnet eClass 1.7                                                    |
      | Asychronous Teleteaching Platform                                    |
      +----------------------------------------------------------------------+
      | Copyright (c) 2003-2007  GUnet                                       |
      +----------------------------------------------------------------------+
      |                                                                      |
      | GUnet eClass 1.7 is an open platform distributed in the hope that   |
      | it will be useful (without any warranty), under the terms of the     |
      | GNU License (General Public License) as published by the Free        |
      | Software Foundation. The full license can be read in "license.txt".  |
      |                                                                      |
      | Main Developers Group: Costas Tsibanis <k.tsibanis@noc.uoa.gr>       |
      |                        Yannis Exidaridis <jexi@noc.uoa.gr>           |
      |                        Alexandros Diamantidis <adia@noc.uoa.gr>      |
      |                        Tilemachos Raptis <traptis@noc.uoa.gr>        |
      |                                                                      |
      | For a full list of contributors, see "credits.txt".                  |
      |                                                                      |
      +----------------------------------------------------------------------+
      | Contact address: Asynchronous Teleteaching Group (eclass@gunet.gr),  |
      |                  Network Operations Center, University of Athens,    |
      |                  Panepistimiopolis Ilissia, 15784, Athens, Greece    |
      +----------------------------------------------------------------------+
*/
unset($language);
@include('./config/config.php'); 
include 'include/lib/main.lib.php';
@include("./modules/lang/english/index.inc.php");
@include("./modules/lang/english/trad4all.inc.php");
@include("./modules/lang/$language/index.inc.php");
@include("./modules/lang/$language/trad4all.inc.php");
@include('./mainpage.inc.php');

header('Content-Type: text/html; charset='. $charset);

if (!isset($urlSecure)) {
        $urlSecure = $urlServer;
}

if (isset($_GET['logout'])) {
	$logout = true;
} else {
	$logout = false;
}

?><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link rel="stylesheet" href="template/default.css" type="text/css">
<link rel="SHORTCUT ICON" href="images/favicon.ico">
<?
	if (isset($siteName)) echo "<title>$siteName</title>"; 
	else echo "<title>����������� ��� eClass</title>";
?>
<meta name="description" content="elearning platform">
<meta name="keywords" content="eclass, elearning, asynchronous teleteaching, gunet e-class, open cms, gunet">
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=<?= $charset ?>">	
</head>
<?

// check if we can connect to database. If not then probably it is the first time we install eclass
if (isset($mysqlServer) and isset($mysqlUser) and isset($mysqlPassword)) {
		$db = @mysql_connect($mysqlServer, $mysqlUser, $mysqlPassword);
}
if (!isset($db) or !$db) {
	echo "<html><head><title>eClass</title></head>
	<center><table width='800' align='center' cellpadding='0' cellspacing='0' border='0'>
	<tr>
  <td colspan='5' align='right' valign=top width=800 height=90 bgcolor='#E6E6E6' style='background-image:url(images/gunet/banner.jpg);' class='td_banner'>
	</td></tr>
	<tr><td colspan='5' class=td_navbar style='background-image:url(images/bg.gif);'>&nbsp;</td></tr>
	<tr><td height=316 valign=top class=td_main><br>";
  echo "<blockquote><p style='font-weight:bold; font-style:Verdana; font-size:12px;' class=alert1>
     � ��������� ���������� �������������� ��� ���������� !</p></p></blockquote>";
  echo "<table align=center width=100% border=\"0\" cellspacing=1 cellpading=1 style=\"border: 1px solid #F1F1F1;\">
  <tr><td class=color2 style=\"border: 1px solid #F1F1F1;\" colspan=2 align=center><b>������� �����:</b></td></tr>
  <tr><td class=color1 width=50%style=\"border: 1px solid #F1F1F1;\" align=center>(<b>A</b>) �������������� ��� ��������� ��� <u>����� ����</u></td>
  <td class=color1 style=\"border: 1px solid #F1F1F1;\" align=center>(<b>B</b>) �������� ��� <u>������ ���������</u> � �� <u>���� ���������</u></td></tr>
  <tr><td class=td_main style=\"border: 1px solid #F1F1F1;\" valign=top>
  <br><b>���������:</b><br><br>
  <img src=images/arrow_red.gif>&nbsp;&nbsp;A���������� ��� ����� ������������ ��� �� ���������� �� ��������� ������������.
  <br><br><div align=center><a href=\"./install/\" class=mainpage>������ ������������ >></a></div><br><br>
  </td>
  <td class=td_main style=\"border: 1px solid #F1F1F1;\" valign=top>
  <br><b>���������:</b><br><br>
  <img src=images/arrow_red.gif>&nbsp;&nbsp;�� ������ <tt><font color=red>config.php</font></tt> ��� ������� � ��� ������ �� ���������.<br>
  <img src=images/arrow_red.gif>&nbsp;&nbsp;� <tt><font color=red>MySQL</font></tt> ��� ����������.
  <br></td></tr></table><br><br><br><br><br>";
	include 'include/footer.php';
	end_page(TRUE, TRUE);
	exit();
}

// set the correct charset
if (mysql_version()) mysql_query("SET NAMES greek");

// select database
if (isset($mysqlMainDb)) $selectResult = mysql_select_db($mysqlMainDb,$db); 
if (!isset($selectResult)) {
	die("������� �������� �� ��� MySQL !");
}

// unset system that records visitor only once by course for statistics
unset($alreadyHome);
unset($dbname); 

// ------------------------------------------------------------------------
// if we try to login...
// then authenticate user. First via LDAP then via MyQL
// -----------------------------------------------------------------------
$warning = '';
if (isset($submit) && $submit) {
        unset($uid);
        $sqlLogin= "SELECT user_id, nom, username, password, prenom, statut, email, inst_id, iduser is_admin
                FROM user LEFT JOIN admin
                ON user.user_id = admin.iduser
                WHERE username='$_POST[uname]'";
        $result=mysql_query($sqlLogin);
        while ($myrow = mysql_fetch_array($result)) {
                if ($myrow["inst_id"] == 0) {           // If user is not authenticated via LDAP...
                                                        // ...get account details from db.
                        if (($_POST["uname"] == $myrow["username"]) and ($_POST["pass"] == $myrow["password"])) {
                                $uid = $myrow["user_id"];
                                $nom = $myrow["nom"];
                                $prenom = $myrow["prenom"];
                                $statut = $myrow["statut"];
                                $email = $myrow["email"];
                                $is_admin = $myrow["is_admin"];
                        }
                } elseif (!empty($_POST["pass"])) {    // If user auth is via LDAP...
                        $findserver = "SELECT ldapserver, basedn FROM institution
                                       WHERE inst_id = ".$myrow["inst_id"];
                        $ldapresult = mysql_query($findserver);
                        while ($myrow1 = mysql_fetch_array($ldapresult)) {
                                $ds = ldap_connect($myrow1["ldapserver"]);  //get the ldapServer, baseDN from the db
                                if ($ds) {
                                        $r=@ldap_bind($ds);     // this is an "anonymous" bind
                                        if ($r) {
                                                $mailadd = ldap_search($ds, $myrow1["basedn"], "mail=".$_POST["uname"]);
                                                $info = ldap_get_entries($ds, $mailadd);
                                                if ($info["count"] == 1) {       // user found
                                                        $authbind = @ldap_bind($ds, $info[0]["dn"], $_POST["pass"]);
                                                        if ($authbind) {
                                                                $uid = $myrow["user_id"];
                                                                $nom = $myrow["nom"];
                                                                $prenom = $myrow["prenom"];
                                                                $statut = $myrow["statut"];
                                                                $email = $myrow["email"];
                                                                $is_admin = $myrow["is_admin"];
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }

       if (!isset($uid)) {
                $warning = "<span class='labeltext'>".$langInvalidId."<br>
									</span><br>";
	} else {
                $warning = '';
                $log='yes';
                session_register('uid');
                session_register('nom');
                session_register('prenom');
                session_register('email');
                session_register('statut');
                session_register('is_admin');
                $_SESSION['uid'] = $uid;
                mysql_query("INSERT INTO loginout (loginout.idLog, loginout.id_user, loginout.ip, loginout.when, loginout.action)
                VALUES ('', '".$uid."', '".$REMOTE_ADDR."', NOW(), 'LOGIN')");
        	}
}  // end of user authentication


?>
<table width="<?= $mainInterfaceWidth ?>" align="center" cellpadding="0" cellspacing="0" border="0">
<tr>
  <td colspan="5" align="right" valign=top width=800 height=90 bgcolor="<?= $colorMedium ?>" style="background-image:url(<? echo $urlAppend,'/',$bannerPath ?>)" class="td_banner">

<?
if (isset($_SESSION['uid'])) $uid = $_SESSION['uid'];
else unset($uid);

if (isset($uid) and !$logout) {
        echo "   $langUser: <b>$prenom $nom</b>,\n";
        echo "  <a href='".$urlServer."index.php?logout=yes' class=userbar><b><font color='#DE5E41'>$langLogout</font></b></a>\n";
} else echo "<span>&nbsp;</span>\n";
?>
</td></tr>
<tr><td colspan="2" valign="top" align="left" class=td_navbar style="background-image:url(<? echo $urlAppend,'/images/bg.gif' ?>)"><b><span class="menu">
<?
if (isset($uid))
	echo $langMyPortfolio;
else 
	echo $langHomePage;
?>

</span></b><br></td></tr> 
<?

// if login succesful 

if (isset($uid) AND !$logout) { 
// display right menu

?>
        <tr valign="top">
          <td class=td_menu>
            <br>
            <table cellpadding='4' cellspacing='0' width='100%' border=0>

              <? // User is not currently in a course - set statut from main database
              $res2 = mysql_query("SELECT statut FROM user WHERE user_id = '$uid'");
              if ($row = mysql_fetch_row($res2)) $statut = $row[0];
              // check if useass='mainpage'> is admin
              if (isset($is_admin) and $is_admin) {
              echo "<tr bgcolor='#FFFFCC'>
                    <td class='menu' style=\"border: 1px solid #DCDCDC;\">
                    <img src='images/arrow.gif' alt='arrow bullet'>
                    <a href='${urlSecure}modules/admin/' class='mainpage'>$langAdminTool</a>
                    </td>
                    </tr>";
              }
              
              // check if user is a professor
              if ($statut==1) {
              echo "<tr><td class='menu'><img src='images/arrow.gif'>
              <a href='${urlServer}modules/create_course/create_course.php' class='mainpage'>$langCourseCreate</a></td></tr>";
              }
              // check if user is not a guest
              if ($statut != 10) {
              echo "<tr><td class='menu'><img src='images/arrow.gif'>
                        <a href='${urlServer}modules/auth/courses.php' class='mainpage'>$langOtherCourses</a></td></tr>
                        <tr><td class='menu'><img src='images/arrow.gif'>
                        <a href='${urlServer}modules/agenda/myagenda.php' class='mainpage'>$langMyAgenda</a></td></tr>
                        <tr><td class='menu'><img src='images/arrow.gif'>
                        <a href='${urlServer}modules/announcements/myannouncements.php' class='mainpage'>$langMyAnnouncements</a></td></tr>";
              echo "<tr>
                      <td class='menu'><img src='images/arrow.gif'>
                        <a href='${urlSecure}modules/profile/profile.php' class='mainpage'>$langModifyProfile</a></td></tr>";
}
?>
           <tr><td class="menu"><img src='images/arrow.gif'>
                <a href="<?= $urlServer ?>modules/help/help.php?topic=HomePage" class='mainpage' onClick="window.open('<?= $urlServer ?>modules/help/help.php?topic=HomePage','help','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=400,height=500,left=300,top=10');
    return false;">
<?
  echo $langHelp;
  echo "</a></td></tr>";
  echo "</table>";
  echo "</td>";
 
// display courses list
	echo '<td width="75%" class=td_main valign="top" height="400"><table cellpadding="4" width="100%" border="0" cellspacing="0">';
	$result2 = mysql_query("SELECT cours.code k, cours.fake_code c, cours.intitule i, cours.titulaires t, cours_user.statut s
		FROM cours, cours_user WHERE cours.code=cours_user.code_cours AND cours_user.user_id='".$uid."'
		AND (cours_user.statut='5' OR cours_user.statut='10')");
        if (mysql_num_rows($result2) > 0) {
                ?>
	             <tr>
               <td>
               <script type="text/javascript" src="modules/auth/sorttable.js"></script>
               <table width="100%" border=0 cellpadding="0" cellspacing="1" valign=middle align=center style="border: 1px solid #DCDCDC;">
               <tr>
                 <td>
                    <table width="100%" border=0 cellpadding="0" cellspacing="0" height=30 valign=middle align=center style="border: 1px solid #DCDCDC;">
                    <tr>
                      <td class=color1 valign=middle style="border: 1px solid #F1F1F1;"><b><? echo "$langMyCoursesUser"; ?></b></td>
                    </tr>
                    </table>
                 </td>
               </tr>
               <tr>
                 <td>
                    <table width="100%" class="sortable" id="t1" border=0 cellpadding="0" cellspacing="0" align=center style="border: 1px solid #F1F1F1;">
		    <tr>
                      <td class='td_small_HeaderRow' align='left' width='65%'><?= $langCourseCode ?></td>
                      <td class='td_small_HeaderRow' align='left' width='30%'><?= $langProfessor ?></td>
                      <td class='td_small_HeaderRow' align='center' width='5%'><?= $langUnCourse ?></td>
                    </tr>
         <?
			while ($mycours = mysql_fetch_array($result2)) {
				$dbname = $mycours["k"];
				$status[$dbname] = $mycours["s"];
		     ?>
		    <tr onMouseOver="this.style.backgroundColor='#F5F5F5'" onMouseOut="this.style.backgroundColor='transparent'">
         <?
				 	echo "
                          <td class=kkk height=25>
                            <a href='${urlServer}courses/$mycours[k]' class=CourseLink>$mycours[i]</a>
                            <span class='explanationtext'><font color=#4175B9>$mycours[c]</font></span>
                          </td>
			  <td class=kkk><span class='explanationtext'>$mycours[t]</span></td>
			  <td align=center><a href='${urlServer}modules/unreguser/unregcours.php?cid=$mycours[c]&u=$uid'><img src='images/cunregister.gif' border='0' title='$langUnregCourse'></a></td>
			</tr>";
		}	// while 
?>
                    </table>
                    </td>
                  </tr>
                  </table>
           <br>
           </td>
          </tr>
<?
	} 
	else  {
			if ($_SESSION['statut'] == '5')  // if we are login for first time
			      echo " <tr><td>$langWelcomeStud</td></tr>\n";
  } // end of if (if we are student)

// second case check in which courses are registered as a professeror
	$result2 = mysql_query("SELECT cours.code k, cours.fake_code c, cours.intitule i, cours.titulaires t, cours_user.statut s
        	FROM cours, cours_user WHERE cours.code=cours_user.code_cours 
		AND cours_user.user_id='".$uid."' AND cours_user.statut='1'");
	if (mysql_num_rows($result2) > 0) {
                ?>
                <tr>
                  <td>
                  <script type="text/javascript" src="modules/auth/sorttable.js"></script>
                  <table width="100%" border=0 cellpadding="0" cellspacing="1" valign=middle align=center style="border: 1px solid #DCDCDC;">
                  <tr>
                    <td>
                    <table width="100%" border=0 cellpadding="0" cellspacing="0" height=30 valign=middle align=center style="border: 1px solid #iDCDCDC;">
                    <tr>
                      <td class=color1 valign=middle style="border: 1px solid #F1F1F1;"><b><? echo "$langMyCoursesProf"; ?></b></td>
                    </tr>
                    </table>
                    </td>
                  </tr>
                  <tr>
                    <td>
                    <table width="100%" class="sortable" id="t1" border=0 cellpadding="0" cellspacing="0" align=center style="border: 1px solid #F1F1F1;">
                    <tr> 
                      <td class='td_small_HeaderRow' align='left' width='65%'><?= $langCourseCode ?></td>
                      <td class='td_small_HeaderRow' align='left' width='30%'><?= $langProfessor ?></td>
                      <td class='td_small_HeaderRow' align='center' width='5%'><?= $langManagement ?></td>
                    </tr>
            <?
				while ($mycours = mysql_fetch_array($result2)) {
                	$dbname = $mycours["k"];
                	$status[$dbname] = $mycours["s"];
                        ?>
                        <tr onMouseOver="this.style.backgroundColor='#F5F5F5'" onMouseOut="this.style.backgroundColor='transparent'">
                        <?
                        echo "
                          <td class=kkk height=26>
                          <a class='CourseLink' href='${urlServer}courses/$mycours[k]'>$mycours[i]</a>
                          <span class='explanationtext'><font color=#4175B9>($mycours[c])</font></span>
                          </td>
			  <td class=kkk><span class='explanationtext'>$mycours[t]</span></td>
			  <td align=center valign=middle>
			  <a href='${urlServer}modules/course_info/infocours.php?from_home=TRUE&cid=$mycours[c]'>
			  <img src=images/referencement.gif border=0 title='$langManagement' align='absbottom'></img></a>
                          </td>
                        </tr>
                        ";
        	}       // while
             ?>
                    </table>
                    </td>
                  </tr>
                  </table>
                    <br>
                  </td>
                </tr>
              <?
	} 
        else
        { 
						if ($_SESSION['statut'] == '1')  // if we are loggin for first time
            		echo " <tr><td>$langWelcomeProf</td></tr>\n";
        } // if

	echo "</table></td>"; 
	echo "</tr>";
	session_register('status');

}	// end of if login

// -------------------------------------------------------------------------------------
// display login page 
// -------------------------------------------------------------------------------------

else { 
        // Login URL
        if (!isset($urlSecure)) {
                $seclogin = $urlServer;
        } else {
                $seclogin = $urlSecure;
        }
	echo "<tr valign=\"top\">";
?>
       <td class=td_menu>
          <br>
            <table cellpadding='4' cellspacing='0' width='100%' border=0>
            <tr>
              <td class='menu'>
              <img src='images/arrow.gif'>
              <a href='modules/auth/listfaculte.php' class='mainpage'><? echo "$langListFaculte"; ?></a>
              </td>
            </tr>
            <tr>
              <td class='menu'>
              <img src='images/arrow.gif'>
<?
	if (check_ldap_entries())
		$newuser="newuser_info.php"; 
	elseif (isset($close_user_registration) and $close_user_registration == TRUE) 
		$newuser = "formuser.php";
	else
		$newuser = "newuser.php";

?>
              <a href='<?= $urlSecure ?>modules/auth/<?= $newuser ?>' class='mainpage'><?= $langNewUser ?></a></td></tr>
            <tr>
              <td class='menu'>
              <img src='images/arrow.gif'>
              <a href='modules/auth/formprof.php' class='mainpage'><?= $langProfReq ?></a>
              </td>
            </tr>
            <tr>
              <td class='menu'>
              <img src='images/arrow.gif'>
              <a href='manuals/manual.php' class='mainpage'><?= $langManuals ?></a>
              </td>
            </tr>
            <tr>
              <td class='menu'>
              <img src='images/arrow.gif'>
              <a href='info/about.php' class='mainpage'><? echo "$langInfoPlat"; ?></a>
              </td>
            </tr>
            <tr>
              <td class='menu' style='padding-bottom: 60px;'>
              <img src='images/arrow.gif'>
              <a href='info/contact.php' class='mainpage'><? echo "$langContact"; ?></a>
              </td>
            </tr>
            </table>
            <table align=center valign=bottom border=0 cellpadding='0' cellspacing='0' width='100%'>
            <tr>
              <td valign=bottom align=center height=160>
              <img src='images/ktp2.gif' align=center valign=bottom title="�������� ��� �����������" border=0>
              </td>
            </tr>
            </table>
          </td>
<?
	if (isset($logout) && $logout && isset($uid)) {
		mysql_query("INSERT INTO loginout (loginout.idLog, loginout.id_user,
			loginout.ip, loginout.when, loginout.action)
			VALUES ('', '$uid', '$REMOTE_ADDR', NOW(), 'LOGOUT')");
		unset($prenom);
		unset($nom);
		session_destroy();
	}

?>	
      <td width='75%' class='td_main' valign='top' height='400'> 
      
      <table align=center border=0 cellpadding='0' cellspacing='0'>
      <tr><td class=td_main>&nbsp;</td></tr>
      <tr>
        <td width=300 height=181 valign=top style="background-image:url(<? echo $urlAppend,'/images/table_layout.jpg' ?>)" style="background-repeat : no-repeat;">  
        <div align=center><b><?= $langEnter ?></b></div><br>
        <form action="<?= $seclogin ?>" method="post">
        <div align="center"><small><?= $langUserName ?></small><br>
        <input style='width:150px; heigth:20px;' name="uname" size="20"><br>
        <small><?= $langPass ?></small><br>
        <input style='width:150px; height:20px;' name="pass" type="password" size="20"><br>
        <input value="<?= $langEnter ?>" name="submit" type="submit"><br><br>

				<a href="modules/help/help.php?topic=Init" class='mainpage' onClick="window.open('modules/help/help.php?topic=Init','help','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=400,height=500,left=300,top=10'); return false;">
<img src='images/help.gif' border=0 title='�������' align='absbottom'></img></a>
&nbsp;<a href="modules/auth/lostpass.php" class='help_topic'><?= $lang_forgot_pass?></a>
	</div>
        </form>
        </td>
      </tr>
      </table>
      <table width=100% align=center border=0 cellpadding='0' cellspacing='0'>
      <tr>
        <td align=center>
      <?
      if ($warning<>'') {
         echo "<b><font color=red>$warning</font></b>";
      } else {
         echo "<br>&nbsp;";
      }
      ?>
        </td>
      </tr>
      </table>
      <div style="padding-top: 4px; padding-left: 20px; padding-right:20px; padding-bottom: 5px;">
      <?= $main_text  ?>
      </div>
      </td>

<?

	echo "</tr></table>";
} // end of display 

// display page footer
echo $main_page_footer;

?>
</body> 
</html>

