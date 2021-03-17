<?php
    header( "Cache-Control: max-age=-1" );
    $login = $_GET["login"];
    $haslo = $_GET["haslo"];
    $haslo_2 = $_GET["haslo_2"];
    
    $poprawne = true;;
    if (($login =="") || ($haslo =="")) 
    {
        echo "Login lub/i hasło nie mogą być puste!";
        $poprawne = false;
    }
    else {
        if (strlen($haslo) < 4) 
        {
            echo " Hasło musi mieć ponad 4 znaki!";
            $poprawne = false;
        }
        if (strtolower($haslo)==$haslo) 
        {
            echo " Hasło musi zawierać wielką litere! ";
            $poprawne = false;
        }
        if ($haslo!=$haslo_2) {
            echo " Hasła muszą się zgadzać! ";
            $poprawne = false;
        }
    }

    if ($poprawne) 
    {
        echo "Sukces! Dane prawidłowe";
    }
?>
