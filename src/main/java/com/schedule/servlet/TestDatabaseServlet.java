package com.schedule.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.schedule.util.DatabaseUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * 数据库连接测试Servlet
 * 提供数据库连接状态检查和基本信息查询功能
 */
@WebServlet("/TestDatabaseServlet")
public class TestDatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(TestDatabaseServlet.class.getName());
    
    public TestDatabaseServlet() {
        super();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 设置响应类型为JSON
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        
        PrintWriter out = response.getWriter();
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        try {
            logger.info("开始数据库连接测试...");
            
            // 测试数据库连接
            boolean isConnected = DatabaseUtil.testConnection();
            
            if (isConnected) {
                logger.info("数据库连接成功，获取详细信息...");
                
                // 获取数据库详细信息
                String version = "未知";
                int userCount = -1;
                
                try {
                    version = DatabaseUtil.getDatabaseVersion();
                    if (version == null || version.trim().isEmpty()) {
                        version = "MySQL 8.x";
                    }
                    logger.info("数据库版本: " + version);
                } catch (Exception e) {
                    logger.log(Level.WARNING, "获取数据库版本失败", e);
                    version = "获取失败: " + e.getMessage();
                }
                
                try {
                    userCount = DatabaseUtil.getUserCount();
                    logger.info("用户数量: " + userCount);
                } catch (Exception e) {
                    logger.log(Level.WARNING, "获取用户数量失败", e);
                    userCount = -1;
                }
                
                // 构建成功响应JSON - 使用StringBuilder确保格式正确
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"status\":\"success\",");
                json.append("\"message\":\"数据库连接成功\",");
                json.append("\"database\":\"schedule_db\",");
                json.append("\"version\":\"").append(escapeJson(version)).append("\",");
                json.append("\"userCount\":").append(userCount).append(",");
                json.append("\"timestamp\":\"").append(timestamp).append("\"");
                json.append("}");
                
                String jsonResponse = json.toString();
                logger.info("JSON响应: " + jsonResponse);
                out.print(jsonResponse);
                
            } else {
                logger.warning("数据库连接失败");
                // 连接失败响应
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"status\":\"error\",");
                json.append("\"message\":\"数据库连接失败，请检查MySQL服务是否启动\",");
                json.append("\"timestamp\":\"").append(timestamp).append("\"");
                json.append("}");
                
                out.print(json.toString());
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "数据库测试过程中发生异常", e);
            
            // 异常响应
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"status\":\"error\",");
            json.append("\"message\":\"").append(escapeJson("系统异常: " + e.getMessage())).append("\",");
            json.append("\"timestamp\":\"").append(timestamp).append("\"");
            json.append("}");
            
            out.print(json.toString());
            
        } finally {
            out.flush();
            out.close();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST请求重定向到GET
        doGet(request, response);
    }
    
    /**
     * 转义JSON字符串中的特殊字符
     * @param input 输入字符串
     * @return String 转义后的字符串
     */
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f");
    }
}