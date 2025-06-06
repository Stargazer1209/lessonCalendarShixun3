package com.schedule.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * 数据库连接工具类
 * 提供数据库连接、连接测试等功能
 * 专为MySQL 8.4.5优化
 */
public class DatabaseUtil {
    private static final Logger logger = Logger.getLogger(DatabaseUtil.class.getName());

    // 数据库连接配置 - MySQL 8.4.5兼容版本
    private static final String DB_URL = "jdbc:mysql://localhost:3306/schedule_db"
            + "?useSSL=false"
            + "&serverTimezone=Asia/Shanghai"
            + "&characterEncoding=utf8"
            + "&useUnicode=true"
            + "&allowPublicKeyRetrieval=true"
            + "&autoReconnect=true"
            + "&useServerPrepStmts=true"
            + "&cachePrepStmts=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Minecon2021";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // 静态代码块，加载数据库驱动
    static {
        try {
            Class.forName(DB_DRIVER);
            logger.info("MySQL JDBC驱动加载成功");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "MySQL JDBC驱动加载失败", e);
            throw new RuntimeException("数据库驱动加载失败", e);
        }
    }

    /**
     * 获取数据库连接
     * 
     * @return Connection 数据库连接对象
     * @throws SQLException 数据库连接异常
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            logger.info("数据库连接建立成功");
            return conn;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "数据库连接失败: " + e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 测试数据库连接
     * 
     * @return boolean 连接是否成功
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            boolean isValid = conn != null && !conn.isClosed() && conn.isValid(5);
            if (isValid) {
                logger.info("数据库连接测试成功");
            }
            return isValid;
        } catch (SQLException e) {
            logger.log(Level.WARNING, "数据库连接测试失败", e);
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    /**
     * 获取数据库版本信息
     * 
     * @return String 数据库版本
     */
    public static String getDatabaseVersion() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement("SELECT VERSION() as version");
            rs = stmt.executeQuery();

            if (rs.next()) {
                String version = rs.getString("version");
                logger.info("数据库版本查询成功: " + version);
                return version;
            }
            logger.warning("未获取到数据库版本信息");
            return "MySQL 8.x (版本信息获取失败)";
        } catch (SQLException e) {
            logger.log(Level.WARNING, "获取数据库版本失败", e);
            return "获取失败: " + e.getMessage();
        } finally {
            closeAll(conn, stmt, rs);
        }
    }

    /**
     * 获取用户表记录数量
     * 
     * @return int 用户数量
     */
    public static int getUserCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement("SELECT COUNT(*) as count FROM users");
            rs = stmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt("count");
                logger.info("用户数量查询成功: " + count);
                return count;
            }
            logger.warning("未获取到用户数量信息");
            return 0;
        } catch (SQLException e) {
            logger.log(Level.WARNING, "获取用户数量失败: " + e.getMessage(), e);
            return -1;
        } finally {
            closeAll(conn, stmt, rs);
        }
    }

    /**
     * 关闭数据库连接
     * 
     * @param conn 数据库连接
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.fine("数据库连接已关闭");
            } catch (SQLException e) {
                logger.log(Level.WARNING, "关闭数据库连接时发生错误", e);
            }
        }
    }

    /**
     * 关闭PreparedStatement
     * 
     * @param stmt PreparedStatement对象
     */
    public static void closeStatement(PreparedStatement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "关闭Statement时发生错误", e);
            }
        }
    }

    /**
     * 关闭ResultSet
     * 
     * @param rs ResultSet对象
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "关闭ResultSet时发生错误", e);
            }
        }
    }

    /**
     * 关闭所有数据库资源
     * 
     * @param conn 数据库连接
     * @param stmt PreparedStatement对象
     * @param rs   ResultSet对象
     */
    public static void closeAll(Connection conn, PreparedStatement stmt, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }
}
