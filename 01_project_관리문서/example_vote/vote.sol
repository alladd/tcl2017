pragma solidity ^0.4.0;

contract candidate {
    uint votecnt = 0;

    // 최종 득표수 관리
    function setvc(uint w)  payable {
        votecnt = votecnt+w;
    }

    function getvc() constant returns (uint) {
        return votecnt;
    }    
} 


contract vote {
    uint totalVoteCnt=0;
    uint voteendflag =9;
    
    // 선거 총투표건수 관리 및 후보자에게 전달
    function settotvote (address cancntraddr , uint w) payable {
        if (voteendflag == 9) {
            totalVoteCnt = totalVoteCnt+w;
            candidate c =  candidate(cancntraddr);
            c.setvc(w);
        }
    }
    
    // 선거 총투표건수 조회 
    function gettotvote() constant returns (uint) {
        return totalVoteCnt;
    }
    // 선거 종료 관리  
    function setvoteend () payable {
        voteendflag = 1;
    }

    function getvoteend() constant returns (uint) {
        return voteendflag;
    }    
}


contract voteSetter {
    uint weight = 1;  // 투표가중치 기본 1

    //후보자와 투표유형 값을 받아 처리
    function setvote(address votecntraddr,address cancntraddr) payable {
        if (weight == 1)  {
            vote v=  vote(votecntraddr);
            v.settotvote(cancntraddr, weight);
            weight = 0;
        }
    }
    
    function getWeight() constant returns (uint) {
        return weight;
    }    
}


