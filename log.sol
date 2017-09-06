pragma solidity ^0.4.11;

contract Negs {

  event Print(string _name, uint _value);

  function Test() {
    var startValue = 1000;
    var endValue = 800;

    Print ("Change1 - ", endValue / startValue / 100);
    Print ("Change2 - ", 10*endValue / startValue);
    Print ("Change3 - ", 100*endValue / startValue);
    Print ("Change4 - ", 1000*endValue / startValue);
    Print ("12312415", 100);

  }

}
