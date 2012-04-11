<?php 
require_once("inc/token.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<link rel="shortcut icon" href="favicon.ico" />
<title>SAI-Datasheets</title>
<link rel="stylesheet" href="css/main.css" type="text/css" media="screen"/>
<script type="text/javascript">
function preloader() 
{
     var i = 0;
     imageObj = new Image();
     images = new Array();
     images[0]="/images/saliron.png"
     images[1]="/images/manualon.png"
     images[2]="/images/datasheeton.png"
     images[3]="/images/inicioon.png"
     images[4]="/images/acercaon.png"
     for(i=0; i<=4; i++) 
     {
     imageObj.src=images[i];
     }

} 


</script>
</head>
<body>
<div id='mainc'>
	<div id='top'>
	</div>
	<div id='mbottom'>
		<div id='menu'>
	<img src="images/inicio.png" onmouseover="this.src='images/inicioon.png'" onmouseout="this.src='images/inicio.png'" onclick="window.open('panel.php','_top');" title='' alt='' /><img src="images/separador.gif" title='' alt='' /><img src="images/manual.png" onmouseover="this.src='images/manualon.png'" onmouseout="this.src='images/manual.png'" onclick="window.open('manual.php','_top');" title='' alt='' /><img src="images/separador.gif" title='' alt='' /><img src="images/datasheeton.png" title='' alt='' /><img src="images/trans.gif" title='' alt='' /><img src="images/trans.gif" title='' alt='' /><img src="images/acerca.png" onmouseover="this.src='images/acercaon.png'" onmouseout="this.src='images/acerca.png'" onclick="window.open('acercade.php','_top');" title='' alt='' /><img src="images/separador.gif" title='' alt='' /><img src="images/salir.png" onmouseover="this.src='images/saliron.png'" onmouseout="this.src='images/salir.png'" title='' alt='' onclick="window.open('salir.php','_top');" />
		</div>
	</div>
	
	<div id='contenido'>
		<div id='texto'>
		<h2>Datasheets</h2>
		<br/>
			 
		<span class='negro'>HIH-4030/31 SERIES Humidity Sensors Datasheet, Sparkfun Electronics</span>
		<br/>
		<a href='datasheets/SEN-09569-HIH-4030.pdf' target='_blank'>SEN-09569-HIH-4030.pdf </a>
		<br/><br/>

		<span class='negro'>LM335 Precision Centigrade Temperature Sensors Datasheet, National Semiconductor</span>
		<br/>
		<a href='datasheets/LM335.pdf' target='_blank'>LM335.pdf</a>
		<br/><br/>

		<span class='negro'>PIC18F4585 Datasheet, Microchip</span>
		<br/>
		<a href='datasheets/39625c.pdf' target='_blank'>PIC18F4585.pdf</a>
		<br/><br/>

		<span class='negro'>Pantalla LCD HD44780 Datsheet (HITACHI), Sparkfun Electronics</span>
		<br/>
		<a href='datasheets/HD44780.pdf' target='_blank'>HD44780.pdf</a>
		<br/><br/>
		
		<span class='negro'>MAX232 Datasheet, Datasheet Catalog (Texas Instruments)</span>
		<br/>
		<a href='datasheets/max232.pdf' target='_blank'>max232.pdf</a>
		<br/><br/>	
		</div>

	</div>
</div>
</body>
</html>
