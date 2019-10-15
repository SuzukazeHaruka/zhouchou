package com.atguigu.atcrowdfunding.impl;

import com.atguigu.atcrowdfunding.bean.*;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    Logger log= LoggerFactory.getLogger(UserDetailsServiceImpl.class);

    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        //1.查询用户
        TAdminExample example=new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> tAdmins = adminMapper.selectByExample(example);
        if(!tAdmins.isEmpty() && tAdmins.size() == 1){
            TAdmin tAdmin = tAdmins.get(0);
            List<TRole> roles = roleMapper.getHasRoles(tAdmin.getId());
            log.debug("roles:",roles);
            List<TPermission> permissions = permissionMapper.getPermissionsByUserId(tAdmin.getId());
            log.debug("permissions:",permissions);
            Set<GrantedAuthority>authorities=new HashSet<>();
            for (TRole role : roles) {
                if(!StringUtils.isEmpty(role.getName())){
                    authorities.add(new SimpleGrantedAuthority("ROLE_"+role.getName()));
                }
            }
            for (TPermission permission : permissions) {
                if(!StringUtils.isEmpty(permission.getName())){
                    authorities.add(new SimpleGrantedAuthority(permission.getName()));

                }
            }
            return new TUser(tAdmin,authorities);
        }

       return null;
    }
}
