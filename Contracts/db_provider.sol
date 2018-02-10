/*
Copyright (c) 2018 ZSC Dev, Zeusshield Blockchain Technology Development Co., Ltd
2018-02-07: v0.01
2018-02-09: v0.02
2018-02-10: v0.03
*/

pragma solidity ^0.4.18;
import "./db_entity.sol";
import "./db_template.sol";

library DBProvider {
    struct Provider {
        DBEntity.Entity entity_;
        DBTemplate.Template[]  templates_;
        mapping(string => uint) templateExist_;
    }

    function initOrigin(Provider storage _provider) public {
        DBEntity.insertParameter(_provider.entity_, "assurerType");
        DBEntity.insertParameter(_provider.entity_, "assurerName");
        DBEntity.insertParameter(_provider.entity_, "principalFirstName");
        DBEntity.insertParameter(_provider.entity_, "principalLastName");
        DBEntity.insertParameter(_provider.entity_, "principalIdentific");
        DBEntity.insertParameter(_provider.entity_, "principalPhone");
        DBEntity.insertParameter(_provider.entity_, "principalEmail");
        DBEntity.insertParameter(_provider.entity_, "principalNationality");
        DBEntity.insertParameter(_provider.entity_, "companyName");
        DBEntity.insertParameter(_provider.entity_, "companyId");
        DBEntity.insertParameter(_provider.entity_, "companyNationality");
        DBEntity.insertParameter(_provider.entity_, "companyPhone");
        DBEntity.insertParameter(_provider.entity_, "companyEmail");
        DBEntity.insertParameter(_provider.entity_, "claimEmail");
        DBEntity.insertParameter(_provider.entity_, "claimPhone");
    }

    function addTemplate(Provider storage _provider, DBTemplate.Template storage _template, string _name) public returns (bool) {
        if (_provider.templateExist_[_name] != 0)
            return false;

        _provider.templateExist_[_name] = 1;
        _provider.templates_.push(_template);

        return true;
    }
}
