package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TPermission;

import java.util.List;

public interface TPermissionService {
    public List<TPermission> getAllPermissions() ;

    public void savePermission(TPermission permission) ;

    public void deletePermission(Integer id) ;

    public void editPermission(TPermission permission) ;

    public TPermission getPermissionById(Integer id) ;
}
