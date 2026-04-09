# 回忆岛

本项目是一个“回忆记录 + 小岛隐喻”的 Web 应用雏形，当前目录分为：

- `frontend`：Vue 2 + Vite 前端
- `backend`：Spring Boot 2.7 + MySQL 后端

## 当前这一轮已完成

- 初始化 Git 仓库
- 补齐根目录 `.gitignore`
- 后端新增回忆列表、回忆详情、创建回忆返回值接口
- 前端补齐“写回忆 -> 列表 -> 详情”闭环
- 后端不可用时，前端自动回退到本地数据模式，方便独立迭代

## 本地运行

### 1. 准备 MySQL

默认配置位于 [backend/src/main/resources/application.yml](/E:/memoryLand/backend/src/main/resources/application.yml)：

- 数据库：`memory_island`
- 用户名：`root`
- 密码：`123456`
- 端口：`8091`

如果你的 MySQL 配置不同，先修改该文件。

### 2. 启动后端

```powershell
cd E:\memoryLand\backend
mvn spring-boot:run
```

后端接口示例：

- `GET http://localhost:8091/api/overview`
- `GET http://localhost:8091/api/memories`

### 3. 启动前端

```powershell
cd E:\memoryLand\frontend
npm install
npm run dev
```

默认访问地址：

- 前端：`http://localhost:5173`
- 后端：`http://localhost:8091`

## 构建验证

已验证以下命令通过：

```powershell
cd E:\memoryLand\frontend
npm run build

cd E:\memoryLand\backend
mvn -q -DskipTests package
```

## 下一轮建议

优先级最高的几个方向：

1. 把“建筑页 / 岛屿总览页”从静态展示升级成真实可编辑视图
2. 给回忆补上图片、语音、标签和评论持久化
3. 开始接每日话题轮换、漂流瓶和共享合集的真实交互
