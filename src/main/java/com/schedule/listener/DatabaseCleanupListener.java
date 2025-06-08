package com.schedule.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Logger;
import java.util.logging.Level;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

/**
 * 数据库清理监听器
 * 用于在应用启动和停止时正确管理数据库连接和驱动程序
 */
@WebListener
public class DatabaseCleanupListener implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(DatabaseCleanupListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("数据库连接管理器初始化");
        // 应用启动时的初始化工作（如果需要）
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("开始清理数据库资源...");
        
        try {
            // 1. 停止MySQL的连接清理线程
            AbandonedConnectionCleanupThread.checkedShutdown();
            logger.info("MySQL连接清理线程已停止");
        } catch (Exception e) {
            logger.log(Level.WARNING, "停止MySQL连接清理线程时发生异常", e);
        }
        
        try {
            // 2. 注销所有JDBC驱动程序
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                try {
                    DriverManager.deregisterDriver(driver);
                    logger.info("成功注销JDBC驱动程序: " + driver.getClass().getName());
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "注销JDBC驱动程序失败: " + driver.getClass().getName(), e);
                }
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "清理JDBC驱动程序时发生异常", e);
        }
        
        logger.info("数据库资源清理完成");
    }
}