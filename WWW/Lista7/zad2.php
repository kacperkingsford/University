<?php
    $IsPostFormData = (isset($_POST["sent"]) && ($_POST["sent"] == "y"));
    
    $cardNumber = "";
    $month = "";
    $year = "";
    $cvc = "";
    $name = "";
    $surname = "";
    $email = "";
    $telephoneNumber = "";
    $amount = "";

    if ($IsPostFormData) {
        $cardNumber = $_POST["cardNumber"];
        $month = $_POST["month"];
        $year = $_POST["year"];
        $cvc = $_POST["cvc"];
        $name = $_POST["name"];
        $surname = $_POST["surname"];
        $email = $_POST["email"];
        $telephoneNumber = $_POST["telephoneNumber"];
        $amount = $_POST["amount"];
    }

    function validate($var, $regex, $mess, &$flag) {
        if (!preg_match($regex, $var)) {
            $flag = false;
            echo $mess."<br>";
        }
    }
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Zadanie 2</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>

    <body>

        <h3>Zapłata kartą kredytową</h3>
    
        <div class="formContainer">
            <form name="dane" action="zad2.php" method="post">
               
                <label for="cardNumber">Numer karty </label>
                <input type="number" name="cardNumber" id="cardNumber" <?php echo "value=".$cardNumber; ?>><br>
                
                <label for="cardDate">Data ważności karty (miesiąc/rok) </label>
                <input type="number" name="month" id="cardDate" <?php echo "value=".$month; ?>> /
                <input type="number" name="year" id="cardDate" <?php echo "value=".$year; ?>><br>
                
                <label for="cvc">CVC </label>
                <input type="number" name="cvc" id="cvc" <?php echo"value=".$cvc; ?>><br>

                <label for="cvc">Imię </label>
                <input type="text" name="name" id="name" <?php echo"value=".$name; ?>><br>

                <label for="surname">Nazwisko </label>
                <input type="text" name="surname" id="surname" <?php echo"value=".$surname; ?>><br>

                <label for="email">Email </label>
                <input type="email" name="email" id="email" <?php echo"value=".$email; ?>><br>

                <label for="telephoneNumber">Numer telefonu </label>
                <input type="number" name="telephoneNumber" id="telephoneNumber" <?php echo"value=".$telephoneNumber; ?>><br>

                <label for="amount">Kwota </label>
                <input type="number" name="amount" id="amount" <?php echo"value=".$amount; ?>><br>

                <input name="sent" type="hidden" value="y">
                <input type="submit" value="Wyślij">
            </form>
        </div>

        <?php
            $isValid = true;
            if ($IsPostFormData) :
        ?>

        <div class="formContainer">
            <?php
                validate($cardNumber, "/^[0-9]{16}$/", "Błędny number karty", $isValid);
                validate($month, "/^(0?[1-9]|1[012])$/", "Błędny miesiąc", $isValid);
                validate($year, "/^19[0-9]{2}|2[0-9]{3}$/", "Błędny rok", $isValid);
                validate($cvc, "/^[0-9]{3}$/", "Błędne cvc", $isValid);
                validate($name, "/^[^\s]+$/", "Błędne imię", $isValid);
                validate($surname, "/^[^\s]+$/", "Błędne nazwisko", $isValid);
                validate($telephoneNumber, "/^[0-9]{9}$/", "Błędny numer telefonu", $isValid);
                validate($amount, "/^[0-9]+$/", "Błędna kwota", $isValid);

                if ($isValid) 
                    echo "Wprowadzone dane są poprawne<br>";
            ?>
        </div>

        <?php
            endif;
        ?>
    </body>
</html>
