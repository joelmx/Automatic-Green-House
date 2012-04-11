<?php
session_name('ixpiasession');
session_start();
if($_SESSION['tiempoactivoal'] != "SI") {

header("Location: index.php");
exit();
} 
else {
$past = $_SESSION["timeaccessal"];
$now = date("Y-n-j H:i:s");
$time = (strtotime($now)-strtotime($past));
if($time >= 18000) {
session_destroy();
header("Location: index.php");
exit();  
}
else {
$_SESSION["timeaccessal"] = $now;
}
}
?>