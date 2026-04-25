# 本地开发与线上生产环境说明

这份文档把项目当前推荐的两套运行方式放在一起说明：

- 本地开发环境：`PostgreSQL / Redis` 用 Docker，前后端直接在宿主机启动
- 线上生产环境：使用 `deploy/appctl.sh` 管理整套 Docker Compose 服务

目标是做到：

1. 本地开发时改代码快，能直接验证前后端通信、登录和业务流程
2. 发布前可以用接近线上的一套方式再次确认测试和构建
3. 线上环境继续复用现有 `deploy` 目录和 `appctl.sh` 运维方式

## 一、环境分工

### 1. 本地开发环境

推荐用途：

- 日常改前端、后端代码
- 联调登录、接口、页面交互
- 本地跑测试和构建

运行方式：

- `PostgreSQL / Redis`：Docker
- `backend`：宿主机源码启动
- `frontend`：宿主机源码启动

### 2. 线上生产环境

推荐用途：

- 正式部署
- 更新线上代码
- 查看日志、备份、迁移、重启

运行方式：

- `subforai / postgres / redis` 全部由 Docker Compose 管理
- 统一入口：`deploy/appctl.sh`

## 二、本地开发环境

### 1. 设计原则

本地开发环境尽量复用线上部署的关键配置：

- 继续使用 `deploy/.env`
- 继续使用 `deploy/data`
- 继续使用 `deploy/postgres_data`
- 继续使用 `deploy/redis_data`

区别在于：

- 本地只用 Docker 起 `PostgreSQL / Redis`
- 前后端源码直接在宿主机运行，不用每次改代码都重建应用镜像

### 2. 相关文件

- `deploy/.env`
- `deploy/docker-compose.local.yml`
- `deploy/docker-compose.dev-host.yml`
- `tools/dev-source-env.sh`
- 根目录 `Makefile`

### 3. 启动步骤

先确保：

- Docker Desktop 已启动
- `deploy/.env` 已存在
- 前端依赖已安装：`pnpm --dir frontend install`

#### 第一步：启动数据库和缓存

```bash
make dev-deps-up
```

这会启动：

- `PostgreSQL`
- `Redis`

并把端口映射到宿主机：

- `127.0.0.1:5432`
- `127.0.0.1:6379`

#### 第二步：查看源码模式将使用的环境变量

```bash
make dev-env-print
```

这个命令会基于 `deploy/.env` 补齐源码运行所需的变量，例如：

- `DATABASE_HOST=127.0.0.1`
- `DATABASE_USER`
- `DATABASE_PASSWORD`
- `DATABASE_DBNAME`
- `REDIS_HOST=127.0.0.1`
- `DATA_DIR=deploy/data`

#### 第三步：启动后端

```bash
make dev-backend
```

等价于：

```bash
tools/dev-source-env.sh backend
```

默认会在本机启动后端服务，地址通常是：

```text
http://127.0.0.1:8080
```

#### 第四步：启动前端

新开一个终端执行：

```bash
make dev-frontend
```

默认前端开发地址通常是：

```text
http://127.0.0.1:3000
```

前端会通过 Vite 开发代理把 `/api`、`/v1`、`/setup` 请求转发到本地后端，因此可以直接测试：

- 登录
- 页面跳转
- 接口请求
- 前后端联调

### 4. 停止本地开发依赖

```bash
make dev-deps-down
```

查看数据库 / Redis 日志：

```bash
make dev-deps-logs
```

### 5. 本地开发时的常见注意事项

#### 端口冲突

如果你本机已经跑着完整应用容器，并占用了 `8080`，那么源码后端启动前要先停掉那个应用容器，否则会端口冲突。

保留 `postgres / redis` 没问题，但应用服务不能同时占同一个端口。

#### `deploy/.env` 是统一基线

本地开发环境和线上部署环境都尽量基于 `deploy/.env`。

这意味着：

- 本地联调时看到的问题，更容易接近线上行为
- 发布前不用重新维护另一套完全独立的配置

#### Docker 里只跑依赖，不跑应用

本地开发阶段，不建议每改一点代码都执行整套应用镜像重建。

更合适的方式是：

- 数据库 / Redis 用 Docker
- 前后端用源码运行

这样调试速度会快很多。

## 三、发布前确认流程

本地开发完成后，推线上之前至少做两层确认。

### 1. 源码层确认

执行：

```bash
make release-check
```

它会顺序执行：

- `make test`
- `make build`

也就是：

- 后端测试
- 前端 lint / typecheck / 关键测试
- 后端构建
- 前端构建

如果这里不过，先不要推线上。

### 2. 线上方式确认

如果你准备上线，建议在正式推线上前，再按 Docker / `appctl.sh` 这条链路做一次确认，重点确认：

- `Dockerfile` 没问题
- `deploy/.env` 没缺新变量
- Docker Compose 能正常重建

如果你的本机或测试机能正常访问 Docker Hub，可以进一步执行：

```bash
cd deploy
./appctl.sh deploy
```

这样可以在接近线上运行模型下再验证一遍。

## 四、线上生产环境

### 1. 目录约定

当前线上推荐结构：

```text
/srv/subforai
/srv/subforai/deploy
```

部署目录中核心内容：

- `deploy/.env`
- `deploy/appctl.sh`
- `deploy/docker-compose.local.yml`
- `deploy/docker-compose.local-build.yml`
- `deploy/data`
- `deploy/postgres_data`
- `deploy/redis_data`

### 2. 首次启动

```bash
cd /srv/subforai/deploy
./appctl.sh up
```

效果：

- 基于当前仓库代码构建应用镜像
- 启动 `subforai / postgres / redis`
- 保留本地目录数据

### 3. 常用线上运维命令

```bash
./appctl.sh deploy
./appctl.sh upgrade
./appctl.sh logs
./appctl.sh ps
./appctl.sh stop
./appctl.sh backup
./appctl.sh pull
./appctl.sh pull-deploy
```

说明：

- `deploy`：重建并重启服务
- `upgrade`：先备份，再重建并重启
- `logs`：查看日志
- `ps`：查看容器状态
- `stop`：停止服务但不清数据
- `backup`：备份 `.env` 和数据目录
- `pull`：同步代码但不启动
- `pull-deploy`：同步代码后立即重建部署

### 4. 推荐的线上更新流程

#### 小改动

```bash
cd /srv/subforai
git pull --ff-only origin main

cd deploy
./appctl.sh deploy
```

#### 重要升级

```bash
cd /srv/subforai
git pull --ff-only origin main

cd deploy
./appctl.sh upgrade
```

`upgrade` 更稳，因为它会先备份。

### 5. 线上更新时的注意事项

- 不要随意执行 `docker compose down -v`
- 重要升级前先做 `./appctl.sh backup`
- 数据库迁移通常是前向的，升级后不要假设可以无损回退旧代码
- 如果服务起不来，先看 `./appctl.sh ps` 和 `./appctl.sh logs`

## 五、推荐工作流

日常开发和上线建议统一成下面这条流程：

1. 本地启动 `PostgreSQL / Redis`
2. 本地源码启动 `backend / frontend`
3. 开发并完成联调验证
4. 执行 `make release-check`
5. 提交并推送代码
6. 在线上机器执行 `./appctl.sh deploy` 或 `./appctl.sh upgrade`
7. 检查线上日志和页面是否正常

## 六、快速命令清单

### 本地开发

```bash
make dev-deps-up
make dev-env-print
make dev-backend
make dev-frontend
make dev-deps-down
```

### 发布前确认

```bash
make release-check
```

### 线上部署

```bash
cd /srv/subforai/deploy
./appctl.sh deploy
./appctl.sh upgrade
./appctl.sh logs
./appctl.sh ps
./appctl.sh backup
```
