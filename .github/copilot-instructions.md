# GitHub Copilot Instructions

## Project Context
This is a Ruby on Rails 8.0.2.1 application for motorcycle service management (TecnoMotos).

## Framework & Version
- **Rails Version:** 8.0.2.1 (ONLY use Rails 8 syntax and conventions)
- **Database:** SQLite3
- **CSS:** Tailwind CSS (desktop-only, NO mobile responsiveness)
- **Authentication:** Custom session-based (NO Devise)

## Language Conventions
- **Interface:** Spanish
- **Database:** Spanish naming (except `users` and `sessions` tables)
- **Models:** Spanish names (Cliente, Vehiculo, etc.) except User model

## Rails 8 Specific Syntax

### Enums (IMPORTANT - Rails 8 syntax)
```ruby
# ✅ CORRECT Rails 8 syntax
enum :cargo, {
  administrador: 0,
  tecnico: 1,
  comercial: 2,
  administrativo: 3
}

# ❌ WRONG (older Rails versions)
enum cargo: { ... }
```

### Migrations
```ruby
class CreateClientes < ActiveRecord::Migration[8.0]
  # Rails 8 migration structure
end
```

## CSS Guidelines
- Use ONLY desktop Tailwind classes
- NO responsive classes (sm:, md:, lg:, xl:)
- Standard layout: `max-w-4xl mx-auto px-4`

## Authentication
- All views require authentication EXCEPT login and password recovery
- Use custom `Authentication` concern
- Helper methods: `current_user`, `user_signed_in?`

## Project Structure
```
app/
├── controllers/
│   ├── concerns/
│   │   └── authentication.rb
│   ├── application_controller.rb
│   ├── clientes_controller.rb
│   ├── vehiculos_controller.rb
│   └── users_controller.rb
├── models/
│   ├── cliente.rb (Spanish)
│   ├── vehiculo.rb (Spanish)
│   └── user.rb (English - exception)
└── views/
    ├── clientes/
    ├── vehiculos/
    └── users/
```

## Key Models
- `Cliente` (clients) - Spanish
- `Vehiculo` (vehicles) - Spanish  
- `User` (users) - English exception with cargo enum
- All relationships in Spanish except User associations

When generating code, ALWAYS use Rails 8 syntax and follow these project conventions.
