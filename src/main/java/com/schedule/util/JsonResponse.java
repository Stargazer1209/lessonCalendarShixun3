package com.schedule.util;

/**
 * JSON响应工具类
 */
public class JsonResponse {
    
    /**
     * 创建成功响应
     */
    public static String success(String message) {
        return "{\"status\":\"success\",\"message\":\"" + escapeJson(message) + "\"}";
    }
    
    /**
     * 创建成功响应（带数据）
     */
    public static String success(String message, String data) {
        return "{\"status\":\"success\",\"message\":\"" + escapeJson(message) + "\",\"data\":" + data + "}";
    }
    
    /**
     * 创建错误响应
     */
    public static String error(String message) {
        return "{\"status\":\"error\",\"message\":\"" + escapeJson(message) + "\"}";
    }
    
    /**
     * 转义JSON字符串
     */
    private static String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}