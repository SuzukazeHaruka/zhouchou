package com.atguigu.atcrowdfunding.controller;


import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.Datas;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class RoleController {

    Logger log = LoggerFactory.getLogger(RoleController.class);


    @Autowired
    private RoleService roleService;

    @RequestMapping("/role/index")
    public String index(){

        return "/role/index";
    }

    @GetMapping("/role/allRoles")
    @ResponseBody
    public PageInfo<TRole> allRole(@RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
                                   @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
                                   @RequestParam(value = "condition",defaultValue = "",required = false) String condition){


        Map<String ,Object>paramMap=new HashMap<>();
        paramMap.put("pageNum", pageNum);
        paramMap.put("pageSize", pageSize);
        paramMap.put("condition", condition);
        List<TRole>roles=roleService.getAllRoles(paramMap);
        return new PageInfo<TRole>(roles);
    }

    @ResponseBody
    @RequestMapping(value = "/role/save",produces = {"application/json;charset=utf-8"})

    public String saveRole(@RequestBody TRole role){

        log.debug("roleId={}",role);

        try {
            roleService.saveRole(role);
            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }
    }


    @ResponseBody
    @RequestMapping(value = "/role/update",produces = {"application/json;charset=utf-8"})
    @PreAuthorize("hasRole('PM - 项目经理') or hasAuthority('role:update')")
    public String updateRole(@RequestBody TRole role){
        try {
            roleService.update(role);
            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }
    }

    @ResponseBody
    @RequestMapping("/role")
    public TRole findById(Integer id){
        log.debug("id:{}",id);
       return roleService.findById(id);
    }

    @ResponseBody
    @DeleteMapping("/role/delete")
    public String deleteRoleById(Integer id){
        try {
            roleService.delete(id);
            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }
    }


    @ResponseBody
    @RequestMapping("/role/listPermissionIdByRoleId")
    public List<Integer> listPermissionIdByRoleId(Integer roleId) {

        log.debug("roleId={}",roleId);

        try {
            List<Integer> permissionIdList = roleService.listPermissionIdByRoleId(roleId);
            return permissionIdList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @ResponseBody
    @RequestMapping("/role/doAssign")
    public String doAssign(Integer roleId, Datas ds) {

        log.debug("roleId={}",roleId);
        log.debug("ids={}",ds.getIds());

        try {
            roleService.saveRoleAndPermissionRelationship(roleId,ds.getIds());

            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

}
