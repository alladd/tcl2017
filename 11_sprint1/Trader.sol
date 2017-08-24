pragma solidity ^0.4.0;

contract Trader {

     // 거래체결시점 Values
     string  public incOption;
     address incAddress;
     uint256 public incBaseEthPrice;

     string  public decOption;
     address decAddress;
     uint256 public decBaseEthPrice;

     uint256 public startKrwPrice;    //원화환산금액
     uint256 public startMarketPrice;
     uint256 public endMarketPrice;

     // 정산시점
     string  public out_MarketType;      //상승장-하락장구분
     uint256 public out_SettleEthPrice;  //종료시점 배분수량 계산
     uint256 public out_incKrwBalance;   //increase 원화환산금액
     uint256 public out_decKrwBalance;   //decrease 원화환산금액


     //************************************************************************
     //incOption
     //************************************************************************
     function setIncOption(string _incOption) {
         incOption = _incOption;
     }

     function getIncOption() constant returns (string) {
         return incOption;
     }

     //incAddress
     function setIncAddress(address _incAddress) {
         incAddress = _incAddress;
     }

     function getIncAddress() constant returns (address) {
         return incAddress;
     }

     //incBasePrice
     function setIncBaseEthPrice(uint256 _incBaseEthPrice) {
         incBaseEthPrice = _incBaseEthPrice;
     }

     function getIncBaseEthPrice() constant returns (uint256) {
         return incBaseEthPrice;
     }

     //************************************************************************
     //decOption
     //************************************************************************
     function setDecOption(string _decOption) {
         decOption = _decOption;
     }

     function getDecOption() constant returns (string) {
         return decOption;
     }

     //decAddress
     function setDecAddress(address _decAddress) {
         decAddress = _decAddress;
     }

     function getDecAddress() constant returns (address) {
         return decAddress;
     }

     //decBasePrice
     function setDecBaseEthPrice(uint256 _decBaseEthPrice) {
         decBaseEthPrice = _decBaseEthPrice;
     }

     function getDecBaseEthPrice() constant returns (uint256) {
         return decBaseEthPrice;
     }

     //startPrice
     function setStartMarketPrice(uint256 _startMarketPrice) {
         startMarketPrice = _startMarketPrice;
     }

     function getStartMarketPrice() constant returns (uint256) {
         return startMarketPrice;
     }

     //endPrice
     function setEndMarketPrice(uint256 _endMarketPrice) {
         endMarketPrice = _endMarketPrice;
     }

     function getEndMarketPrice() constant returns (uint256) {
         return endMarketPrice;
     }

     //정산처리
     function setSettlementCalculation()
     {
         //상승장-하락장 구분
         if(startMarketPrice-endMarketPrice < 0)
         {
             out_MarketType = "상승장";
             //                 [ (Eth(1000) * (15000-10000))/ Eth(1000) * 15000] *100  = 333.33
             // 소수점 둘째자리 처리
             out_SettleEthPrice = (incBaseEthPrice*(endMarketPrice-startMarketPrice)/(incBaseEthPrice*endMarketPrice))*100;
             incBaseEthPrice = incBaseEthPrice + out_SettleEthPrice;
             decBaseEthPrice = decBaseEthPrice - out_SettleEthPrice;

             //각각의 Balance변동 처리 필요!!

         }
         else if(startMarketPrice-endMarketPrice > 0)
         {
             out_MarketType = "하락장";
             //                 [(Eth(1000) *(10000-7000)) / Eth(1000) * 7000 ] * 100 = 428.571XXXXXXX
             out_SettleEthPrice = (decBaseEthPrice*(startMarketPrice-endMarketPrice)/(decBaseEthPrice*endMarketPrice))*100;
             incBaseEthPrice = incBaseEthPrice - out_SettleEthPrice;
             decBaseEthPrice = decBaseEthPrice + out_SettleEthPrice;

             //각각의 Balance변동 처리 필요!!
         }
         else{
           //상증장도 하락장도 아닌 고정값
           //return 0;
         }

incAddress.transfer(incBaseEthPrice);
decAddress.transfer(desBaseEthPrice);

         out_incKrwBalance = incBaseEthPrice * endMarketPrice;
         out_decKrwBalance = decBaseEthPrice * endMarketPrice;
     }


}
