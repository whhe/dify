# Dify for MySQL

This is a fork of [https://github.com/langgenius/dify](https://github.com/langgenius/dify) . We made some modifications based on the original Dify project to enable it to use MySQL as the database.

This branch is based on the legacy version [https://github.com/oceanbase-devhub/dify](https://github.com/oceanbase-devhub/dify) and has been maintained since Dify 1.1.0. It will be released regularly before the official community implements MySQL adaptation.

## Quick start

> Before installing Dify, make sure your machine meets the following minimum system requirements:
>
> - CPU >= 2 Core
> - RAM >= 4 GiB

The easiest way to start the Dify server is through [docker-compose.yaml](docker/docker-compose.yaml). 

Before running Dify with the following commands, make sure that [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) are installed on your machine. If you want to use MySQL or OceanBase database to replace Postgresql, please prepare an MySQL or OceanBase database and create a database for Dify to use.

```bash
cd docker
bash setup-mysql-env.sh
docker compose up -d
```

Note:
- setup-mysql-env.sh is a script for setting database parameters. It will update the parameters for MySQL connection according to the user input and set OceanBase as the Vector Store.
- In order to facilitate users in mainland China to pull Docker images, we choose to maintain the images of this Dify branch under the organization https://quay.io/repository/oceanbase-devhub, and the several required images in docker-compose.yaml are also changed to this registry.

After running, you can access the Dify dashboard in your browser at [http://localhost/install](http://localhost/install) and start the initialization process.

For more information on using Dify, please refer to [https://dify.ai](https://dify.ai).

## License

This repository is available under the [Dify Open Source License](LICENSE), which is essentially Apache 2.0 with a few additional restrictions.
