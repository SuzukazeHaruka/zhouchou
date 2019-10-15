package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TMenuController {

    Logger log = LoggerFactory.getLogger(TMenuController.class);

    @Autowired
    MenuService menuService;

    @RequestMapping("/menu/index")
    public String index() {

        return "menu/index";
    }

    @ResponseBody
    @RequestMapping("/menu/loadTree")
    public List<TMenu> loadTree() {

        List<TMenu> list = menuService.listAllMenu();

        return list;
    }


    @ResponseBody
    @RequestMapping("/menu/doAdd")
    public String doAdd(TMenu menu) {

        log.debug("menu={}",menu);

        try {
            menuService.saveTMenu(menu);

            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }



    @ResponseBody
    @RequestMapping("/menu/get")
    public TMenu get(Integer id) {

        log.debug("id={}",id);

        try {
            TMenu menu = menuService.getMenu(id);

            return menu;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    @ResponseBody
    @RequestMapping("/menu/doUpdate")
    public String doUpdate(TMenu menu) {

        log.debug("menu={}",menu);

        try {
            menuService.updateTMenu(menu);

            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    @ResponseBody
    @RequestMapping("/menu/delete")
    public String delete(Integer id) {

        log.debug("id={}",id);

        try {
            menuService.delete(id);

            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }


}
