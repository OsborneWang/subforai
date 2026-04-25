# Local Build Operations

这份文档对应当前服务器上的这套部署方式：

- 代码目录：`/srv/subforai`
- 部署目录：`/srv/subforai/deploy`
- 数据目录：
  - `deploy/data`
  - `deploy/postgres_data`
  - `deploy/redis_data`
- Compose 组合：
  - `docker-compose.local.yml`
  - `docker-compose.local-build.yml`

## 目标

这套方案的设计目标是：

- 服务使用当前本地仓库代码构建 Docker 镜像
- 继续复用当前已有数据目录
- 用 `docker compose` 管理整个服务
- 升级时不执行任何清库动作

## 文件说明

- `docker-compose.local.yml`
  - 原始本地目录部署配置，负责 PostgreSQL、Redis、数据挂载等
- `docker-compose.local-build.yml`
  - 覆盖 `sub2api` 服务，让应用镜像改为基于本地代码构建
- `appctl.sh`
  - 统一运维脚本

## 当前目录保留的核心文件

这个目录现在建议只维护下面这批文件：

- `.env`
- `.env.example`
- `.gitignore`
- `appctl.sh`
- `docker-compose.local.yml`
- `docker-compose.local-build.yml`
- `LOCAL_BUILD_OPERATIONS.md`
- `config.example.yaml`
- `Caddyfile`
- `codex-instructions.md.tmpl`
- `data/`
- `postgres_data/`
- `redis_data/`
- `backups/`

其他旧部署方式相关文件已经被视为 legacy，不再作为当前服务器的日常运维入口。

## 最常用命令

先进入部署目录：

```bash
cd /srv/subforai/deploy
```

### 1. 首次启动或常规启动

```bash
./appctl.sh up
```

效果：

- 基于 `/srv/subforai` 当前代码构建应用镜像
- 启动或更新 `sub2api`、`postgres`、`redis`
- 保留现有数据目录

### 2. 代码更新后重新部署

如果你已经手动更新了代码：

```bash
./appctl.sh deploy
```

如果你希望脚本先拉代码再部署：

```bash
./appctl.sh pull-deploy
```

说明：

- `pull-deploy` 会：
  - `git fetch origin`
  - `git reset --hard origin/main`
  - 自动清理旧部署文件
  - `docker compose ... up -d --build`

如果你只想同步代码并重新执行清理，不立刻启动服务：

```bash
./appctl.sh pull
```

### 3. 只看日志

```bash
./appctl.sh logs
```

### 4. 查看容器状态

```bash
./appctl.sh ps
```

### 5. 停止服务

```bash
./appctl.sh stop
```

说明：

- 这会停止容器
- 不会删除 `data/postgres_data/redis_data`

## 代码更新后的标准流程

建议用下面这套流程：

```bash
cd /srv/subforai
git pull --ff-only origin main

cd /srv/subforai/deploy
./appctl.sh upgrade
```

这里的 `upgrade` 会：

1. 先备份当前配置和数据
2. 再执行 `up -d --build`

如果你只是做了很小的前端或后端改动，也可以直接：

```bash
./appctl.sh deploy
```

## 备份怎么做

执行：

```bash
cd /srv/subforai/deploy
./appctl.sh backup
```

脚本会在 `deploy/backups/<UTC时间戳>/` 下生成：

- `.env`
- `app-data.tar.gz`
- `postgres.sql` 或 `postgres_data.tar.gz`
- `redis_data.tar.gz`
- `README.txt`

### 备份策略说明

- 如果 PostgreSQL 容器正在运行：
  - 优先做逻辑备份 `postgres.sql`
  - 这是更稳妥的数据库备份方式
- 如果 PostgreSQL 没在运行：
  - 退化为直接打包 `postgres_data`
- Redis 会先执行一次 `SAVE`，然后归档 `redis_data`

### 建议什么时候备份

下面这些情况，建议先做一次备份：

- 你准备 `git pull` 更新代码前
- 你准备修改 `deploy/.env` 前
- 你准备升级到一个跨版本改动较大的提交前
- 你准备手动调整数据库结构前
- 你准备迁移到新服务器前

## 数据迁移怎么理解

这套服务的“数据迁移”主要分两类。

### 1. 应用升级时自动数据库迁移

当新版本启动时，应用可能自动执行数据库 migration。

特点：

- 通常不会清空现有数据
- 可能会新增表、字段、索引，或执行数据回填
- 一旦迁移执行成功，通常是前向迁移，不建议直接回退旧代码

所以对于数据库迁移，正确做法是：

1. 先备份
2. 再升级
3. 升级后检查日志和页面是否正常

推荐命令：

```bash
./appctl.sh upgrade
```

### 2. 服务器迁移

如果你要把整套服务迁到新机器：

1. 先在旧机器执行 `./appctl.sh backup`
2. 复制下面这些内容到新机器：
   - `/srv/subforai`
   - 或至少复制 `deploy/.env`、`deploy/data`、`deploy/postgres_data`、`deploy/redis_data`
3. 在新机器上执行：

```bash
cd /srv/subforai/deploy
./appctl.sh up
```

## 出现问题时怎么处理

### 场景 1：代码更新后服务没起来

先看状态和日志：

```bash
./appctl.sh ps
./appctl.sh logs
```

重点看：

- Docker 构建是否失败
- 数据库迁移是否失败
- PostgreSQL 或 Redis 是否健康检查失败
- `.env` 是否缺少新增环境变量

### 场景 2：前端页面不对，怀疑没用到最新代码

处理顺序：

```bash
cd /srv/subforai
git log --oneline -n 1

cd /srv/subforai/deploy
./appctl.sh deploy
```

如果还不对，再检查浏览器缓存和反向代理缓存。

### 场景 3：升级后数据库报错

处理建议：

1. 先不要反复重启
2. 先保留当前现场
3. 导出日志
4. 确认升级前是否做过备份

如果升级前做过备份，优先考虑：

- 新建一套测试环境验证恢复
- 确认问题后再执行数据库恢复

不要直接删除 `postgres_data` 试图“重来”，这会直接丢失数据。

### 场景 4：容器都停了，但数据还在不在

只要下面这些目录还在，数据通常就在：

- `deploy/data`
- `deploy/postgres_data`
- `deploy/redis_data`

这时通常只需要：

```bash
./appctl.sh up
```

### 场景 5：我想彻底重建应用，但不能动数据

可以执行：

```bash
./appctl.sh deploy
```

这个动作会重建并重启服务，但不会删数据目录。

### 场景 6：我想删除容器重新来

可以：

```bash
./appctl.sh stop
./appctl.sh up
```

不可以：

```bash
docker compose down -v
rm -rf data postgres_data redis_data
```

上面这两类命令会直接破坏数据。

### 场景 7：我发现更新代码后，旧部署文件又回来了

这是因为它们在上游仓库里仍然存在，代码同步时会被恢复。

处理方式：

```bash
./appctl.sh tidy
```

如果你本来就要升级，直接使用：

```bash
./appctl.sh pull-deploy
```

脚本会自动完成同步和清理。

## 明确禁止的危险操作

除非你明确要清空数据，否则不要做这些事：

```bash
docker compose -f docker-compose.local.yml -f docker-compose.local-build.yml down -v
rm -rf /srv/subforai/deploy/data
rm -rf /srv/subforai/deploy/postgres_data
rm -rf /srv/subforai/deploy/redis_data
```

## 推荐日常操作清单

### 日常发布

```bash
cd /srv/subforai
git pull --ff-only origin main
cd /srv/subforai/deploy
./appctl.sh upgrade
```

### 只重启服务

```bash
cd /srv/subforai/deploy
./appctl.sh restart
```

### 看日志排错

```bash
cd /srv/subforai/deploy
./appctl.sh logs
```

### 升级前先备份

```bash
cd /srv/subforai/deploy
./appctl.sh backup
./appctl.sh deploy
```
