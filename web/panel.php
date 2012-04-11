<?php 
require_once("inc/token.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"  />
<link rel="shortcut icon" href="favicon.ico" />
<title>SAI-Inicio</title>
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

function reloadImg(id) {
   var obj = document.getElementById(id);
   var src = obj.src;
   var pos = src.indexOf('?');
   if (pos >= 0) {
      src = src.substr(0, pos);
   }
   var date = new Date();
   obj.src = src + '?v=' + date.getTime();
   return false;
}
setTimeout("ajaxFunction()", 10000 ); 

//Browser Support Code
function ajaxFunction(){
	setTimeout("ajaxFunction()", 10000 );
        var ajaxRequest;  // The variable that makes Ajax possible!
        try{
                // Opera 8.0+, Firefox, Safari
                ajaxRequest = new XMLHttpRequest();
        } catch (e){
                // Internet Explorer Browsers
                try{
                        ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                        try{
                                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e){
                                // Something went wrong
                                alert("Your browser broke!");
                                return false;
                        }
                }
        }
        // Create a function that will receive data sent from the server
        ajaxRequest.onreadystatechange = function(){
                if(ajaxRequest.readyState == 4){
                        var ajaxDisplay = document.getElementById('texto');
			response_string = ajaxRequest.responseText;
			str_arr = response_string.split("#*#");
			ajaxDisplay.innerHTML = str_arr[0];
			if ( str_arr[1] == 0 )
				document.getElementById('luzimg').src="images/on.png";
			else
				document.getElementById('luzimg').src="images/off.png";
			if ( str_arr[2] == 0 )
				document.getElementById('venimg').src="images/on.png";
			else
				document.getElementById('venimg').src="images/off.png";
			if ( str_arr[3] == 0 )
				document.getElementById('bomimg').src="images/on.png";
			else
				document.getElementById('bomimg').src="images/off.png";
			reloadImg('imggraph');
			reloadImg('imggraph2');
                        //document.myForm.time.value = ajaxRequest.responseText;
                }
		
        }
        ajaxRequest.open("GET", "ajax-graph.php", true);
        ajaxRequest.send(null); 
}

</script>
</head>
<body onload='ajaxFunction()'>
<div id='mainc'>
	<div id='top'>
	</div>
	<div id='mbottom'>
		<div id='menu'>
	<img src="images/inicioon.png" title='' alt='' /><img src="images/separador.gif" title='' alt='' />
	<img src="images/manual.png" onmouseover="this.src='images/manualon.png'" onmouseout="this.src='images/manual.png'" onclick="window.open('manual.php','_top');" title='' alt='' />
	<img src="images/separador.gif" title='' alt='' />
	<img src="images/datasheet.png" onmouseover="this.src='images/datasheeton.png'" onmouseout="this.src='images/datasheet.png'" onclick="window.open('datasheet.php','_top');" title='' alt='' />
	<img src="images/trans.gif" title='' alt='' />
	<img src="images/trans.gif" title='' alt='' />
	<img src="images/acerca.png" onmouseover="this.src='images/acercaon.png'" onmouseout="this.src='images/acerca.png'" onclick="window.open('acercade.php','_top');" title='' alt='' />
	<img src="images/separador.gif" title='' alt='' />
	<img src="images/salir.png" onmouseover="this.src='images/saliron.png'" onmouseout="this.src='images/salir.png'" title='' alt='' onclick="window.open('salir.php','_top');" />
		</div>
	</div>
	
	<div id='contenido' align='center' >
	<div id='status'>
		<hr />
		<div id='luz'>Luz&nbsp;<img id='luzimg' src="images/off.png" width=25 heigth=25 /></div>
		<div id='ventilador'>Ventilador&nbsp;<img id='venimg' src="images/off.png" width=25 heigth=25 /></div>
		<div id='bomba'>Bomba&nbsp;<img id='bomimg' src="images/off.png" width=25 heigth=25 /></div>
		<hr />
	</div>
		<div id='texto'>
			
		</div>

	</div>
</div>
</body>
</html>
