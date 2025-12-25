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

## UI/UX Standards
To maintain a consistent and professional look across the application, all new and updated pages MUST follow these Bootstrap 5 patterns.

### Layout & Containers
- **Main Container**: Wrap all content in a `<div class="container-fluid">`.
- **Page Titles**: Use the `.pagetitle` class with a breadcrumb navigation:
  ```erb
  <div class="pagetitle">
    <h1>Page Name</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><%= link_to "Home", root_path %></li>
        <li class="breadcrumb-item active">Page Name</li>
      </ol>
    </nav>
  </div>
  ```
- **Sections & Cards**: Organize content within `<section class="section">` using Bootstrap `.card` components for layout.

### Tables
- Use `.table .table-hover .align-middle` classes.
- Wrap tables in a `<div class="table-responsive">` inside the card body.
- **Actions**: Use `.btn-group` with Bootstrap Icons (e.g., `bi-pencil`, `bi-trash`, `bi-eye`) for row actions instead of text links.

### Forms
- **Layout**: Use `.row .g-3` for form grids.
- **Labels & Controls**: Apply `.form-label`, `.form-control`, and `.form-select`.
- **Switches**: Use Bootstrap 5 switches for boolean toggles:
  ```erb
  <div class="form-check form-switch">
    <%= f.check_box :attribute, class: "form-check-input" %>
    <%= f.label :attribute, class: "form-check-label" %>
  </div>
  ```
- **Actions**: Center primary actions at the bottom of the form using `.text-center .mt-4`.

### Visual Components
- **Icons**: Use [Bootstrap Icons](https://icons.getbootstrap.com/) (`<i class="bi bi-..."></i>`) to provide visual cues for data and actions.
- **Badges**: Use color-coded badges for status or roles (e.g., `.bg-success`, `.bg-danger`, `.bg-info`, `.bg-secondary`).
- **Information Alerts**: Use `.alert .alert-info .d-flex .align-items-center` for contextual information.
