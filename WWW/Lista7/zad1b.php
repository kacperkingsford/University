<?php 
	echo $_SERVER['SERVER_NAME'] . " <span style='color:blue'>Nazwa serwera</span><br>" ;
	echo $_SERVER['REQUEST_METHOD'] . " <span style='color:blue'>Metoda która została użyta</span><br>" ;
	echo $_SERVER['HTTP_ACCEPT_LANGUAGE'] . " <span style='color:blue'> Zawartość nagłówka Accept-Language</span><br>";
	echo $_SERVER['HTTP_ACCEPT'] . "<span style='color:blue'>Zawartość nagłówka Accept</span> <br>";
	echo $_SERVER['SERVER_PORT'] . "<span style='color:blue'>Numer portu serwera</span>";
 ?>

