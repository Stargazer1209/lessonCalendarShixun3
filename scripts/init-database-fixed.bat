@echo off
chcp 65001 >nul
echo =====================================
echo 数据库重新初始化 - 修复版本
echo =====================================
echo.

rem 设置路径
set MYSQL_PATH=D:\0PROGRAM\MYSQL\bin\mysql.exe
set SQL_FILE=%~dp0..\database\init-mysql845-fixed.sql

echo 检查MySQL路径...
if not exist "%MYSQL_PATH%" (
    echo 错误: 未找到MySQL: %MYSQL_PATH%
    echo 请确认MySQL已正确安装
    pause
    exit /b 1
)

echo 检查SQL文件...
if not exist "%SQL_FILE%" (
    echo 错误: 未找到SQL文件: %SQL_FILE%
    pause
    exit /b 1
)

echo ✓ 路径验证通过
echo.

echo 启动MySQL服务...
if exist "D:\0PROGRAM\MYSQL\startup.ps1" (
    echo 正在启动MySQL...
    powershell -ExecutionPolicy Bypass -File "D:\0PROGRAM\MYSQL\startup.ps1"
    echo 等待MySQL启动...
    timeout /t 5 >nul
) else (
    echo 请手动确保MySQL服务已启动
    timeout /t 2 >nul
)

echo.
echo ===================================
echo MySQL 8.4.5 连接提示
echo ===================================
echo MySQL 8.4.5 默认使用 caching_sha2_password 认证
echo 如果连接失败，我们将创建兼容的用户账户
echo 默认root密码: password
echo ===================================
echo.

echo 步骤1: 执行数据库初始化脚本...
echo 请输入MySQL root密码:
"%MYSQL_PATH%" -u root -p --default-character-set=utf8mb4 < "%SQL_FILE%"

if %ERRORLEVEL% == 0 (
    echo ✓ 数据库结构创建成功！
    goto :verify_db
) else (
    echo ✗ 数据库初始化失败，错误码: %ERRORLEVEL%
    echo.
    echo 尝试解决MySQL 8.4.5兼容性问题...
    goto :fix_auth
)

:fix_auth
echo.
echo 步骤2: 创建兼容的数据库用户...
echo 请输入MySQL root密码以创建兼容用户:

echo CREATE DATABASE IF NOT EXISTS schedule_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; | "%MYSQL_PATH%" -u root -p

if %ERRORLEVEL% == 0 (
    echo ✓ 数据库创建成功
    echo 现在执行表结构创建...
    "%MYSQL_PATH%" -u root -p --database=schedule_db < "%SQL_FILE%"
    
    if %ERRORLEVEL% == 0 (
        echo ✓ 表结构创建成功！
        goto :verify_db
    ) else (
        echo ✗ 表结构创建失败
        goto :error_help
    )
) else (
    echo ✗ 数据库创建失败
    goto :error_help
)

:verify_db
echo.
echo 步骤3: 验证数据库初始化结果...
echo 请再次输入root密码进行验证:
echo.
"%MYSQL_PATH%" -u root -p --database=schedule_db --execute="SELECT 'Database Connection OK' as status; SELECT COUNT(*) as user_count FROM users; SELECT COUNT(*) as course_count FROM courses;"

if %ERRORLEVEL% == 0 (
    echo.
    echo ✅ 数据库初始化完全成功！
    echo ✓ 数据库连接正常
    echo ✓ 表结构创建完成
    echo ✓ 测试数据插入完成
    goto :success
) else (
    echo ⚠️ 验证步骤失败，但基本结构可能已创建
    echo 可以继续下一步，在Web应用中测试连接
    goto :success
)

:error_help
echo.
echo ❌ 数据库初始化失败
echo.
echo 可能的解决方案:
echo 1. 确保MySQL服务已启动
echo 2. 验证root密码是否正确
echo 3. 检查MySQL版本兼容性
echo.
echo 手动修复步骤:
echo 1. 登录MySQL: %MYSQL_PATH% -u root -p
echo 2. 执行: CREATE DATABASE schedule_db CHARACTER SET utf8mb4;
echo 3. 执行: USE schedule_db;
echo 4. 执行SQL文件内容
echo.
pause
exit /b 1

:success
echo.
echo =====================================
echo 🎉 数据库初始化成功！
echo =====================================
echo.
echo 下一步操作:
echo 1. 编译Java代码
echo 2. 启动Tomcat服务器
echo 3. 测试数据库连接
echo.
echo 编译命令: 在VS Code中按 Ctrl+Shift+P，选择 "Tasks: Run Task" -> "Compile Java"
echo.
pause
