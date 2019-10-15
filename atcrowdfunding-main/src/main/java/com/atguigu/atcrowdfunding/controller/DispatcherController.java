package com.atguigu.atcrowdfunding.controller;


import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.MD5Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DispatcherController {

    @Autowired
    private AdminService adminService;

    @Autowired
    MenuService menuService;

   Logger log=LoggerFactory.getLogger(DispatcherController.class);

   @RequestMapping("/index")
    public String index(){
        log.debug("进入初始化页面");
        return "index";
    }
    @RequestMapping("/login")
    public String login(){
        log.debug("进入登录");
        System.out.println("进入登录");
        return "login";
    }

    @RequestMapping("/main")
    public String main(HttpSession session) {

        //暂时不考虑权限问题，直接查询所有
        List<TMenu> menuList  =  (List<TMenu>)session.getAttribute("menuList");
        if(menuList==null) {
            menuList =  menuService.listAllMenu(); //直接存储父菜单
            session.setAttribute("menuList", menuList);
        }
        return "main";
    }
/*
    @RequestMapping("/doLogin")
    public String doLogin(String loginacct, String userpswd, HttpSession session , Model model){

        Map<String,Object>paramMap=new HashMap<>();
        paramMap.put("loginacct", loginacct);
        paramMap.put("userpswd", userpswd);
        try {
            TAdmin tAdmin = adminService.getLoginByAdmin(paramMap);
            session.setAttribute(Const.LOGIN_ADMIN,tAdmin);
            log.info("登录成功...");
            return "redirect:/main";
        } catch (Exception e) {
            e.printStackTrace();

            log.error("登录失败-{}",e.getMessage());
            model.addAttribute("message", e.getMessage());
            return "login";
        }


    }*/

  /*  @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute(Const.LOGIN_ADMIN);
        session.invalidate();
        return "redirect:/login";
    }*/



}
