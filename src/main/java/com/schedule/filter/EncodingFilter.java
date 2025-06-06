package com.schedule.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.util.logging.Logger;

/**
 * 字符编码过滤器
 * 用于设置请求和响应的字符编码，解决中文乱码问题
 */
public class EncodingFilter implements Filter {
    private static final Logger logger = Logger.getLogger(EncodingFilter.class.getName());
    private String encoding;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        encoding = filterConfig.getInitParameter("encoding");
        if (encoding == null || encoding.isEmpty()) {
            encoding = "UTF-8";
        }
        logger.info("EncodingFilter初始化完成，使用编码: " + encoding);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        logger.info("EncodingFilter销毁");
        encoding = null;
    }
}