package com.schedule.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库连接工具类
 */
public class DatabaseUtil {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/schedule_db?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Minecon2021";
    
    // 静态代码块，加载数据库驱动
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("无法加载数据库驱动", e);
        }
    }
    
    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    /**
     * 关闭数据库连接
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("关闭数据库连接失败: " + e.getMessage());
            }
        }
    }
    
    /**
     * 测试数据库连接
     */
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            System.err.println("数据库连接测试失败: " + e.getMessage());
            return false;
        }
    }
      /**
     * 获取数据库连接信息
     */
    public static String getConnectionInfo() {
        return "数据库URL: " + URL + ", 用户名: " + USERNAME;
    }
    
    /**
     * 获取数据库版本信息
     */
    public static String getDatabaseVersion() throws SQLException {
        String sql = "SELECT VERSION() as version";
        try (Connection connection = getConnection();
             java.sql.PreparedStatement pstmt = connection.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getString("version");
            }
        }
        return "未知版本";
    }
    
    /**
     * 获取用户数量
     */
    public static int getUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM users";
        try (Connection connection = getConnection();
             java.sql.PreparedStatement pstmt = connection.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }
}
