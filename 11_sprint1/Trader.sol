pragma solidity ^0.4.0;

contract Trader {

     // 거래체결시점 Values
     string  public incOption;
     address public incAddress;
     int     public incBaseEthPrice;

     string  public decOption;
     address public decAddress;
     int     public decBaseEthPrice;

     int     public startMarketPrice;
     int     public endMarketPrice;

     // 정산시점
     //string  public out_MarketType;      //상승장-하락장구분
     int     public out_settleEthBalance;  //종료시점 배분수량 계산
     int     public out_incEthBalance;     //increase Eth
     int     public out_decEthBalance;     //decrease Eth

     //************************************************************************
     //incOption
     //************************************************************************
     function setInputTrade(string _incOption,
                           // address _incAddress,
                            int _incBaseEthPrice,
                            string _decOption,
                            // address _decAddress,
                            int _decBaseEthPrice,
                            int _startMarketPrice,
                            int _endMarketPrice  )
     {
         incOption        = _incOption;
//       incAddress       = _incAddress;
         incBaseEthPrice  = _incBaseEthPrice;
         decOption        = _decOption;
//       decAddress       = _decAddress;
         decBaseEthPrice  = _decBaseEthPrice;
         startMarketPrice = _startMarketPrice;
         endMarketPrice   = _endMarketPrice;

         //상승장-하락장 구분
         if(startMarketPrice-endMarketPrice < 0)
         {
             //out_MarketType = "상승장";
             //                 [ (Eth(1000) * (15000-10000))/ Eth(1000) * 15000] *100  = 333.33
             // 소수점 둘째자리 처리
             out_settleEthBalance = (incBaseEthPrice*(endMarketPrice-startMarketPrice)/(incBaseEthPrice*endMarketPrice))*100;
             out_incEthBalance = incBaseEthPrice + out_settleEthBalance;
             out_decEthBalance = decBaseEthPrice - out_settleEthBalance;
         }
         else if(startMarketPrice-endMarketPrice > 0)
         {
             //out_MarketType = "하락장";
             //                 [(Eth(1000) *(10000-7000)) / Eth(1000) * 7000 ] * 100 = 428.571XXXXXXX
             out_settleEthBalance = (decBaseEthPrice*(startMarketPrice-endMarketPrice)/(decBaseEthPrice*endMarketPrice))*100;
             out_incEthBalance = incBaseEthPrice - out_settleEthBalance;
             out_decEthBalance = decBaseEthPrice + out_settleEthBalance;

         }
         else{
           //상증장도 하락장도 아닌 고정값
           //return 0;
         }

         setOutIncEthBalance(out_incEthBalance);
         setOutDecEthBalance(out_decEthBalance);
     }

     function getIncBaseEthPrice() constant returns (int) {
         return incBaseEthPrice;
     }


     function getDecBaseEthPrice() constant returns (int) {
         return decBaseEthPrice;
     }

     function getStartMarketPrice() constant returns (int) {
         return startMarketPrice;
     }

     function getEndMarketPrice() constant returns (int) {
         return endMarketPrice;
     }



     function setOutSettleEthBalance(int _out_settleEthBalance)
     {
       out_settleEthBalance = _out_settleEthBalance;
     }

     function getOutSettleEthBalance() constant returns (int)
     {
        return out_settleEthBalance;
     }

     function setOutIncEthBalance(int _out_incEthBalance)
     {
       out_incEthBalance = _out_incEthBalance;
     }

     function getOutIncEthBalance() constant returns (int)
     {
         return out_incEthBalance;
     }

     function setOutDecEthBalance(int _out_decEthBalance)
     {
       out_decEthBalance = _out_decEthBalance;
     }

     function getOutDecEthBalance() constant returns (int)
     {
        return out_decEthBalance;
     }

//incAddress.transfer(incBaseEthPrice);
//decAddress.transfer(decBaseEthPrice);

}
