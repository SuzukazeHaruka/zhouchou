package com.atguigu.atcrowdfunding.bean;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;
import java.util.Set;

public class TUser extends User {

    TAdmin admin;
    Set<GrantedAuthority>authorities;

    public TUser(TAdmin admin, Set<GrantedAuthority> authorities) {
        super(admin.getLoginacct(), admin.getUserpswd(), authorities);
        this.admin=admin;
        this.authorities=authorities;

    }


}
