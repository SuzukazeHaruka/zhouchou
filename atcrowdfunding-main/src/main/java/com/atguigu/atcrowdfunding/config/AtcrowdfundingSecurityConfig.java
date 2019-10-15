package com.atguigu.atcrowdfunding.config;


import com.atguigu.atcrowdfunding.impl.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfiguration;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;

@Configuration
@EnableWebSecurity //启用权限框架功能
@EnableGlobalMethodSecurity(prePostEnabled=true) //启用方法级别细粒度权限控制
public class AtcrowdfundingSecurityConfig  extends WebSecurityConfigurerAdapter {

    @Autowired
    UserDetailsServiceImpl userDetailsServiceImpl;


    @Autowired
    AccessDeniedHandler accessDeniedHandler;


    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsServiceImpl).passwordEncoder(passwordEncoder());
    }


    @Override
    protected void configure(HttpSecurity http) throws Exception {
       // super.configure(http);
        http.authorizeRequests().antMatchers("/static/**","/index.jsp","/login").permitAll()
        .anyRequest().authenticated();

        http.formLogin().loginPage("/login")
        .usernameParameter("loginacct").passwordParameter("userpswd")
        .defaultSuccessUrl("/main").permitAll();
        http.csrf().disable();
        http.rememberMe();
        http.csrf().disable();
        http.logout().logoutSuccessUrl("/index");
        http.exceptionHandling().accessDeniedHandler(accessDeniedHandler);

    }






}
