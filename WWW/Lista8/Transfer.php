<?php

namespace App\Entity;

class Transfer
{
    private $id;

    /**
     * @Assert\Regex("^[0-9]{26}$")
     */
    private $accTo;

    /**
     * @Assert\Regex("^[0-9]{2}12349876[0-9]{16}$")
     */
    private $accFrom;

    /**
     * @Assert\NotBlank(message="Pole nie może być puste")
     * @Assert\Length(max=40)            
     */
    private $firstname;

    /**
     * @Assert\NotBlank(message="Pole nie może być puste")
     * @Assert\Length(
     *     min=3,
     *     minMessage="Za krótkie",
     *     max=40,
     *     maxMessage="Za długie"
     * )
     */
    private $lastname;

    /**
     * @Assert\NotBlank(message="Pole nie może być puste")
     * @Assert\Length(
     *      max=40,
     *      maxMessage="Za długie"
     * )
     */
    private $street;

    /**
     * @Assert\NotBlank(message="Pole nie może być puste")
     * @Assert\Length(
     *      max=40,
     *      maxMessage="Za długie"
     * )
     */
    private $city;

    /**
     * @Assert\Type("^[0-9]+(\.[0-9]{1,2})?$")
     */
    private $val;

    /**
     * @Assert\Type('date') 
     */
    private $exDate;

    /**
     * @Assert\Regex("\^[0-9]{2}-[0-9]{3}$")
     */
    private $postCode;

    /**
     * @Assert\NotBlank(message="Pole nie może być puste")
     * @Assert\Length(
     *      max=40,
     *      maxMessage="Za długie"
     * )
     */
    private $title;

    public function getId()
    {
        return $this->id;
    }

    public function getaccTo()
    {
        return $this->accTo;
    }

    public function getaccFrom()
    {
        return $this->accFrom;
    }

    public function getexDate()
    {
        return $this->exDate;
    }

    public function getCity()
    {
        return $this->city;
    }

    public function getpostCode()
    {
        return $this->postCode;
    }

    public function getVal()
    {
        return $this->val;
    }

    public function getstreet()
    {
        return $this->street;
    }

    public function getFirstname()
    {
        return $this->firstname;
    }

    public function getLastname()
    {
        return $this->lastname;
    }
}
