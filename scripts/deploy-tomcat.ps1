# 课灵通 - Tomcat启动脚本
# 用于配置和启动Tomcat服务器

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "课灵通 - Tomcat启动脚本" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# 配置路径
$tomcatPath = "D:\0PROJECTS\JAVA\0MANUAL-PACK\tomcat9"
$javaHome = "C:\Program Files\Eclipse Adoptium\jdk-11.0.26.4-hotspot"
$projectPath = Get-Location
$webappName = "lessonCalendarShixun3"

# 检查Tomcat路径
if (-not (Test-Path $tomcatPath)) {
    Write-Host "错误: 未找到Tomcat安装路径: $tomcatPath" -ForegroundColor Red
    Write-Host "请确认Tomcat已正确解压到指定目录" -ForegroundColor Red
    exit 1
}

# 检查Java环境
if (-not (Test-Path $javaHome)) {
    Write-Host "错误: 未找到Java安装路径: $javaHome" -ForegroundColor Red
    Write-Host "请确认OpenJDK 11已正确安装" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Tomcat路径验证通过: $tomcatPath" -ForegroundColor Green
Write-Host "✓ Java路径验证通过: $javaHome" -ForegroundColor Green

# 设置环境变量
$env:CATALINA_HOME = $tomcatPath
$env:CATALINA_BASE = $tomcatPath
$env:JAVA_HOME = $javaHome
# 添加以下环境变量解决中文乱码
# $env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

Write-Host "✓ 环境变量设置完成" -ForegroundColor Green
Write-Host "  CATALINA_HOME: $env:CATALINA_HOME" -ForegroundColor Gray
Write-Host "  JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Gray

# 检查项目是否已编译
$classesPath = Join-Path $projectPath "src\main\webapp\WEB-INF\classes"
if (-not (Test-Path $classesPath)) {
    Write-Host "警告: 未找到编译后的class文件" -ForegroundColor Yellow
    Write-Host "请先编译Java代码" -ForegroundColor Yellow
    $choice = Read-Host "是否继续启动Tomcat? (y/n)"
    if ($choice -ne 'y' -and $choice -ne 'Y') {
        Write-Host "启动已取消" -ForegroundColor Yellow
        exit 0
    }
}

# 创建项目软链接到Tomcat webapps目录
$webappsPath = Join-Path $tomcatPath "webapps"
$projectLinkPath = Join-Path $webappsPath $webappName
$webappSourcePath = Join-Path $projectPath "src\main\webapp"

Write-Host "`n配置项目部署..." -ForegroundColor Yellow

# 删除现有的部署
if (Test-Path $projectLinkPath) {
    Write-Host "删除现有部署: $projectLinkPath" -ForegroundColor Gray
    Remove-Item $projectLinkPath -Recurse -Force -ErrorAction SilentlyContinue
}

try {
    # 创建符号链接 (需要管理员权限)
    New-Item -ItemType SymbolicLink -Path $projectLinkPath -Target $webappSourcePath -ErrorAction Stop
    Write-Host "✓ 项目符号链接创建成功" -ForegroundColor Green
} catch {
    Write-Host "警告: 符号链接创建失败，尝试复制文件..." -ForegroundColor Yellow
    try {
        Copy-Item $webappSourcePath $projectLinkPath -Recurse -Force
        Write-Host "✓ 项目文件复制成功" -ForegroundColor Green
    } catch {
        Write-Host "错误: 项目部署失败: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 检查端口占用
Write-Host "`n检查端口占用..." -ForegroundColor Yellow
$port8080 = netstat -an | Select-String ":8080.*LISTENING"
if ($port8080) {
    Write-Host "警告: 端口8080已被占用" -ForegroundColor Yellow
    Write-Host "现有占用: $($port8080 -join ', ')" -ForegroundColor Gray    
} else {
    Write-Host "✓ 端口8080未被占用" -ForegroundColor Green
}

# 启动Tomcat
# Community Server Connector提供了启动服务器的功能, 脚本仅作文件部署, 不再负责启动
# Write-Host "`n启动Tomcat服务器..." -ForegroundColor Yellow
# $catalinaBat = Join-Path $tomcatPath "bin\startup.bat"

# if (-not (Test-Path $catalinaBat)) {
#     Write-Host "错误: 未找到Tomcat启动脚本: $catalinaBat" -ForegroundColor Red
#     exit 1
# }

# try {
#     Write-Host "执行启动命令: $catalinaBat" -ForegroundColor Gray
#     Start-Process cmd -ArgumentList "/c", $catalinaBat -WindowStyle Normal
    
#     Write-Host "✓ Tomcat启动命令已执行" -ForegroundColor Green
#     Write-Host "等待服务器启动..." -ForegroundColor Yellow
    
#     # 等待服务器启动
#     for ($i = 1; $i -le 30; $i++) {
#         Start-Sleep -Seconds 1
#         try {
#             $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 2 -ErrorAction Stop
#             Write-Host "`n✅ Tomcat服务器启动成功！" -ForegroundColor Green
#             break
#         } catch {
#             Write-Host "." -NoNewline -ForegroundColor Gray
#             if ($i -eq 30) {
#                 Write-Host "`n⚠️ Tomcat启动超时，请手动检查" -ForegroundColor Yellow
#             }
#         }
#     }
    
# } catch {
#     Write-Host "错误: Tomcat启动失败: $($_.Exception.Message)" -ForegroundColor Red
#     exit 1
# }

# Write-Host "`n=====================================" -ForegroundColor Cyan
# Write-Host "Tomcat启动完成！" -ForegroundColor Green
# Write-Host "访问地址：" -ForegroundColor Cyan
# Write-Host "  Tomcat主页: http://localhost:8080" -ForegroundColor White
# Write-Host "  项目首页: http://localhost:8080/$webappName" -ForegroundColor White
# Write-Host "  项目首页: http://localhost:8080/$webappName/index.jsp" -ForegroundColor White
# Write-Host "`n管理界面：" -ForegroundColor Cyan  
# Write-Host "  Tomcat Manager: http://localhost:8080/manager" -ForegroundColor White
# Write-Host "=====================================" -ForegroundColor Cyan

# Write-Host "`n按任意键打开浏览器..." -ForegroundColor Gray
# $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# # 打开浏览器
# $url = "http://localhost:8080/$webappName"
# Start-Process $url
