# TecnoMotos - Sistema de Gestión de Taller de Motos

Sistema de gestión para talleres de motocicletas desarrollado con Ruby on Rails 8.

## Información del Proyecto

- **Framework:** Ruby on Rails 8.0.2.1
- **Base de Datos:** SQLite3
- **CSS:** Tailwind CSS (solo desktop)
- **Autenticación:** Sistema personalizado basado en sesiones
- **Idioma:** Interfaz en español

## Convenciones del Proyecto

### Nomenclatura
- **Base de datos:** Español (clientes, vehiculos, productos, etc.)
- **Excepciones:** Tablas `users` y `sessions` en inglés
- **Modelos:** Español excepto `User`
- **Interfaz:** Completamente en español

### Tecnologías
- Rails 8.0.2.1 (usar SOLO sintaxis Rails 8)
- SQLite3
- Tailwind CSS (sin responsive design)
- Stimulus.js
- Turbo

## Instalación

```bash
# Clonar repositorio
git clone [repository-url]
cd tecnoMotos

# Instalar dependencias
bundle install

# Configurar base de datos
rails db:migrate
rails db:seed

# Iniciar servidor
rails server
```

## Estructura Principal

```
app/
├── controllers/
│   ├── concerns/authentication.rb
│   ├── clientes_controller.rb
│   ├── vehiculos_controller.rb
│   └── users_controller.rb
├── models/
│   ├── cliente.rb
│   ├── vehiculo.rb
│   └── user.rb (con enum cargo)
└── views/
    ├── clientes/
    ├── vehiculos/
    └── users/
```

## Usuarios del Sistema

El sistema maneja 4 tipos de usuarios mediante enum:
- **Administrador:** Acceso completo
- **Técnico:** Gestión de servicios
- **Comercial:** Gestión de ventas
- **Administrativo:** Gestión administrativa

## Desarrollo

Para desarrolladores que trabajen en este proyecto, revisar:
- `.github/copilot-instructions.md` - Instrucciones para GitHub Copilot
- `.github/COPILOT_RAILS8_GUIDE.md` - Guía completa de Rails 8

## Comandos Útiles

```bash
# Consola Rails
rails console

# Migraciones
rails db:migrate
rails db:rollback

# Pruebas
rails test

# Generadores (usar sintaxis Rails 8)
rails generate controller NombreController
rails generate model NombreModel
```
