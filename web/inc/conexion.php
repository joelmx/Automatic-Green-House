<?php
$dbhost="localhost";		//nombre del host generalmente es localhost
$dbusuario="micros";		//nombre de usuario con acceso a la base de datos
$dbpassword="micros";		//contraseña de usuario con acceso a la base de datos
$db="micros"; 		//nombre de la base de datos
$con = mysql_connect($dbhost, $dbusuario, $dbpassword);
mysql_select_db($db, $con);
?>
