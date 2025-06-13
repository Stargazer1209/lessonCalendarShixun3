// 管理员统计页面 JavaScript

/**
 * 刷新统计数据
 */
function refreshStats() {
    const refreshBtn = document.querySelector('.refresh-btn');
    
    // 添加旋转动画
    refreshBtn.style.transform = 'scale(1.1) rotate(360deg)';
    
    // 延迟后重新加载页面
    setTimeout(() => {
        window.location.reload();
    }, 500);
}

/**
 * 动画计数器效果
 */
function animateNumbers() {
    const numbers = document.querySelectorAll('.stats-number');
    
    numbers.forEach(numberElement => {
        const targetNumber = parseInt(numberElement.textContent);
        let currentNumber = 0;
        const increment = Math.ceil(targetNumber / 50);
        const duration = 2000; // 2秒
        const stepTime = duration / (targetNumber / increment);
        
        const updateNumber = () => {
            if (currentNumber < targetNumber) {
                currentNumber += increment;
                if (currentNumber > targetNumber) {
                    currentNumber = targetNumber;
                }
                numberElement.textContent = currentNumber;
                setTimeout(updateNumber, stepTime);
            }
        };
        
        // 重置数字并开始动画
        numberElement.textContent = '0';
        setTimeout(updateNumber, 100);
    });
}

/**
 * 进度条动画
 */
function animateProgressBars() {
    const progressBars = document.querySelectorAll('.progress-fill');
    
    progressBars.forEach((bar, index) => {
        const targetWidth = bar.style.width;
        bar.style.width = '0%';
        
        setTimeout(() => {
            bar.style.width = targetWidth;
        }, 200 + index * 100);
    });
}

/**
 * 柱状图动画
 */
function animateChart() {
    const bars = document.querySelectorAll('.bar');
    
    bars.forEach((bar, index) => {
        const targetHeight = bar.style.height;
        bar.style.height = '5px';
        
        setTimeout(() => {
            bar.style.height = targetHeight;
        }, 300 + index * 150);
    });
}

/**
 * 统计卡片悬浮效果
 */
function initCardHoverEffects() {
    const cards = document.querySelectorAll('.stats-card');
    
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
            this.style.boxShadow = '0 15px 35px rgba(0, 0, 0, 0.15)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(-5px) scale(1)';
            this.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.1)';
        });
    });
}

/**
 * 柱状图交互效果
 */
function initChartInteractions() {
    const bars = document.querySelectorAll('.bar');
    
    bars.forEach(bar => {
        bar.addEventListener('click', function() {
            // 高亮选中的柱子
            bars.forEach(b => b.style.opacity = '0.5');
            this.style.opacity = '1';
            this.style.transform = 'scaleY(1.2)';
            
            // 3秒后恢复
            setTimeout(() => {
                bars.forEach(b => {
                    b.style.opacity = '1';
                    b.style.transform = 'scaleY(1)';
                });
            }, 3000);
        });
    });
}

/**
 * 自动更新时间显示
 */
function updateCurrentTime() {
    const now = new Date();
    const timeString = now.toLocaleString('zh-CN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        weekday: 'long'
    });
    
    // 如果页面有时间显示元素，更新它
    const timeElement = document.getElementById('currentTime');
    if (timeElement) {
        timeElement.textContent = `数据更新时间：${timeString}`;
    }
}

/**
 * 导出统计报告为PDF（简化版）
 */
function exportStatsToPDF() {
    // 创建一个新窗口用于打印
    const printWindow = window.open('', '_blank');
    const printContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <title>统计报告</title>
            <style>
                body { font-family: 'Microsoft YaHei', Arial, sans-serif; margin: 20px; }
                .stats-overview { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
                .stats-card { border: 1px solid #ddd; padding: 20px; text-align: center; border-radius: 8px; }
                .stats-number { font-size: 2rem; font-weight: bold; color: #4caf50; }
                .stats-label { color: #666; margin-top: 10px; }
                h1 { text-align: center; color: #333; }
                .section { margin-bottom: 30px; }
                .section-title { font-size: 1.3rem; font-weight: bold; border-bottom: 2px solid #eee; padding-bottom: 10px; }
            </style>
        </head>
        <body>
            <h1>课程表管理系统 - 统计报告</h1>
            <p style="text-align: center; color: #666;">生成时间：${new Date().toLocaleString('zh-CN')}</p>
            ${document.querySelector('.stats-overview').outerHTML}
            <div class="section">
                <div class="section-title">详细统计信息</div>
                <p>此报告包含了系统的关键统计数据，可用于分析系统使用情况和用户行为。</p>
            </div>
        </body>
        </html>
    `;
    
    printWindow.document.write(printContent);
    printWindow.document.close();
    
    // 延迟打印，确保内容加载完成
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 500);
}

/**
 * 添加键盘快捷键支持
 */
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Ctrl + R: 刷新统计
        if (e.ctrlKey && e.key === 'r') {
            e.preventDefault();
            refreshStats();
        }
        
        // Ctrl + P: 导出PDF
        if (e.ctrlKey && e.key === 'p') {
            e.preventDefault();
            exportStatsToPDF();
        }
    });
}

/**
 * 页面加载完成后的初始化
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('管理员统计页面已加载');
    
    // 初始化各种效果
    initCardHoverEffects();
    initChartInteractions();
    initKeyboardShortcuts();
    
    // 启动动画（延迟启动，确保页面渲染完成）
    setTimeout(() => {
        animateNumbers();
        animateProgressBars();
        animateChart();
    }, 300);
    
    // 更新时间显示
    updateCurrentTime();
    
    // 自动隐藏错误消息
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 300);
        }, 5000);
    });
    
    // 添加页面标题动态效果
    let titleIndex = 0;
    const titleIcons = ['📊', '📈', '📉', '📋'];
    setInterval(() => {
        const titleElement = document.querySelector('h1');
        if (titleElement) {
            titleIndex = (titleIndex + 1) % titleIcons.length;
            titleElement.textContent = `${titleIcons[titleIndex]} 数据统计报告`;
        }
    }, 5000);
});

/**
 * 实时数据监控（模拟）
 */
function startRealtimeMonitoring() {
    // 每30秒检查一次是否有新数据
    setInterval(() => {
        // 这里可以添加AJAX调用来检查新数据
        console.log('检查实时数据更新...');
        
        // 如果检测到新数据，可以显示通知
        // showNotification('发现新数据更新');
    }, 30000);
}

/**
 * 显示通知消息
 */
function showNotification(message) {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4caf50;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        z-index: 10000;
        opacity: 0;
        transform: translateX(100%);
        transition: all 0.3s ease;
    `;
    
    document.body.appendChild(notification);
    
    // 显示动画
    setTimeout(() => {
        notification.style.opacity = '1';
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // 自动隐藏
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// 启动实时监控
setTimeout(startRealtimeMonitoring, 2000);
