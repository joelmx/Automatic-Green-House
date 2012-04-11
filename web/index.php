<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="shortcut icon" href="favicon.ico" />
<title>SAI-Login</title>
<link rel="stylesheet" href="css/index.css" type="text/css" media="screen" />
<script type="text/javascript">
function validar(e) {
  tecla = (document.all) ? e.keyCode : e.which;
  if (tecla==13) document.getElementById('boton1').click();
 
}

function preloader() 
{
     var i = 0;
     imageObj = new Image();
     images = new Array();
     images[0]="/images/logo.png"
     for(i=0; i<=0; i++) 
     {
     imageObj.src=images[i];
     }

} 


</script>
</head>
<body onload='document.getElementById("ixpiauser").focus();preloader()'>
<body>
<div id='mainc'>
	
<div id='enca'>
	
	<div id='titulo'><img src='images/logo.png' title='' alt='' /></div>

	<div id='contenido'>
	<form action='inc/prcsslogin.php' method='post' name='identifica'>
	<table>
        <tr><th colspan='2' style='color:#003468;'>Identifícate<br/><br/></th></tr>
	<tr><th><label for='nutriuser'>Usuario:</label></th><td><input type='text' name='ixpiauser' id='ixpiauser' value="<?php if(isset($_GET['user'])){echo $_GET['user'];} ?>" /></td></tr>
	<tr><th><label for='nutripass'>Contraseña:</label></th><td><input type='password' name='ixpiapass' id='ixpiapass' onkeyup='validar(event)' /></td></tr>
	<tr><th colspan='2'><br/><input type='button' value='Aceptar' id='boton1' onclick='document.identifica.submit();'/></th></tr>
	</table>
	</form>
	<div class='error'>&nbsp;<?php if(isset($_GET['error'])){switch($_GET['error']) {case 1: echo "Escribe tu nombre y tu contraseña en los campos correspondientes";break;case 2: echo "Nombre y/o contraseña incorrectos";break;}}?></div>
	<br/>
	</div>
</div>
</div>
</body>
</html>
