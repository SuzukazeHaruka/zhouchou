package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.Datas;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private RoleService roleService;


    private Logger log= LoggerFactory.getLogger(AdminController.class);

    @RequestMapping("/admin/index")
    public String index(
           @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
            @RequestParam(value = "condition",required = false,defaultValue = "") String condition,
           Model model){

        log.debug("pageNum:{pageNum}",pageNum);
        log.debug("pageSize:{pageSize}",pageSize);
        log.debug("condition:{condition}",condition);
        Map<String,Object>paramMap=new HashMap<>();
        paramMap.put("pageNum", pageNum);
        paramMap.put("pageSize", pageSize);
        paramMap.put("condition", condition);
        PageInfo<TAdmin>page=adminService.listAdminPage(paramMap);
        model.addAttribute("page", page);
        log.debug("page:{page}",page);

        return "admin/index";
    }

    @RequestMapping("/admin/toAdd")
    public String toAdd() {
        log.debug("进入增加");
        return "admin/add";
    }

    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin tAdmin) {
        adminService.saveAdmin(tAdmin);
        return "redirect:/admin/index";

    }

    @PreAuthorize("hasRole('PM - 项目经理') or hasAuthority('user:update')" )
    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin,Integer pageNum) {

        log.debug("admin={}",admin);

        adminService.updateTAdmin(admin);

        //return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE;
        return "redirect:/admin/index?pageNum="+pageNum;
    }



    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id,Model model) {

        log.debug("id={}",id);

        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin", admin);

        return "admin/update";
    }

    @RequestMapping("/admin/doDelete")
    public String doDelete(Integer id,Integer pageNum) {

        log.debug("id={}",id);
        log.debug("pageNum={}",pageNum);

        adminService.deleteTAdmin(id);

        return "redirect:/admin/index?pageNum="+pageNum;
    }

    @RequestMapping("/admin/deleteBatch")
    public String doDelete(String ids,Integer pageNum) {

        log.debug("ids={}",ids);
        log.debug("pageNum={}",pageNum);

        adminService.deleteBatchTAdmin(ids);

        return "redirect:/admin/index?pageNum="+pageNum;
    }


    @RequestMapping("/admin/assign")
    public String adminAssign(Integer id,Model model){
        model.addAttribute("adminId", id);
        //查询所有角色
        List<TRole> roles = roleService.findAll();
        //查询已经分配给管理员的角色id
        List<Integer> roleIds= adminService.queryRolesByAdminId(id);
        List<TRole> unassign = new ArrayList<TRole>();
        // 已分配角色
        List<TRole> assign = new ArrayList<TRole>();

        roles.stream().forEach(role -> {
            if(roleIds.contains(role.getId())){
                assign.add(role);
            }else{
                unassign.add(role);
            }
        });
        Map<String,List<TRole>>map=new HashMap<>();
        model.addAttribute("assignList", assign);
        model.addAttribute("unAssignList", unassign);
        return "/admin/assignRole";
    }




    @RequestMapping("/admin/doAssign")
    @ResponseBody
    public String doAssign(Integer adminId, Datas data) {  //不能使用List集合接收。

        log.debug("adminId={}",adminId);

        for(Integer rid : data.getIds()) {
            log.debug("roleId={}",rid);
        }
        adminService.saveAdminAndRoleRelationship(adminId,data.getIds());
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/admin/doUnAssign")
    public String doUnAssign(Integer adminId,Datas data) {  //不能使用List集合接收。

        log.debug("adminId={}",adminId);

        for(Integer rid : data.getIds()) {
            log.debug("roleId={}",rid);
        }


        adminService.deleteAdminAndRoleRelationship(adminId,data.getIds());


        return "ok";
    }
}
