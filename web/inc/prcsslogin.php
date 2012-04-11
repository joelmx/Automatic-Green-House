<?php
ini_set("session.use_only_cookies","1");
ini_set("session.use_trans_sid","0");

require_once('funciones.php');

$usuario = cleanInput($_POST['ixpiauser']);
$password = cleanInput($_POST['ixpiapass']);
//$pass = sha1($pass);

require_once('conexion.php');

  if (empty($usuario)||empty($password)){
	header("Location: ../index.php?error=1");
	exit;
  }

  $sql = "SELECT usuario,password FROM administrador WHERE usuario = '$usuario' and password ='$password'";
  $rs=mysql_query($sql,$con);
  if (!$rs) {
    echo 'Error al comprobar usuario contra password' . mysql_error();
    exit;
    }

  if(mysql_num_rows($rs)){

   session_name('ixpiasession');
   session_start();
   session_set_cookie_params(0, "/", $HTTP_SERVER_VARS["HTTP_HOST"], 0);
   $_SESSION['tiempoactivoal']='SI';
   $_SESSION['useral']= $usuario;
   $_SESSION['passal']= $password;
   $_SESSION["timeaccessal"]= date("Y-n-j H:i:s");

   header("Location: ../panel.php");
   exit; 
  }

   header("Location: ../index.php?error=2&user=$usuario");
   exit;
   
?>