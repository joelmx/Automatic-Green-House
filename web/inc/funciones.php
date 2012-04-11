<?php
function cleanInput($input) {
 
$search = array(
    '@<script[^>]*?>.*?</script>@si',   
    '@<[\/\!]*?[^<>]*?>@si',            
    '@<style[^>]*?>.*?</style>@siU',    
    '@<![\s\S]*?--[ \t\n\r]*>@'         
);
 
    $output = preg_replace($search, '', $input);
    return $output;
}
?>