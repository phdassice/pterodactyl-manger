# Pterodactyl 工具安裝指南

本工具提供多種安裝方式，選擇最適合你的方法。

## 🚀 方法一：快速安裝（推薦）

### 使用 curl 一鍵安裝

```bash
curl -fsSL https://raw.githubusercontent.com/phdassice/pterodactyl-manager/main/install.sh | sudo bash
```

### 使用 wget 一鍵安裝

```bash
wget -qO- https://raw.githubusercontent.com/phdassice/pterodactyl-manager/main/install.sh | sudo bash
```

---

## 📦 方法二：本地安裝

### 1. 下載或克隆倉庫

```bash
# 使用 git clone
git clone https://github.com/phdassice/pterodactyl-manager.git
cd pterodactyl-manager

# 或直接下載文件到服務器
```

### 2. 運行安裝腳本

```bash
sudo bash install.sh
```

---

## 🛠️ 方法三：手動安裝

如果安裝腳本有問題，可以手動安裝：

```bash
# 1. 下載主工具
sudo curl -fsSL https://raw.githubusercontent.com/phdassice/pterodactyl-manager/main/ptero-manager.sh \
  -o /usr/local/bin/ptero-manager

# 2. 設置執行權限
sudo chmod +x /usr/local/bin/ptero-manager

# 4. 驗證安裝
ptero-manager --help
```

---

## ✅ 驗證安裝

安裝完成後，測試工具是否正常工作：

```bash
# 測試主工具
ptero-manager

# 測試快速命令
ptero-quick status
```

---

## 📋 使用方法

### 交互式菜單（推薦）

```bash
ptero-manager
```

啟動後會看到包含 19 個功能選項的完整菜單。

### 快速命令

```bash
# 查看所有命令
ptero-quick

# 常用命令示例
ptero-quick cache-clear         # 清除快取
ptero-quick restart-wings       # 重啟 Wings
ptero-quick maintenance-on      # 進入維護模式
ptero-quick maintenance-off     # 退出維護模式
ptero-quick restart-all         # 重啟所有服務
ptero-quick status              # 查看服務狀態
```

---

## 🔄 更新工具

重新運行安裝腳本即可更新：

```bash
# 快速更新
curl -fsSL https://raw.githubusercontent.com/phdassice/pterodactyl-manager/main/install.sh | sudo bash

# 或本地更新
cd pterodactyl-manager
git pull
sudo bash install.sh
```

---

## 🗑️ 卸載工具

```bash
sudo rm /usr/local/bin/ptero-manager
sudo rm /usr/local/bin/ptero-quick
echo "Pterodactyl 工具已卸載"
```

---

## 📌 系統要求

- Ubuntu 20.04/22.04 或 CentOS 7/8/Rocky Linux 8
- Root 權限或 sudo 權限
- 已安裝 Pterodactyl 面板（除了快速安裝功能）
- 網絡連接（用於遠程安裝）

---

## 🔧 故障排除

### 問題：curl 命令失敗

**解決方案**：
```bash
# 安裝 curl
sudo apt install curl -y    # Ubuntu/Debian
sudo yum install curl -y    # CentOS/RHEL
```

### 問題：權限不足

**解決方案**：
```bash
# 使用 sudo 運行
sudo bash install.sh
```

### 問題：找不到命令

**解決方案**：
```bash
# 檢查 PATH
echo $PATH | grep -q "/usr/local/bin" || echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 問題：GitHub 無法訪問

**解決方案**：使用本地安裝方法（方法二或方法三）

---

## 🌐 不使用 GitHub 的替代方案

如果你沒有 GitHub 或不想上傳到 GitHub，可以：

### 1. 使用自己的服務器

將文件上傳到你的服務器，然後修改安裝腳本中的 URL：

```bash
# 在 install.sh 中修改這一行
REPO_URL="https://your-domain.com/path/to/files"
```

然後使用：
```bash
curl -sSL https://your-domain.com/install.sh | sudo bash
```

### 2. 使用 Gist

1. 將文件上傳到 GitHub Gist
2. 獲取 Raw URL
3. 修改安裝腳本中的 URL

### 3. 僅本地安裝

如果只在本地使用，直接使用方法二（本地安裝）即可。

---

## 💡 提示

- 首次安裝建議使用交互式菜單熟悉功能
- 熟悉後可以使用快速命令提高效率
- 定期備份面板數據（選項 12）
- 更新前建議先進入維護模式（選項 3）

---

## 📞 獲取幫助

如有問題，請檢查：
1. 是否使用 root 或 sudo 權限
2. 是否已安裝 Pterodactyl 面板
3. 網絡連接是否正常
4. 服務器是否滿足系統要求

---

**作者**: Beach  
**創建日期**: 2026-01-04  
**版本**: 1.0.0
