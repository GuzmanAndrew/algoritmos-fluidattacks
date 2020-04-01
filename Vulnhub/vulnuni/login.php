<?php
if (isset($submit) && $submit) {
        unset($uid);
        $sqlLogin= "SELECT user_id, nom, username, password, prenom, statut, email, inst_id, iduser is_admin
                FROM user LEFT JOIN admin
                ON user.user_id = admin.iduser
                WHERE username='$_POST[uname]'";
?>