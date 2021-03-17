<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class RankingController extends AbstractController
{
    /**
     * @Route("/ranking", name="ranking")
     */
    public function Ranking(): Response
    {
        $tablica = array(
            array('1', '100','Jakub', 'A', 'Wrocław', 'A'),
            array('2', '98','Anna', 'B', 'Szczecin', 'B'),
            array('3', '93','Kacper', 'C', 'Wrocław', 'B'),
            array('4', '80','Oliwia', 'D', 'Wrocław', 'C'),
            array('5', '50','Karol', 'E', 'Wrocław', 'B'),
            array('6', '42','Jakub', 'F', 'Szczecin', 'A'),
            array('7', '40','Anna', 'G', 'Szczecin', 'A'),
            array('8', '35','Karol', 'H', 'Wrocław', 'C'),
            array('9', '30','Anna', 'I', 'Szczecin', 'B'),
            array('10', '10','Kacper', 'J', 'Szczecin', 'C'),
            array('11', '0','Karol', 'K', 'Wrocław', 'A'),
            array('12', '0','Jakub', 'L', 'Wrocław', 'C')     
        );

        return $this->render('ranking/index.html.twig', [
            'tablica'=> $tablica
        ]);
    }
}
