<?php
$IsPostFormData = (isset($_POST["sent"]) && ($_POST["sent"] == "y"));
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <title>Dane osobowe</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style type="text/css">
        td,
        th,
        body {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 10pt;
        }
    </style>
</head>

<body>

    <h3 align="center">Dane osobowe</h3>

    <form name="dane" action="dane2.php" method="post">
        <table align="center" cellpadding="4" cellspacing="2" border="0" bgcolor="#FF9900">
            <tr>
                <th align="left">Imię:</th>
                <td><input name="imie" type="text" size="15" maxlength="20" value=""></td>
            </tr>
            <tr>
                <th align="left">Nazwisko:</th>
                <td><input name="nazwisko" type="text" size="15" maxlength="20" value=""></td>
            </tr>
            <tr>
                <th align="left">Email:</th>
                <td><input name="email" type="text" size="20" maxlength="50" value=""></td>
            </tr>
            <tr>
                <th align="left">Numer telefonu:</th>
                <td><input name="telefon" type="text" size="10" maxlength="9" value=""></td>
            </tr>
            <tr>
                <th align="left">Numer karty:</th>
                <td><input name="nrkarty" type="text" size="11" maxlength="16" value=""></td>
            </tr>
            <tr>
                <th align="left">Kod CVC: </th>
                <td><input name="cvc" type="text" size="11" maxlength="3" value=""></td>
            </tr>
            <tr>
                <th align="left">Kwota:</th>
                <td><input name="kwota" type="text" size="11" maxlength="10000" value=""> </td>
            </tr>
            <tr>
                <td align="right" colspan="2"><input type="submit" value="Wyślij"></td>
            </tr>
        </table>
        <input name="sent" type="hidden" value="y">
    </form>
	<br>


    <?php

         $ValidateSuccess = validate($_POST["imie"], $_POST["nazwisko"], $_POST["email"], $_POST["telefon"], $_POST["nrkarty"], $_POST["cvc"], $_POST["kwota"]);

    if ($IsPostFormData && $ValidateSuccess) :
    ?>
        <table cellpadding="4" cellspacing="2" border="1" align="center">
            <tr>
                <th>Imię:</th>
                <td><?php echo $_POST["imie"]; ?></td>
            </tr>
            <tr>
                <th>Nazwisko:</th>
                <td><?php echo $_POST["nazwisko"]; ?></td>
            </tr>
            <tr>
                <th>Adres:</th>
                <td><?php echo $_POST["email"]; ?></td>
            </tr>
            <tr>
                <th>PESEL:</th>
                <td><?php echo $_POST["telefon"]; ?></td>
            </tr>
            <tr>
                <th>Płeć</th>
                <td><?php echo $_POST["nrkarty"]; ?></td>
            </tr>
            <tr>
                <th>Płeć</th>
                <td><?php echo $_POST["cvc"]; ?></td>
            </tr>
            <tr>
                <th>Płeć</th>
                <td><?php echo $_POST["kwota"]; ?></td>
            </tr>

        </table>
    <?php
		$error=" s";
    endif;
	if(!$ValidateSuccess):
    ?>
	<h1><?php $error ?> </h1>
	<?php 
		endif;
		?>

    <?php
    function validate($imie, $nazwisko, $email, $telefon, $nrkarty, $cvc, $kwota)
    {
        if (!(preg_match("/^([a-zA-Z' ]+)$/", $imie))) {
			$error= "Nieprawidłowe imie!";
            return false;
        }
        if (!(preg_match("/^([a-zA-Z' ]+)$/", $nazwisko))) {
			$error= "Nieprawidłowe nazwisko!";
            return false;
        }
        if (!(filter_var($email,FILTER_VALIDATE_EMAIL))) {
			$error= "Nieprawidłowy email!";
            return false;
        }
		if (!(preg_match("/^([0-9]{9})$/", $telefon))) {
			$error= "Nieprawidłowy telefon!";
            return false;
		}
		if (!(preg_match("/^([0-9]{16})$/", $nrkarty))) {
		    $error= "Nieprawidłowy nrkarty!";
            return false;
		}
		if (!(preg_match("/^([0-9]{3})$/", $cvc))) {
        	$error= "Nieprawidłowe cvc!";
		    return false;
		}
		if (!(preg_match("/^([0-9]+)$/", $kwota))) {
			$error= "Nieprawidłowa kwota!";
            return false;
		}
        return true;
    }
    ?>

</body>

</html>