package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

public interface AdminService {

    public TAdmin getLoginByAdmin(Map<String,Object> paramMap);

    PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap);

    void saveAdmin(TAdmin tAdmin);

    TAdmin getAdminById(Integer id);

    void updateTAdmin(TAdmin admin);

    void deleteTAdmin(Integer id);

    void deleteBatchTAdmin(String ids);

    List<Integer> queryRolesByAdminId(Integer id);

    void saveAdminAndRoleRelationship(Integer adminId, List<Integer> ids);

    void deleteAdminAndRoleRelationship(Integer adminId, List<Integer> ids);
}
