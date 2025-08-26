# Guía de Rails 8 para GitHub Copilot

## Información del Proyecto

**Framework:** Ruby on Rails 8.0.2.1
**Base de Datos:** SQLite3
**CSS Framework:** Tailwind CSS (solo desktop, sin mobile responsiveness)
**Autenticación:** Sistema basado en sesiones y cookies
**Idioma:** Interfaz en español, base de datos en español (excepto tablas `users` y `sessions`)

## Convenciones Específicas de Rails 8

### 1. Enums en Rails 8
```ruby
# ✅ Sintaxis CORRECTA para Rails 8
enum :cargo, {
  administrador: 0,
  tecnico: 1,
  comercial: 2,
  administrativo: 3
}

# ❌ Sintaxis INCORRECTA (versiones anteriores)
enum cargo: {
  administrador: 0,
  tecnico: 1,
  comercial: 2,
  administrativo: 3
}
```

### 2. Generadores y Comandos
```bash
# ✅ Rails 8 usa estos comandos
rails generate controller NombreController
rails generate model NombreModel
rails generate migration AddFieldToTable
rails db:migrate
rails db:seed

# ✅ Nuevas características de Rails 8
rails generate authentication  # Si se necesita autenticación básica
rails generate dockerfile      # Para contenedores
```

### 3. Estructura de Archivos
```
app/
├── controllers/
│   ├── concerns/           # Para módulos compartidos
│   └── application_controller.rb
├── models/
│   ├── concerns/
│   └── application_record.rb
├── views/
│   └── layouts/
│       └── application.html.erb
└── helpers/
```

### 4. Autenticación (No usar Devise)
```ruby
# ✅ Sistema de autenticación personalizado
class ApplicationController < ActionController::Base
  include Authentication
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def user_signed_in?
    current_user.present?
  end
end
```

### 5. Rutas en Rails 8
```ruby
# ✅ Sintaxis de rutas Rails 8
Rails.application.routes.draw do
  root "sessions#new"
  
  resources :clientes do
    resources :vehiculos, except: [:index]
  end
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :passwords, only: [:new, :create, :edit, :update]
end
```

## Convenciones del Proyecto

### 1. Nomenclatura de Base de Datos
- **Tablas:** En español (clientes, vehiculos, productos, etc.)
- **Excepciones:** `users`, `sessions` (en inglés)
- **Campos:** En español (nombre, apellido, descripcion, etc.)

### 2. Modelos y Controladores
```ruby
# ✅ Nombres de modelos
class Cliente < ApplicationRecord
class Vehiculo < ApplicationRecord
class User < ApplicationRecord  # Excepción en inglés

# ✅ Nombres de controladores
class ClientesController < ApplicationController
class VehiculosController < ApplicationController
class UsersController < ApplicationController
```

### 3. CSS y Vistas (Solo Desktop)
```erb
<!-- ✅ Solo clases de Tailwind para desktop -->
<div class="max-w-4xl mx-auto px-4">
<div class="grid grid-cols-3 gap-6">
<button class="px-4 py-2 bg-blue-600 text-white rounded-lg">

<!-- ❌ NO usar clases responsivas -->
<div class="sm:px-6 lg:px-8">        <!-- ❌ No usar -->
<div class="md:grid-cols-2">         <!-- ❌ No usar -->
<button class="sm:px-6">             <!-- ❌ No usar -->
```

### 4. Formularios Rails 8
```erb
<!-- ✅ Sintaxis de formularios Rails 8 -->
<%= form_with model: @cliente, local: true, class: "space-y-6" do |form| %>
  <div class="form-group">
    <%= form.label :nombre, class: "block text-sm font-medium text-gray-700" %>
    <%= form.text_field :nombre, class: "mt-1 block w-full rounded-md border-gray-300" %>
  </div>
<% end %>
```

### 5. Migraciones Rails 8
```ruby
# ✅ Estructura de migraciones Rails 8
class CreateClientes < ActiveRecord::Migration[8.0]
  def change
    create_table :clientes do |t|
      t.string :nombre, null: false
      t.string :apellido, null: false
      t.string :telefono
      t.string :email
      t.text :descripcion
      
      t.timestamps
    end
    
    add_index :clientes, :email, unique: true
  end
end
```

### 6. Asociaciones y Validaciones
```ruby
# ✅ Sintaxis Rails 8
class Cliente < ApplicationRecord
  has_many :vehiculos, dependent: :destroy
  
  validates :nombre, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  scope :activos, -> { where(activo: true) }
end
```

## Características Específicas del Proyecto

### 1. Sistema de Usuarios con Enum
```ruby
class User < ApplicationRecord
  enum :cargo, {
    administrador: 0,
    tecnico: 1,
    comercial: 2,
    administrativo: 3
  }
  
  def cargo_humanizado
    case cargo
    when 'administrador' then 'Administrador'
    when 'tecnico' then 'Técnico'
    when 'comercial' then 'Comercial'
    when 'administrativo' then 'Administrativo'
    end
  end
end
```

### 2. Helpers del Proyecto
```ruby
module ApplicationHelper
  def cargo_color(cargo)
    case cargo
    when 'administrador' then 'bg-red-100 text-red-800'
    when 'tecnico' then 'bg-blue-100 text-blue-800'
    when 'comercial' then 'bg-green-100 text-green-800'
    when 'administrativo' then 'bg-yellow-100 text-yellow-800'
    end
  end
  
  def cargo_icon(cargo)
    case cargo
    when 'administrador' then '👑'
    when 'tecnico' then '🔧'
    when 'comercial' then '💼'
    when 'administrativo' then '📋'
    end
  end
end
```

### 3. Autenticación Requerida
- **Todas las vistas requieren autenticación EXCEPTO:**
  - Login (`sessions#new`)
  - Recuperación de contraseña (`passwords#new`, `passwords#create`, `passwords#edit`, `passwords#update`)

### 4. Estructura de Vistas
```erb
<!-- ✅ Layout estándar para vistas autenticadas -->
<div class="min-h-screen bg-gray-100 py-8">
  <div class="max-w-4xl mx-auto px-4">
    <!-- Breadcrumb -->
    <nav class="flex mb-4" aria-label="Breadcrumb">
      <!-- navegación -->
    </nav>
    
    <!-- Contenido principal -->
    <div class="bg-white shadow rounded-lg">
      <!-- contenido -->
    </div>
  </div>
</div>
```

## Comandos Útiles Rails 8

```bash
# Servidor de desarrollo
rails server

# Consola
rails console

# Migraciones
rails db:migrate
rails db:rollback
rails db:reset

# Semillas
rails db:seed

# Generadores
rails generate controller Nombre
rails generate model Nombre
rails generate migration NombreMigracion

# Tests
rails test
rails test:system
```

## Gemas Principales del Proyecto

```ruby
# Gemfile principales
gem 'rails', '~> 8.0.2'
gem 'sqlite3'
gem 'tailwindcss-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'bootsnap'
gem 'image_processing'
```

---

**IMPORTANTE:** Este proyecto está construido exclusivamente con Rails 8. No usar sintaxis, métodos o convenciones de versiones anteriores de Rails.
