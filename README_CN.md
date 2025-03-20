# Dify for MySQL

这是一个 [https://github.com/langgenius/dify](https://github.com/langgenius/dify)  的 fork，我们基于原始的 Dify 项目进行了一些修改，使其能够使用 MySQL 作为基础数据库。

本分支基于历史版本 [https://github.com/oceanbase-devhub/dify](https://github.com/oceanbase-devhub/dify)，自 Dify 1.1.0 开始更新，后续将在官方社区加入 MySQL 适配前进行定期发布。

## 安装社区版

### 系统要求

在安装 Dify 之前，请确保您的机器满足以下最低系统要求：

- CPU >= 2 Core
- RAM >= 4 GiB

### 快速启动

启动 Dify 服务器的最简单方法是运行我们的 [docker-compose.yaml](docker/docker-compose.yaml) 文件。

在运行安装命令之前，请确保您的机器上安装了 [Docker](https://docs.docker.com/get-docker/) 和 [Docker Compose](https://docs.docker.com/compose/install/)，如果您想使用 MySQL 或 OceanBase 数据库来代替 Postgresql，请先准备一个可用的 MySQL 或 OceanBase 数据库，并且创建一个 database 供 Dify 使用。

启动服务的操作如下：

```bash
cd docker
bash setup-mysql-env.sh
docker compose up -d
```

说明：
- setup-mysql-env.sh 是一个设置参数的辅助脚本，它会根据用户输入更新 MySQL 的连接参数，同时设置 OceanBase 作为 Vector Store。
- 为了方便中国大陆地区的用户拉取 Docker 镜像，我们选择在 https://quay.io/repository/oceanbase-devhub 组织下维护本 Dify 分支的镜像，docker-compose.yaml 中必需的几个镜像地址也都改为了该地址。

运行后，可以在浏览器上访问 [http://localhost/install](http://localhost/install) 进入 Dify 控制台并开始初始化安装操作。

更多关于 Dify 使用的信息请参考 [https://dify.ai](https://dify.ai)。

## License

本仓库遵循 [Dify Open Source License](LICENSE) 开源协议，该许可证本质上是 Apache 2.0，但有一些额外的限制。
