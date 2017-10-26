pragma solidity ^0.4.0;

contract TraderMarket {

    /**
      Definition - Struct, Enum, etc
    */
    enum State    { Created, Signed, Calculated, Cancel }      //      상태 : 체결대기 0, 체결 1, 정산완료 2 , 취소 3
    enum Option   { Invest, Hedge }                            //      옵션 : 투자, 회피


    struct OrderBook{
      uint       orderID;                                //      주문번호
      State      state;                                  //      상태
      address    investor;                               //      investor주문
      address    hedger;                                 //      hedger주문
      uint       timelimit;                              //      예치기간
      //uint       createdPrice;                           //      생성시세
      //uint       createdTime;                            //      생성시간
      uint       signedPrice;                            //      체결시세
      uint       signedTime;                             //      체결시세
      uint       calcuatedPrice;                         //      정산시세
      uint       calcuatedTime;                          //      정산시간
      uint       qtyTotalDeposit;                        //      총예치수량
      uint       qtyInvestor;                            //      투자자정산수량
      uint       qtyHedger;                              //      회피자정산수량
      uint       qtyFee;                                 //      수수료( 전체 예치수량의 1% )
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
    event commonMsg(string _msg, uint _qty);


    /**
      Modifier
      ADMIN 권한 체크 modifier
    */
    modifier ifAdmin(){
      if(admin != msg.sender){
        throw;
      }else{
        _;
      }
    }

    /**
      Function
    */
    function TraderMarket() {
      admin = msg.sender;
    }

    /**
        신규주문을 생성한다
        @param  _option         : 선택옵션 Option.Invest(0), Option.Hedge(1)
                _timelimit      : 주문생성일( now + _timelimit days)
                _signedPrice   : 생성시점 eth/krw 시세
    */
    function createOrderBook( Option  _option, uint _timelimit, uint _signedPrice ) payable returns ( uint _orderID ){

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
      orderbooks[_orderID].signedTime = now;
      orderbooks[_orderID].signedPrice = _signedPrice;

      commonMsg( '주문생성이 정상 처리되었습니다.', msg.value);
      return _orderID;

    }

    /**
        채결대기주문(orderID)을 전달받아 주문 체결 한다.
        @param  _orderID        : 체결대기 상태의 orderID
                _signedPrice    : 체결시점 eth/krw 시세

        tobeadded : 동일주소 주문 에러체크
                    체결대기상태 체크
                    orderid정합성 체크

    */
    function signOrderBook( uint _orderID, uint _signedPrice) payable returns ( uint ){

      orderbooks[_orderID].state   = State.Signed;
      if( orderbooks[_orderID].investor > 0x0){
        orderbooks[_orderID].hedger = msg.sender;
      }
      else{
        orderbooks[_orderID].investor = msg.sender;
      }
      orderbooks[_orderID].qtyTotalDeposit += msg.value;
      orderbooks[_orderID].signedTime = now;
      orderbooks[_orderID].signedPrice = _signedPrice;

      commonMsg( '주문체결이 정상 처리되었습니다.', msg.value);
      return _orderID;

    }

    /**
     정산 function
     simulation about Proof of calc(in solidity)
    */
    function calcuateOrderBook( uint _calcuatedPrice) payable {

        for( uint i = 0 ;  i < numOrderBook ; i++){

            if( orderbooks[i].timelimit < now  &&                     //정산만기가 도래했으며
                orderbooks[i].state    == State.Signed                //체결 상태이면
                ){


                  // 1. 정산가, 정산시기 set
                  orderbooks[i].calcuatedPrice = _calcuatedPrice;
                  orderbooks[i].calcuatedTime = now;


                  // 2. investor/hedger/fee 각각 수량 산출
                  if( orderbooks[i].signedPrice != orderbooks[i].calcuatedPrice){

                    //상승장, 하락장 산출 로직 동일함.
                    // Hedger의 eth수량 산출 : 체결당시 원화가치에 해당하는 eth수량을 산출
                    // Invester의 eth수량 = qtyTotalDeposit - 산출된 Hedgert수량
                    // qtyHedger = ( signedPrice * (orderbooks[_orderID].qtyTotalDeposit / 2) ) / calcuatedPrice
                    orderbooks[i].qtyFee          =   orderbooks[i].qtyTotalDeposit/100;          // 수수료1% 산출
                    orderbooks[i].qtyTotalDeposit -=  orderbooks[i].qtyFee;                   // 수수료 제외 전체 예치수량 재 산출
                    orderbooks[i].qtyHedger       = ( orderbooks[i].signedPrice * (orderbooks[i].qtyTotalDeposit/2) ) /  orderbooks[i].calcuatedPrice;
                    orderbooks[i].qtyInvestor     =   orderbooks[i].qtyTotalDeposit - orderbooks[i].qtyHedger;

                  }else{
                     // nothing to do 시가종가 동일하여 정산되지 않을경우 수수료 부가하지 않음
                     orderbooks[i].qtyHedger       = orderbooks[i].qtyTotalDeposit/2;
                     orderbooks[i].qtyInvestor     = orderbooks[i].qtyTotalDeposit/2;
                  }


                  // 3. 각 Account로 Ether Transfer
                  orderbooks[i].hedger.transfer( orderbooks[i].qtyHedger);      //hedger 전송
                  orderbooks[i].investor.transfer( orderbooks[i].qtyInvestor);  //investor 전송


                  // 4. 상태변경
                  orderbooks[i].state = State.Calculated;                       // 정산완료

                  commonMsg( '주문정산이 정상 처리 되었습니다. orderID', orderbooks[i].orderID);
            }
        }

    }


    /**
        주문대장 건수 조회
    */
    function getOrderBookCount() public constant returns( uint ) {
      return numOrderBook;
    }


    /*
        주문대장 1건 조회
        성능상 목적으로 16 localvariable per function 제약이 있으므로 메소드를 2건으로 분리함,
        @param  _orderID        : 체결대기 상태의 orderID
        @return

                getOrderBook
                 orderbooks[_orderID].state                                     //      주문상태
                 ,orderbooks[_orderID].investor                                 //      investor주문
                 ,orderbooks[_orderID].hedger                                   //      hedger주문
                 ,orderbooks[_orderID].signedPrice                              //      생성시세
                 ,orderbooks[_orderID].signedTime                              //      생성시간

                getOrderBookDetail
                 ,orderbooks[_orderID].timelimit                                //      예치기간
                 ,orderbooks[_orderID].calcuatedPrice                           //      정산시세
                 ,orderbooks[_orderID].calcuatedTime                            //      정산시간
                 ,orderbooks[_orderID].qtyTotalDeposit                          //      총예치수량
                 ,orderbooks[_orderID].qtyInvestor                              //      투자자정산수량
                 ,orderbooks[_orderID].qtyHedger                                //      회피자정산수량
    */
    function getOrderBook(uint _orderID) public constant returns( TraderMarket.State, address, address , uint, uint) {
      return ( orderbooks[_orderID].state ,
               orderbooks[_orderID].investor ,
               orderbooks[_orderID].hedger  ,
               orderbooks[_orderID].signedPrice ,
               orderbooks[_orderID].signedTime );
     }

     function getOrderBookDetail(uint _orderID) public constant returns(  uint, uint, uint, uint, uint) {
       return ( orderbooks[_orderID].timelimit,
                orderbooks[_orderID].calcuatedPrice ,
                orderbooks[_orderID].calcuatedTime ,
                orderbooks[_orderID].qtyTotalDeposit,
                orderbooks[_orderID].qtyInvestor   );
      }

      function getOrderBookDetail_2nd(uint _orderID) public constant returns(  uint, uint) {
        return ( orderbooks[_orderID].orderID,
                 orderbooks[_orderID].qtyHedger  );
      }

}
