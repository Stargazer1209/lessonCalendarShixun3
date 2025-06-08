Write-Host '正在编译所有Java文件...' -ForegroundColor Yellow

$javaFiles = Get-ChildItem -Path 'src/main/java' -Recurse -Filter '*.java' | ForEach-Object { $_.FullName }

if ($javaFiles.Count -gt 0) {
    javac '-J-Dfile.encoding=UTF-8' -encoding UTF-8 -cp 'src/main/webapp/WEB-INF/lib/*' -d 'src/main/webapp/WEB-INF/classes' $javaFiles
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ 编译成功，共编译 $($javaFiles.Count) 个Java文件" -ForegroundColor Green
    } else {
        Write-Host '✗ 编译失败' -ForegroundColor Red
    }
} else {
    Write-Host '未找到Java文件' -ForegroundColor Yellow
}