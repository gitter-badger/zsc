/*
Copyright (c) 2018 ZSC Dev.
2018-02-07: v0.01
2018-02-09: v0.02
2018-02-10: v0.03
*/

pragma solidity ^0.4.18;
import "./db_entity.sol";
import "./db_item.sol";
import "./db_template.sol";
import "./db_idmanager.sol";


contract DBUser is DBEntity {
    struct PaymentHistory {
        address addr_;
        bytes32 name_;
        bytes32 data_;
        uint amount_;
        bool isInput_;
    }
    
    DBIDManager agreementIDs_;
    PaymentHistory[] payments_;
    uint totalEth_;

    // Constructor
    function DBUser(bytes32 _name) public DBEntity(_name) {
        setEntityType("user"); 
        initParameters();
    }

    function initParameters() internal {
    }

    function() public payable {
        if (msg.value < 1 ether / 100) {
            revert();
        } else {
            PaymentHistory memory pay;
            pay.addr_ = msg.sender;
            pay.name_ = "ether";
            pay.amount_ =  msg.value;
            pay.isInput_ = true;
            payments_.push(pay);
            totalEth_ += msg.value;
        }
    }

    function executeEtherTransaction(address _dest, uint _value, bytes32 _data) public only_delegate returns (bool) {
        require(totalEth_ < _value);

        if (_dest.call.value(_value)(_data)) {
            PaymentHistory memory pay;
            pay.addr_ = _dest;
            pay.name_ = "ether";
            pay.data_ = _data;
            pay.amount_ =  _value;
            pay.isInput_ = false;
            payments_.push(pay);
            totalEth_ -= _value;
        } else {
            return false;
        }
    }
}
