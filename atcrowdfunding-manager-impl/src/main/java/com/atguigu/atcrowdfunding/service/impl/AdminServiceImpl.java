package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TAdminRole;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.AppDateUtils;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private TAdminMapper adminMapper;

    @Autowired
    private TAdminRoleMapper adminRoleMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public TAdmin getLoginByAdmin(Map<String,Object>paramMap){
        TAdminExample tAdminExample=new TAdminExample();
        String loginacct = (String) paramMap.get("loginacct");
        String userpswd =  passwordEncoder.encode((String) paramMap.get("userpswd"));
        tAdminExample.createCriteria().andLoginacctEqualTo(loginacct);
        List<TAdmin> tAdmins = adminMapper.selectByExample(tAdminExample);
        if(tAdmins.size()==0){
            throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }
        TAdmin tAdmin = tAdmins.get(0);
        if (!tAdmin.getUserpswd().equals(userpswd)){
            throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }
        return tAdmin;
    }

    @Override
    public PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap) {
        TAdminExample example=new TAdminExample();
        Integer pageNum = (Integer)paramMap.get("pageNum");
        Integer pageSize = (Integer)paramMap.get("pageSize");
        String condition =(String)paramMap.get("condition");
        PageHelper.startPage(pageNum,pageSize);

        List<TAdmin> tAdmins=new ArrayList<>();
        if(StringUtils.isEmpty(condition)){
           tAdmins= adminMapper.selectByExample(null);
        }else {
            TAdminExample.Criteria criteria1 = example.createCriteria();
            criteria1.andLoginacctLike("%"+condition+"%");
            TAdminExample.Criteria criteria2 = example.createCriteria();
            criteria2.andUsernameLike("%"+condition+"%");
            TAdminExample.Criteria criteria3 = example.createCriteria();
            criteria3.andEmailLike("%"+condition+"%");
            example.or(criteria1);
            example.or(criteria2);
            example.or(criteria3);
            tAdmins=adminMapper.selectByExample(example);
        }
        PageInfo<TAdmin> pageInfo = new PageInfo<>(tAdmins);
        return pageInfo;
    }

    @Override
    public void saveAdmin(TAdmin tAdmin) {
        tAdmin.setCreatetime(AppDateUtils.getFormatTime());
        tAdmin.setUserpswd(passwordEncoder.encode(tAdmin.getUserpswd()));
        adminMapper.insertSelective(tAdmin);
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        TAdmin tAdmin = adminMapper.selectByPrimaryKey(id);
        return tAdmin;
    }



    @Override
    public void updateTAdmin(TAdmin admin) {
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public void deleteTAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatchTAdmin(String ids) {
        if(!StringUtils.isEmpty(ids)){
            String[] split = ids.split(",");
            List<Integer> idList = Arrays.stream(split).map(i -> Integer.parseInt(i)).collect(Collectors.toList());
            TAdminExample tAdminExample=new TAdminExample();
            TAdminExample.Criteria criteria = tAdminExample.createCriteria();
            criteria.andIdIn(idList);
            adminMapper.deleteByExample(tAdminExample);
        }
    }

    @Override
    public List<Integer> queryRolesByAdminId(Integer id) {
        return adminMapper.queryRolesByAdminId(id);
    }

    @Override
    public void saveAdminAndRoleRelationship(Integer adminId, List<Integer> ids) {
        adminRoleMapper.saveAdminAndRoleRelationship(adminId,ids);
    }

    @Override
    public void deleteAdminAndRoleRelationship(Integer adminId, List<Integer> ids) {
        adminRoleMapper.deleteAdminAndRoleRelationship(adminId,ids);
    }

}
