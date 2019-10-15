package com.atguigu.atcrowdfunding.service.impl;


import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import com.atguigu.atcrowdfunding.mapper.TRolePermissionMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.rmi.runtime.Log;

import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private TRoleMapper tRoleMapper;

    @Autowired
    private TRolePermissionMapper tRolePermissionMapper;

    @Override
    public List<TRole> getAllRoles(Map<String, Object> paramMap) {

        Integer pageNum= (Integer) paramMap.get("pageNum");
        Integer pageSize=(Integer)paramMap.get("pageSize");
        String condition=(String)paramMap.get("condition");
        PageHelper.startPage(pageNum, pageSize);
        List<TRole> tRoles =null;
        if(StringUtils.isEmpty(condition)) {

           tRoles= tRoleMapper.selectByExample(null);
        }
        else {
            TRoleExample example=new TRoleExample();
            TRoleExample.Criteria criteria1 = example.createCriteria();
            TRoleExample.Criteria criteria = criteria1.andNameLike("%" + condition + "%");
             tRoles = tRoleMapper.selectByExample(example);
        }
        return tRoles;
    }

    @Override
    @Transactional
    public void saveRole(TRole role) {
        int insert = tRoleMapper.insert(role);

    }

    @Override
    public TRole findById(Integer id) {
        TRole tRole = tRoleMapper.selectByPrimaryKey(id);
        return tRole;
    }

    @Override
    public void update(TRole role) {
        tRoleMapper.updateByPrimaryKey(role);
    }

    @Override
    public void delete(Integer id) {
        tRoleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<TRole> findAll() {

        return tRoleMapper.selectByExample(null);
    }

    @Override
    public List<Integer> listPermissionIdByRoleId(Integer roleId) {
        List<Integer>pids=tRolePermissionMapper.listPermissionIdByRoleId(roleId);
        return pids;
    }

    @Override
    public void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids) {
        tRolePermissionMapper.saveRoleAndPermissionRelationship(roleId, ids);
    }
}
