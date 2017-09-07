pragma solidity ^0.4.0;

contract Sprint1 {

    enum State    { Standby, Signed, Calculated }      //      상태 : 대기, 체결, 정산종료
    enum Option   { Increase, Decrease}                //      옵션 : 상승, 하락


  struct Order {
    address orderAddress;
    Option option;
  }

  struct OrderBook{
    uint      orderID;
    State     state;
    mapping   (address => Order)  incOrder;
    mapping   (address => Order)  decOrder;
    uint      standbyTime;
    uint      signedTime;
    uint      CalcuatedTime;

  }


  function createOrder(     address orderAddress,
                            uint    orderID,
                            State  state,
                            Option  option){
                            }
}
