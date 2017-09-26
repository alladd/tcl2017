pragma solidity ^0.4.0;

contract Trader {

    enum State    { Standby, Signed, Calculated }      //      상태 : 대기, 체결, 정산종료
    enum Option   { Increase, Decrease}                //      옵션 : 상승, 하락

  struct OrderBook{
    uint      orderID;                                //      주문번호
    State     state;                                  //      상태
    mapping   (address => Order)  incOrder;           //      int주문
    mapping   (address => Order)  decOrder;           //      dec주문
    int       standbyPrice;                           //      생성시세
    int       standbyTime;
    int       signedPrice;
    int       signedTime;
    int       calcuatedPrice;
    int       calcuatedTime;
    int       incCalcQty;
    int       decCalcQty;
  }



  struct Order {
    address   orderAddress;
    int       orderID;
    State     state;
    Option    option;
    int       orderQty;
    int       contractTerm;
    int       createTime;
  }


  function createOrder(     address orderAddress,
                            uint    orderID,
                            State  state,
                            Option  option){
                            }
}
