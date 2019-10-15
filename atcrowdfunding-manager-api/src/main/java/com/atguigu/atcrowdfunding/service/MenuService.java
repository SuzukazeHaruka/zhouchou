package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TMenu;

import java.util.List;

public interface MenuService {

    public List<TMenu> listAllMenu();

    TMenu getMenu(Integer id);

    void saveTMenu(TMenu menu);

    void updateTMenu(TMenu menu);

    void delete(Integer id);
}
