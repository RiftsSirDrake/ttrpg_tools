# Development Guidelines

## Docker-First Environment
This project is designed to be run using Docker. All development commands, especially Rails and Rake commands, MUST be executed within the Docker container to ensure environment consistency and access to the database.

### Running Commands
Do not run `rails` or `rake` commands directly on your host machine. Use `docker-compose exec` to run them inside the running `web` service.

#### Common Commands
- **Start the environment:**
  ```bash
  docker-compose up
  ```

- **Run Database Migrations:**
  ```bash
  docker-compose exec web rails db:migrate
  ```

- **Generate a Migration/Model/Controller:**
  ```bash
  docker-compose exec web rails generate ...
  ```

- **Run Tests:**
  ```bash
  docker-compose exec web rails test
  ```

- **Rails Console:**
  ```bash
  docker-compose exec web rails console
  ```

- **Bundle Install (if needed while running):**
  ```bash
  docker-compose exec web bundle install
  ```

### Database Access
The database is running in the `db` container. The Rails application is configured to connect to it using the environment variables defined in `docker-compose.yml`.

### Troubleshooting
If you encounter permission issues or files not updating, ensure that Docker has proper access to the project directory.
