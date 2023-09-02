# SQL With Docker

This repository contains scripts to execute SQL files inside Docker containers for different SQL databases. The scripts simplify the process of setting up, running, and cleaning up after the SQL execution.

## Getting Started

### Clone the Repository

To get started, first clone the repository to your local machine:

```bash
git clone https://github.com/serial-techos/sql-with-docker.git
cd sql-with-docker
```

### Repository Structure

```bash
.
├── db.yaml                    # Configuration file for databases
├── docker-sql.sh              # Main script to run SQL on Docker
├── examples                   # Example SQL scripts
│   ├── daily_sales_report.sql
│   ├── recommendations.sql
│   ├── users.sql
│   └── video_views.sql
├── LICENSE
├── README.md
└── utils.sh                   # Utility functions for the main script
```

## Prerequisites

1. Docker installed and running on your machine.
2. Ensure `yq` is installed (for parsing yaml files).

## How to use

### 1. File Execution Mode

Use this mode to execute SQL from a file on a database server.

```bash
./docker-sql.sh /path/to/query.sql <sql-db-keyword>
```
Replace `/path/to/query.sql` with the path to your SQL file, and `sql-db-keyword` with the keyword for your desired SQL database (e.g., `postgres` or `mysql`).
> This keyword should be the docker image name found in [Docker Hub](https://hub.docker.com/).


For example, to execute the `users.sql` script on a MySQL instance:

```bash
./docker-sql.sh examples/users.sql mysql
```

### 2. Interactive Mode

Use this mode to run SQL interactively on a database server. When in this mode, you'll be dropped into a bash CLI where you can use the command `run-query` followed by the path to the SQL file you want to execute.

```bash
./docker-sql.sh client /path/to/queries/ <sql-db-keyword>
```

For example, to run interactively on a PostgreSQL instance:

```bash
./docker-sql.sh client examples/ postgres
```

In the container , run:

```bash
run-query examples/users.sql
```



## Configuration

The `db.yaml` file contains configurations for different database systems. Here's a brief overview:

```yaml
postgres:
  SQL_CMD: "psql -U postgres -a -f {PATH}"  # SQL Command with placeholder for file path
  DOCKER_ENV: "-e POSTGRES_PASSWORD=mysecretpassword"  # Environment variables for Docker
  VERSION: 13  # Docker image version

mysql:
  SQL_CMD: "mysql -uroot -proot -D mysql < {PATH}"
  DOCKER_ENV: "-e MYSQL_ROOT_PASSWORD=root"
  VERSION: latest
```

You can add more configurations by following the existing format in `db.yaml`.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## TODO
- [ ] Implement this in python to enhance `cross-platform` compatibility.
- [ ]  Add functionality for data/table loading from files(`.csv`, `.json`, etc...).
- [ ] Incorporate data generation using LLMs (e.g., `gpt3.5`).
- [ ] Set up and publish the package to make it `command line ready`.
- [ ] Support more database systems like `SQLite`, `MSSQL`, etc.
- [ ] Implement `error handling` for common scenarios (e.g., Docker not running, invalid SQL syntax).
- [ ] Implement `linting` and `formatting` for SQL queries.

- [ ] Add support for `persistent storage` to retain data across sessions.



## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.



