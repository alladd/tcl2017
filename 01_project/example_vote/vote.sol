pragma solidity ^0.4.0;

contract candidate {
    uint votecnt = 0;

    // ���� ��ǥ�� ����
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
    
    // ���� ����ǥ�Ǽ� ���� �� �ĺ��ڿ��� ����
    function settotvote (address cancntraddr , uint w) payable {
        if (voteendflag == 9) {
            totalVoteCnt = totalVoteCnt+w;
            candidate c =  candidate(cancntraddr);
            c.setvc(w);
        }
    }
    
    // ���� ����ǥ�Ǽ� ��ȸ 
    function gettotvote() constant returns (uint) {
        return totalVoteCnt;
    }
    // ���� ���� ����  
    function setvoteend () payable {
        voteendflag = 1;
    }

    function getvoteend() constant returns (uint) {
        return voteendflag;
    }    
}


contract voteSetter {
    uint weight = 1;  // ��ǥ����ġ �⺻ 1

    //�ĺ��ڿ� ��ǥ���� ���� �޾� ó��
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


