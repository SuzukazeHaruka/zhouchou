package com.atguigu.atcrowdfunding.exception;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@Component
public class AccessDeniedHandlerImpl implements AccessDeniedHandler {
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e) throws IOException, ServletException {

        request.setAttribute("msg",e.getMessage());
        if("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))){
            String msg="403";
            response.getWriter().write(msg);
        }else {
            request.getRequestDispatcher("/WEB-INF/jsp/common/error403.jsp").forward(request, response);
        }
    }
}
