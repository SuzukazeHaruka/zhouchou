package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;

import java.util.List;
import java.util.Map;

public interface RoleService {
    List<TRole> getAllRoles(Map<String, Object> paramMap);

    void saveRole(TRole role);

    TRole findById(Integer id);

    void update(TRole role);

    void delete(Integer id);

    List<TRole> findAll();

    List<Integer> listPermissionIdByRoleId(Integer roleId);

    void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids);
}
