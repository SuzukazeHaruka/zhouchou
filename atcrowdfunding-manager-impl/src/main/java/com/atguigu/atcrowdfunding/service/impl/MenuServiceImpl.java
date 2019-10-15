package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TMenuExample;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MenuServiceImpl implements MenuService {


    @Autowired
    private TMenuMapper menuMapper;

    @Override
    public List<TMenu> listAllMenu() {
        TMenuExample example=new TMenuExample();
        example.createCriteria().getAllCriteria();
        List<TMenu> allMenus = menuMapper.selectByExample(example);
        List<TMenu>parentMenus=new LinkedList<TMenu>();

        parentMenus = allMenus.stream().filter(menu -> 0 == menu.getPid()).collect(Collectors.<TMenu>toList());
        parentMenus.forEach(parent->{
            List<TMenu> collect = allMenus.stream().filter(menu -> menu.getPid() == parent.getId()).collect(Collectors.toList());
            parent.setChildren(collect);
        });
        return parentMenus;
    }

    @Override
    public TMenu getMenu(Integer id) {

        TMenu menu = menuMapper.selectByPrimaryKey(id);

        return menu;
    }

    @Override
    public void saveTMenu(TMenu menu) {
            menuMapper.insert(menu);
    }

    @Override
    public void updateTMenu(TMenu menu) {
            menuMapper.updateByPrimaryKey(menu);
    }

    @Override
    public void delete(Integer id) {
        menuMapper.deleteByPrimaryKey(id);
    }


}
