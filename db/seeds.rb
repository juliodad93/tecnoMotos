# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Creando datos de ejemplo..."

# Crear usuario administrador por defecto
puts "👑 Creando usuario administrador..."
admin_user = User.find_or_create_by(email_address: "admin@mail") do |user|
  user.nombre = "Administrador"
  user.apellido = "del Sistema"
  user.identificacion = "0000000000"
  user.telefono = "555-0000"
  user.direccion = "Oficina Principal"
  user.cargo = :administrador
  user.password = "s3cr3t"
end

if admin_user.persisted?
  puts "✅ Usuario administrador creado: admin@mail / s3cr3t"
else
  puts "❌ Error creando administrador: #{admin_user.errors.full_messages.join(', ')}"
end

# Crear usuario técnico de prueba
puts "🔧 Creando usuario técnico..."
tecnico_user = User.find_or_create_by(email_address: "tecnico@mail") do |user|
  user.nombre = "Juan Carlos"
  user.apellido = "Técnico"
  user.identificacion = "1111111111"
  user.telefono = "555-1111"
  user.direccion = "Taller Principal"
  user.cargo = :tecnico
  user.password = "s3cr3t"
end

if tecnico_user.persisted?
  puts "✅ Usuario técnico creado: tecnico@mail / s3cr3t"
else
  puts "❌ Error creando técnico: #{tecnico_user.errors.full_messages.join(', ')}"
end

# Crear usuario comercial de prueba
puts "🔧 Creando usuario comercial..."
comercial_user = User.find_or_create_by(email_address: "comercial@mail") do |user|
  user.nombre = "Ana María"
  user.apellido = "Comercial"
  user.identificacion = "2222222222"
  user.telefono = "555-1111"
  user.direccion = "Taller Principal"
  user.cargo = :comercial
  user.password = "s3cr3t"
end

if comercial_user.persisted?
  puts "✅ Usuario comercial creado: comercial@mail / s3cr3t"
else
  puts "❌ Error creando comercial: #{comercial_user.errors.full_messages.join(', ')}"
end


# Limpiar datos existentes (excepto admin y técnico)
puts "🧹 Limpiando datos existentes..."
Vehiculo.destroy_all
Cliente.destroy_all
User.where.not(email_address: ["admin@mail", "tecnico@mail"]).destroy_all

# Crear clientes de ejemplo
puts "👥 Creando clientes..."

clientes = [
  {
    nombre: "Juan Carlos",
    apellido: "Pérez García",
    identificacion: "1234567890",
    telefono: "0998765432",
    correo: "juan.perez@email.com",
    direccion: "Av. 6 de Diciembre N23-45, Quito"
  },
  {
    nombre: "María",
    apellido: "López Sánchez",
    identificacion: "0987654321",
    telefono: "0987654321",
    correo: "maria.lopez@email.com",
    direccion: "Calle 10 de Agosto y Colón, Quito"
  },
  {
    nombre: "Carlos",
    apellido: "Rodríguez Vega",
    identificacion: "1122334455",
    telefono: "0976543210",
    correo: "carlos.rodriguez@email.com",
    direccion: "Av. República del Salvador N35-67, Quito"
  },
  {
    nombre: "Ana",
    apellido: "Martínez Cruz",
    identificacion: "2233445566",
    telefono: "0965432109",
    correo: "ana.martinez@email.com",
    direccion: "Av. Shyris N33-123, Quito"
  },
  {
    nombre: "Luis",
    apellido: "González Torres",
    identificacion: "3344556677",
    telefono: "0954321098",
    correo: "luis.gonzalez@email.com",
    direccion: "Av. Amazonas N24-56, Quito"
  }
]

clientes_creados = []
clientes.each do |cliente_data|
  cliente = Cliente.create!(cliente_data)
  clientes_creados << cliente
  puts "✅ Cliente creado: #{cliente.nombre} #{cliente.apellido}"
end

# Crear vehículos de ejemplo
puts "🏍️ Creando vehículos..."

vehiculos = [
  # Vehículos para Juan Carlos
  {
    marca: "Honda",
    modelo: "CBR 600RR",
    anio: 2020,
    matricula: "PBB-1234",
    color: "Rojo",
    descripcion: "Motocicleta deportiva en excelente estado",
    cliente: clientes_creados[0]
  },
  {
    marca: "Toyota",
    modelo: "Corolla",
    anio: 2019,
    matricula: "PBA-5678",
    color: "Blanco",
    descripcion: "Vehículo familiar, mantenimiento regular",
    cliente: clientes_creados[0]
  },
  
  # Vehículos para María
  {
    marca: "Yamaha",
    modelo: "FZ-16",
    anio: 2021,
    matricula: "PBC-9876",
    color: "Azul",
    descripcion: "Motocicleta urbana, ideal para ciudad",
    cliente: clientes_creados[1]
  },
  
  # Vehículos para Carlos
  {
    marca: "Suzuki",
    modelo: "GSX-R 750",
    anio: 2018,
    matricula: "PBD-4321",
    color: "Negro",
    descripcion: "Motocicleta deportiva, necesita revisión de frenos",
    cliente: clientes_creados[2]
  },
  {
    marca: "Chevrolet",
    modelo: "Aveo",
    anio: 2017,
    matricula: "PBE-1111",
    color: "Gris",
    descripcion: "Auto compacto, buen estado general",
    cliente: clientes_creados[2]
  },
  
  # Vehículos para Ana
  {
    marca: "KTM",
    modelo: "Duke 390",
    anio: 2022,
    matricula: "PBF-2222",
    color: "Naranja",
    descripcion: "Motocicleta nueva, bajo garantía",
    cliente: clientes_creados[3]
  },
  
  # Vehículos para Luis
  {
    marca: "Kawasaki",
    modelo: "Ninja 300",
    anio: 2019,
    matricula: "PBG-3333",
    color: "Verde",
    descripcion: "Primera moto del cliente, cuidada",
    cliente: clientes_creados[4]
  },
  {
    marca: "Nissan",
    modelo: "Sentra",
    anio: 2020,
    matricula: "PBH-4444",
    color: "Plateado",
    descripcion: "Sedán ejecutivo, excelente condición",
    cliente: clientes_creados[4]
  }
]

vehiculos.each do |vehiculo_data|
  vehiculo = Vehiculo.create!(vehiculo_data)
  puts "✅ Vehículo creado: #{vehiculo.marca} #{vehiculo.modelo} - #{vehiculo.matricula}"
end

puts "\n🎉 ¡Datos de ejemplo creados exitosamente!"
puts "📊 Resumen:"
puts "   👥 #{Cliente.count} clientes creados"
puts "   🏍️ #{Vehiculo.count} vehículos creados"

# Crear usuarios de ejemplo con diferentes cargos
puts "\n👤 Creando usuarios de ejemplo..."

usuarios = [
  {
    nombre: "Admin",
    apellido: "Principal",
    email_address: "admin@tecnomotos.com",
    password: "password123",
    identificacion: "1234567890",
    cargo: "administrador"
  },
  {
    nombre: "Carlos",
    apellido: "Mecánico",
    email_address: "carlos.mecanico@tecnomotos.com", 
    password: "password123",
    identificacion: "0987654321",
    cargo: "tecnico"
  },
  {
    nombre: "Ana",
    apellido: "Ventas",
    email_address: "ana.ventas@tecnomotos.com",
    password: "password123", 
    identificacion: "1122334455",
    cargo: "comercial"
  },
  {
    nombre: "Luis",
    apellido: "Contador",
    email_address: "luis.contador@tecnomotos.com",
    password: "password123",
    identificacion: "5544332211", 
    cargo: "administrativo"
  }
]

usuarios.each do |usuario_data|
  usuario = User.create!(usuario_data)
  puts "✅ Usuario creado: #{usuario.nombre_completo} - #{usuario.cargo_humanizado}"
end

puts "   👤 #{User.count} usuarios creados"
puts "\n🚀 Puedes acceder a la aplicación en: http://localhost:3000"
