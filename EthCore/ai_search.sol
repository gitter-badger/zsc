        /*
Copyright (c) 2018, ZSC Dev Team
*/

pragma solidity ^0.4.21;

import "./object.sol";

contract AISearch is Object {

    struct ElementInfo {
        // element base info
        // element address
        address addr_;
        // element type
        bytes32 type_;
        // element name
        bytes32 name_;

        // parameter info for the element
        // parameter count
        uint parameterCount;
        // parameter index => parameter name
        mapping(uint => bytes32) parameterNames_;
        // parameter name => parameter index
        mapping(bytes32 => uint) parameterIndexs_;
        // parameter name => exist flag
        mapping(bytes32 => bool) parameterExists_;
        // parameter name => parameter value
        mapping(bytes32 => bytes32) parameters_;
    }

    struct FactoryInfo {
        // factory base info
        /* factory type:
           provider
           receiver
           staker
           template
           agreement
           wallet-eth
           wallet-erc20
         */
        bytes32 type_;

        // element info for the factory
        // element count
        uint elementCount_;
        // elemet index => elemet name
        mapping(uint => bytes32) elementNames_;
        // elemet name => elemet index
        mapping(bytes32 => uint) elementIndexs_;
        // elemet name => exist flag
        mapping(bytes32 => bool) elementExists_;
        // elemet name => ElemetInfo
        mapping(bytes32 => ElementInfo) elements_;
    }   

    // factory count
    uint factoryCount_;
    // factory type => exist flag
    mapping(bytes32 => bool) factoryExists_;
    // factory type => FactoryInfo
    mapping(bytes32 => FactoryInfo) private factorys_;

    function AISearch(bytes32 _name) public Object(_name) {}

    function kill() public {
        // check sender
        checkDelegate(msg.sender, 1);

        // delete all data

        super.kill();
    }

    function checkFactoryExist(bytes32 _factoryType) private return (bool) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);

        return factoryExists_[_factoryType];
    }

    function checkElementExist(bytes32 _factoryType, bytes32 _elementName) private return (bool) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _elementName);

        // check factory exist
        if(!checkFactoryExist(_factoryType)) {
            return false;
        }

        return factorys_[_factoryType].elementExists_[_elementName];
    }

    function checkParameterExist(bytes32 _factoryType, bytes32 _elementName, bytes32 _parameterName) private return (bool) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _elementName);
        require(bytes32(0) != _parameterName);

        // check factory exist
        if(!checkFactoryExist(_factoryType)) {
            return false;
        }

        if(!checkElementExist(_factoryType, _elementName)) {
            return false;
        }

        return factorys_[_factoryType].elements_[_elementName].parameterExists_[_parameterName];
    }

    function addElement(bytes32 _factoryType, bytes32 _elementName, address _elementAddress) public {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _elementName);
        require(address(0) != _elementAddress);

        factorys_[_factoryType].type_ = _factoryType;
        elementIndex = factorys_[_factoryType].elementCount_;
        factorys_[_factoryType].elementNames_[elementIndex] = _elementName;
        factorys_[_factoryType].elementIndexs_[_elementName] = elementIndex;
        factorys_[_factoryType].elementExists_[_elementName] = true;

        factorys_[_factoryType].elements_[_elementName].addr_ = _elementAddress;
        factorys_[_factoryType].elements_[_elementName].type_ = _factoryType;
        factorys_[_factoryType].elements_[_elementName].name_ = _elementName;

        factorys_[_factoryType].elementCount_ ++;
    }

    function addParameter(bytes32 _factoryType, bytes32 _elementName, address _elementAddress, bytes32 _parameterName, bytes32 _parameterValue) public {
        uint elementIndex = 0;
        uint parameterIndex = 0;

        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _elementName);
        require(address(0) != _elementAddress);
        require(bytes32(0) != _parameterName);
        require(bytes32(0) != _parameterValue);

        factorys_[_factoryType].type_ = _factoryType;
        elementIndex = factorys_[_factoryType].elementCount_;
        factorys_[_factoryType].elementNames_[elementIndex] = _elementName;
        factorys_[_factoryType].elementIndexs_[_elementName] = elementIndex;
        factorys_[_factoryType].elementExists_[_elementName] = true;

        factorys_[_factoryType].elements_[_elementName].addr_ = _elementAddress;
        factorys_[_factoryType].elements_[_elementName].type_ = _factoryType;
        factorys_[_factoryType].elements_[_elementName].name_ = _elementName;
        parameterIndex = factorys_[_factoryType].elements_[_elementName].parameterCount;
        factorys_[_factoryType].elements_[_elementName].parameterNames_[parameterIndex] = _parameterName;
        factorys_[_factoryType].elements_[_elementName].parameterIndexs_[_parameterName] = parameterIndex;
        factorys_[_factoryType].elements_[_elementName].parameterExists_[_parameterName] = true;
        factorys_[_factoryType].elements_[_elementName].parameters_[_parameterName] = _parameterValue;
        factorys_[_factoryType].elements_[_elementName].parameterCount ++;

        factorys_[_factoryType].elementCount_ ++;
    }

    function removeParameter(bytes32 _factoryType, bytes32 _elementName, bytes32 _parameterName) public {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _elementName);
        require(bytes32(0) != _parameterName);

        // TODO
    }

    function numFactoryElements(bytes32 _factoryType) public view returns (uint) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);

        return factorys_[_factoryType].elementCount_;
    }

    function getFactoryElementNameByIndex(bytes32 _factoryType, uint _index) public view returns (bytes32) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(factorys_[_factoryType].elementCount_ > _index);

        return factorys_[_factoryType].elementNames_[_index];
    }

    function numElementParameters(bytes32 _factoryType, bytes32 _enName) public view returns (uint) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _enName);

        return factorys_[_factoryType].elements_[_enName].parameterCount;
    }

    function getElementParameterNameByIndex(bytes32 _factoryType, bytes32 _enName, uint _index) public view returns (bytes32) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _enName);
        require(factorys_[_factoryType].elements_[_enName].parameterCount > _index);

        return factorys_[_factoryType].elements_[_enName].parameterNames_[_index];
    }

    function getElementParameter(bytes32 _factoryType, bytes32 _enName, bytes32 _parameter) public view returns (bytes32) {
        // check sender
        checkDelegate(msg.sender, 1);

        // check param
        require(bytes32(0) != _factoryType);
        require(bytes32(0) != _enName);
        require(bytes32(0) != _parameter);

        return factorys_[_factoryType].elements_[_enName].parameters_[_parameter];
    }
}