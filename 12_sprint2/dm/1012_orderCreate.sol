pragma solidity ^0.4.0;

contract TraderMarket {

    /**
      Definition - Struct, Enum, etc
    */
    enum State    { Created, Signed, Calculated }      //      상태 : 대기, 체결, 정산종료
    enum Option   { Invest, Hedge }                    //      옵션 : 투자, 회피

    struct OrderBook{
      uint       orderID;                                //      주문번호
      State      state;                                  //      상태
      address    investor;                               //      investor주문
      address    hedger;                                 //      hedger주문
      uint       timelimit;                              //      예치기간
      uint       createdPrice;                           //      생성시세
      uint       createdTime;                            //      생성시간
      uint       signedPrice;                            //      체결시세
      uint       signedTime;                             //      체결시세
      uint       calcuatedPrice;                         //      정산시세
      uint       calcuatedTime;                          //      정산시간
      uint       qtyTotalDeposit;                        //      총예치수량
      int        qtyInvestor;                            //      투자자정산수량
      int        qtyHedger;                              //      회피자정산수량
    }

    /**
      State Variables
    */
    uint       numOrderBook;                             //      주문대장갯수
    mapping (uint => OrderBook) public orderbooks;              //      주문대장

    address   admin;                                    //      contract 생성자

    /**
      Event
    */
    event commonMsg(string _msg);



    /**
      Function
    */
    function TraderMarket() {
      admin = msg.sender;
    }

    function getOrderInf(uint orderIndex) constant returns (uint, uint) {
        return (orderbooks[orderIndex].timelimit, orderbooks[orderIndex].createdPrice);
    }

    function getNumOrderBook() constant returns (uint) {
        return numOrderBook;
    }


    function createOrderBook( Option  _option, uint _timelimit, uint _createdPrice ) payable returns ( uint _orderID ){

      _orderID = numOrderBook++;
      orderbooks[_orderID].orderID = _orderID;
      orderbooks[_orderID].state   = State.Created;
      if( _option == Option.Invest){
        orderbooks[_orderID].investor = msg.sender;
      }
      else{
        orderbooks[_orderID].hedger = msg.sender;
      }
      orderbooks[_orderID].qtyTotalDeposit += msg.value;
      orderbooks[_orderID].timelimit = _timelimit;
      orderbooks[_orderID].createdTime = now;
      orderbooks[_orderID].createdPrice = _createdPrice;

    }

    function signOrderBook( ) payable {

    }

    function calcuateOrderBook( ) payable {

    }


}
