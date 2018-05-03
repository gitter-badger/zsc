/*
Copyright (c) 2018, ZSC Dev Team
*/

pragma solidity ^0.4.21;

import "./db_entity.sol";

contract WalletBase is DBNode {
    struct Payment {
        uint time_;
        bool isInput_;
        bytes32 txhash_;
        address sender_;
        address receiver_;
        uint256 amount_;
        bytes32 data_;
    }

    struct PaymentHistory {
        uint nos_;
        mapping(uint => Payment) payments_;
    }

    PaymentHistory private paymentHistory_;
    
    bool private isEthAccount_;
    uint lokedValue_;
    uint256 totalValue_;

    address[] multiSig_;
    mapping(address => bool) sigAdrExists_;
    mapping(address => bool) sigStatus_;

    // Constructor
    constructor(bytes32 _name) public DBNode(_name) {
        isEthAccount_ = false;
        lokedValue_ = 0;
        unlockedValue_= 0;
    }

    function executeTransaction(address _dest, uint256 _amount, bytes _data) public returns (uint);

    function setAsEthAccount() internal {
        isEthAccount_ = true;
    }

    function addSignature(address _sigAdr) public {
        checkDelegate(msg.sender, 1);
        require(_sigAdr != address(0));
        require(!sigAdrExists_[_sigAdr])
        multiSig_.push(_sigAdr);
        sigAdrExists_[_s_sigAdrig] = true;
    }

    function signature(address _sigAdr) public {
        checkDelegate(msg.sender, 1);
        require(sigAdrExists_[_sig])
        sigStatus_[_sigAdr] = true;
    }

    function checkMulSig() internal returns (bool) {
        for (uint i = 0; i < multiSig_.length; ++i) {
            if (sigStatus_[multiSig_[i]] == false) {
                return false;
            }
        }
        return true;
    }

    function changeValue(bool _doesIncrease, bool _isLocked, uint _amount) internal returns (bool) {
        if (_doesIncrease) {
            if (_isLocked) {
                lokedValue_ = lokedValue_.add(_amount);
            } 
            totalValue_ = totalValue_.add(_amount);
        } else {
            if (_isLocked) {
                require(lokedValue_ >= _amount);
                lokedValue_= lokedValue_.sub(_amount);
            }
            require(totalValue_ >= _amount);
            totalValue_ = totalValue_.sub( _amount);
        }
    }

    function checkBeforeSent(address _dst, uint _amount) internal returns (bool) {
        if (totalValue_.sub(lokedValue_) >= _amount && _dst != address(this)) {
            if (checkMulSig()) return true;
            else return false;
        } else {
            return false;
        }
    }

    function recordInput(address _sender, bytes32 _tx, uint _amount, bytes32 _data) internal {
        uint index = paymentHistory_.nos_;
        paymentHistory_.nos_++;
        paymentHistory_.payments_[index] = Payment(now, true,  _tx, _sender, address(this), _amount, _data);

        changeValue(true, _data == "locked", _amount);
    }

    function recordOut(address _sender, bytes32 _tx, uint _amount, bytes32 _data) internal {
        require(totalValue_ >= _amount);
        uint index = paymentHistory_.nos_;
        paymentHistory_.nos_++;
        paymentHistory_.payments_[index] = Payment(now, false, _tx, _sender, address(this), _amount, _data);

        changeValue(false, _data == "locked", _amount);
    }

    function getBlance(bool _locked) public constant returns (uint256) {
        checkDelegate(msg.sender, 1);

        if (_locked) return lockedValue_;
        else return totalValue_;
    }

    function numTransactions() public constant returns (uint) {
        checkDelegate(msg.sender, 1);

        return paymentHistory_.nos_;
    }

    function getTransactionInfoByIndex(uint _index) public constant returns (uint, bool, bytes32, uint, address, address) {
        checkDelegate(msg.sender, 1);
        
        require(_index < paymentHistory_.nos_);
        
        return (paymentHistory_[_index].time_,
                paymentHistory_[_index].isInput_,
                paymentHistory_[_index].txhash_,
                paymentHistory_[_index].amount_,
                paymentHistory_[_index].sender_, 
                paymentHistory_[_index].receiver_);
    }
}
