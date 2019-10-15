package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;
import com.atguigu.atcrowdfunding.service.TPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TPermissionServiceImpl implements TPermissionService {

    @Autowired
    private TPermissionMapper permissionMapper;

    @Override
    public List<TPermission> getAllPermissions() {

        return  permissionMapper.selectByExample(null);
    }

    @Override
    public void savePermission(TPermission permission) {

        permissionMapper.insertSelective(permission);
    }

    @Override
    public void deletePermission(Integer id) {
        permissionMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void editPermission(TPermission permission) {
        permissionMapper.updateByPrimaryKeySelective(permission);
    }

    @Override
    public TPermission getPermissionById(Integer id) {
        return permissionMapper.selectByPrimaryKey(id);
    }
}
