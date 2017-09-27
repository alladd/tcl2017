pragma solidity ^0.4.0;

contract Trader {

    struct Person{
        uint old;
        uint tall;
        uint input;
    }

    mapping (address => Person) public persons;

    function setPerson(uint testNum){
       Person p = persons[msg.sender];
       p.old = 100;
       p.tall = 200;
       p.input = testNum;
    }

    function getPersonOld() constant returns (uint){
        Person p = persons[msg.sender];
        return p.old;
    }

    function getPersonInput() constant returns (uint){
        Person p = persons[msg.sender];
        return p.input;
    }
}
