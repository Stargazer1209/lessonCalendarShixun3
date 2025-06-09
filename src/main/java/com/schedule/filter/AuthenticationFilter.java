package com.schedule.filter;

// filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\java\com\schedule\filter\AuthenticationFilter.java


import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;
import java.util.logging.Logger;

/**
 * 身份验证过滤器
 */
public class AuthenticationFilter implements Filter {
    private static final Logger logger = Logger.getLogger(AuthenticationFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("AuthenticationFilter初始化完成");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();
        
        logger.info("用户 - 访问受保护资源: " + uri);
        
        // 允许所有请求通过（阶段一测试）
        chain.doFilter(request, response);
        
    }

    @Override
    public void destroy() {
        logger.info("AuthenticationFilter销毁");
    }
}

