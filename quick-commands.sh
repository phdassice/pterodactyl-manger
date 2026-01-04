#!/bin/bash

# Pterodactyl 快速命令集合
# 可以直接執行單一命令，不需要進入菜單

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PANEL_PATH="/var/www/pterodactyl"

# 檢查root權限
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}請使用 root 權限運行${NC}"
    exit 1
fi

# 顯示幫助
show_help() {
    echo "Pterodactyl 快速命令工具"
    echo ""
    echo "使用方法: $0 [命令]"
    echo ""
    echo "可用命令:"
    echo "  cache-clear       - 清除所有快取"
    echo "  cache-optimize    - 優化快取"
    echo "  maintenance-on    - 進入維護模式"
    echo "  maintenance-off   - 退出維護模式"
    echo "  restart-wings     - 重啟 Wings"
    echo "  restart-panel     - 重啟面板服務"
    echo "  restart-all       - 重啟所有服務"
    echo "  status            - 查看服務狀態"
    echo "  fix-permissions   - 修復權限"
    echo "  update            - 更新面板"
    echo "  logs              - 查看 Laravel 日誌"
    echo ""
    echo "示例:"
    echo "  $0 cache-clear"
    echo "  $0 restart-wings"
}

case "$1" in
    cache-clear)
        echo -e "${BLUE}清除快取...${NC}"
        cd $PANEL_PATH
        php artisan view:clear && \
        php artisan config:clear && \
        php artisan route:clear && \
        php artisan cache:clear
        echo -e "${GREEN}✓ 完成${NC}"
        ;;
    
    cache-optimize)
        echo -e "${BLUE}優化快取...${NC}"
        cd $PANEL_PATH
        php artisan config:cache && \
        php artisan route:cache && \
        php artisan view:cache && \
        composer dump-autoload -o
        echo -e "${GREEN}✓ 完成${NC}"
        ;;
    
    maintenance-on)
        echo -e "${YELLOW}進入維護模式...${NC}"
        cd $PANEL_PATH
        php artisan down --message="系統維護中" --retry=60
        echo -e "${GREEN}✓ 已進入維護模式${NC}"
        ;;
    
    maintenance-off)
        echo -e "${YELLOW}退出維護模式...${NC}"
        cd $PANEL_PATH
        php artisan up
        echo -e "${GREEN}✓ 已退出維護模式${NC}"
        ;;
    
    restart-wings)
        echo -e "${BLUE}重啟 Wings...${NC}"
        systemctl restart wings
        sleep 2
        if systemctl is-active --quiet wings; then
            echo -e "${GREEN}✓ Wings 重啟成功${NC}"
        else
            echo -e "${RED}✗ Wings 重啟失敗${NC}"
        fi
        ;;
    
    restart-panel)
        echo -e "${BLUE}重啟面板服務...${NC}"
        systemctl restart nginx
        for v in 8.3 8.2 8.1 8.0 7.4; do
            if systemctl list-unit-files | grep -q "php${v}-fpm"; then
                systemctl restart php${v}-fpm
                break
            fi
        done
        [ -f /etc/systemd/system/redis.service ] && systemctl restart redis
        echo -e "${GREEN}✓ 完成${NC}"
        ;;
    
    restart-all)
        echo -e "${BLUE}重啟所有服務...${NC}"
        $0 restart-panel
        $0 restart-wings
        echo -e "${GREEN}✓ 完成${NC}"
        ;;
    
    status)
        echo -e "${CYAN}=== 服務狀態 ===${NC}"
        echo -e "\n${BLUE}Nginx:${NC}"
        systemctl is-active nginx && echo -e "${GREEN}運行中${NC}" || echo -e "${RED}已停止${NC}"
        echo -e "\n${BLUE}Wings:${NC}"
        systemctl is-active wings && echo -e "${GREEN}運行中${NC}" || echo -e "${RED}已停止${NC}"
        echo -e "\n${BLUE}Redis:${NC}"
        systemctl is-active redis && echo -e "${GREEN}運行中${NC}" || echo -e "${RED}已停止${NC}"
        ;;
    
    fix-permissions)
        echo -e "${BLUE}修復權限...${NC}"
        WEB_USER="www-data"
        [ -f /etc/redhat-release ] && WEB_USER="nginx"
        chown -R $WEB_USER:$WEB_USER $PANEL_PATH/*
        chmod -R 755 $PANEL_PATH/storage/* $PANEL_PATH/bootstrap/cache
        echo -e "${GREEN}✓ 完成${NC}"
        ;;
    
    update)
        echo -e "${YELLOW}更新面板...${NC}"
        cd $PANEL_PATH
        php artisan down
        curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
        chmod -R 755 storage/* bootstrap/cache
        composer install --no-dev --optimize-autoloader
        php artisan migrate --force --seed
        php artisan view:clear
        php artisan config:clear
        php artisan up
        echo -e "${GREEN}✓ 更新完成${NC}"
        ;;
    
    logs)
        tail -f $PANEL_PATH/storage/logs/laravel.log
        ;;
    
    *)
        show_help
        exit 1
        ;;
esac
