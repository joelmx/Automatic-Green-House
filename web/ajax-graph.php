<?php

/***************/
/* INVERNADERO */
/***************/


/* pChart library inclusions */
include("class/pData.class.php");
include("class/pDraw.class.php");
include("class/pImage.class.php");

$dbhost = "localhost";
$dbuser = "micros";
$dbpass = "micros";
$dbname = "micros";
	//Connect to MySQL Server
mysql_connect($dbhost, $dbuser, $dbpass);
	//Select Database
mysql_select_db($dbname) or die(mysql_error());
	//build query
$query = "SELECT * FROM GreenHouse ORDER BY id DESC LIMIT 0,20";
	//Execute query
$qry_result = mysql_query($query) or die(mysql_error());


	//Build Result String
$display_string = "<div id='graph'> <img id='imggraph' src='images/chart.png' /><img id='imggraph2' src='images/chart2.png' /></div>";
$display_string .= "<table>";
$display_string .= "<tr>";
$display_string .= "<th>Curr Temp</th>";
$display_string .= "<th>Curr Hum</th>";
$display_string .= "<th>Time</th>";
$display_string .= "</tr>";

$arrt= array();
$arrh= array();
$arrtime = array();
//$row = array();

$display_string2 = "";

for ( $i = 0; $i < 20; $i++) {
	$row = mysql_fetch_array($qry_result);
	if ( $i == 0 ) {
		if ($row['curtmp'] < $row['mintmp'] )
		$display_string2 .= "#*#0"; // luz encendida
	else
		$display_string2 .= "#*#1"; // luz apagada
	if ($row['curtmp'] > $row['maxtmp'] )
		$display_string2 .= "#*#0"; //vent encendido 
	else
		$display_string2 .= "#*#1"; // luz apagada
	if ($row['curhum'] < 35 )
		$display_string2 .= "#*#0"; // bomaba encendida 
	else
		$display_string2 .= "#*#1"; // luz apagada
	}
	array_push($arrt, $row['curtmp'] );	
	array_push($arrh, $row['curhum'] );	
	array_push($arrtime, $row['curtime'] );	
	$display_string .= "<tr>";
	$display_string .= "<td>$row[curtmp]</td>";
	$display_string .= "<td>$row[curhum]</td>";
	$display_string .= "<td>$row[curtime]</td>";
	$display_string .= "</tr>";
}

/*
	// Insert a new row in the table for each person returned
while($row = mysql_fetch_array($qry_result)){
	array_push($arrt, $row['curtmp'] );	
	array_push($arrh, $row['curhum'] );	
	array_push($arrtime, $row['curtime'] );	
	$display_string .= "<tr>";
	$display_string .= "<td>$row[curtmp]</td>";
	$display_string .= "<td>$row[curhum]</td>";
	$display_string .= "<td>$row[curtime]</td>";
	$display_string .= "</tr>";
}*/

$display_string .= "</table>". $display_string2;
// order = luz, vent, bombda

$arrt = array_reverse($arrt);
$arrh = array_reverse($arrh);
$arrtime = array_reverse($arrtime);


 $MyData = new pData();
 $MyData->addPoints($arrt, "Temp");
 $MyData->setAxisName(0,"Temperaturas");
 $MyData->addPoints($arrtime, "Labels");
 $MyData->setSerieDescription("Labels", "Tiempo");
 $MyData->setAbscissa("Labels");

/* Create the pChart object */
 $myPicture = new pImage(700,230,$MyData);

 /* Turn of Antialiasing */
 $myPicture->Antialias = FALSE;

 /* Add a border to the picture */
 $myPicture->drawRectangle(0,0,699,229,array("R"=>0,"G"=>0,"B"=>0));

 /* Write the chart title */
 $myPicture->setFontProperties(array("FontName"=>"fonts/Forgotte.ttf","FontSize"=>11));
 $myPicture->drawText(150,35,"Temperatura del SAI",array("FontSize"=>20,"Align"=>TEXT_ALIGN_BOTTOMMIDDLE));

 /* Set the default font */
 $myPicture->setFontProperties(array("FontName"=>"fonts/pf_arma_five.ttf","FontSize"=>6));

 /* Define the chart area */
 $myPicture->setGraphArea(60,40,650,200);

 /* Draw the scale */
 $scaleSettings = array("XMargin"=>10,"YMargin"=>10,"Floating"=>TRUE,"GridR"=>200,"GridG"=>200,"GridB"=>200,"DrawSubTicks"=>TRUE,"CycleBackground"=>TRUE);
 $myPicture->drawScale($scaleSettings);

 /* Turn on Antialiasing */
 $myPicture->Antialias = TRUE;

 /* Draw the line chart */
 $myPicture->drawLineChart();

 /* Write the chart legend */
 $myPicture->drawLegend(540,20,array("Style"=>LEGEND_NOBORDER,"Mode"=>LEGEND_HORIZONTAL));

 /* Render the picture (choose the best way) */
 $myPicture->render("images/chart.png");

 $MyData2 = new pData();
 $MyData2->addPoints($arrh, "Humedad");
 $MyData2->setAxisName(0,"Humedad");
 $MyData2->addPoints($arrtime, "Labels");
 $MyData2->setSerieDescription("Labels", "Tiempo");
 $MyData2->setAbscissa("Labels");

/* Create the pChart object */
 $myPicture = new pImage(700,230,$MyData2);

 /* Turn of Antialiasing */
 $myPicture->Antialias = FALSE;

 /* Add a border to the picture */
 $myPicture->drawRectangle(0,0,699,229,array("R"=>0,"G"=>0,"B"=>0));

 /* Write the chart title */
 $myPicture->setFontProperties(array("FontName"=>"fonts/Forgotte.ttf","FontSize"=>11));
 $myPicture->drawText(150,35,"Humedad del SAI",array("FontSize"=>20,"Align"=>TEXT_ALIGN_BOTTOMMIDDLE));

 /* Set the default font */
 $myPicture->setFontProperties(array("FontName"=>"fonts/pf_arma_five.ttf","FontSize"=>6));

 /* Define the chart area */
 $myPicture->setGraphArea(60,40,650,200);

 /* Draw the scale */
 $scaleSettings = array("XMargin"=>10,"YMargin"=>10,"Floating"=>TRUE,"GridR"=>200,"GridG"=>200,"GridB"=>200,"DrawSubTicks"=>TRUE,"CycleBackground"=>TRUE);
 $myPicture->drawScale($scaleSettings);

 /* Turn on Antialiasing */
 $myPicture->Antialias = TRUE;

 /* Draw the line chart */
 $myPicture->drawLineChart();

 /* Write the chart legend */
 $myPicture->drawLegend(540,20,array("Style"=>LEGEND_NOBORDER,"Mode"=>LEGEND_HORIZONTAL));

 /* Render the picture (choose the best way) */
 $myPicture->render("images/chart2.png");


//echo "Query: " . $query . "<br />";
//$display_string .= "</table>";
//$display_string .= "<div id='graph'> <img src='images/chart.png' /></div>";
echo $display_string;
?>
