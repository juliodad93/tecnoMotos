# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_27_061347) do
  create_table "clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.string "identificacion"
    t.string "telefono"
    t.string "correo"
    t.string "direccion"
    t.datetime "fecha_registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identificacion"], name: "index_clientes_on_identificacion", unique: true
  end

  create_table "detalles_facturas", force: :cascade do |t|
    t.integer "factura_id", null: false
    t.string "tipo_item"
    t.integer "cantidad"
    t.decimal "costo_item"
    t.text "descripcion"
    t.integer "servicio_id"
    t.integer "producto_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "detalle_servicio_vehiculo_id"
    t.index ["detalle_servicio_vehiculo_id"], name: "index_detalles_facturas_on_detalle_servicio_vehiculo_id"
    t.index ["factura_id"], name: "index_detalles_facturas_on_factura_id"
    t.index ["producto_id"], name: "index_detalles_facturas_on_producto_id"
    t.index ["servicio_id"], name: "index_detalles_facturas_on_servicio_id"
  end

  create_table "detalles_pedidos", force: :cascade do |t|
    t.integer "pedido_id", null: false
    t.integer "producto_id", null: false
    t.integer "cantidad"
    t.decimal "precio_unitario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_id"], name: "index_detalles_pedidos_on_pedido_id"
    t.index ["producto_id"], name: "index_detalles_pedidos_on_producto_id"
  end

  create_table "detalles_servicio_productos", force: :cascade do |t|
    t.integer "servicio_id"
    t.integer "producto_id", null: false
    t.integer "cantidad_usada"
    t.decimal "precio_unitario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producto_id"], name: "index_detalles_servicio_productos_on_producto_id"
    t.index ["servicio_id"], name: "index_detalles_servicio_productos_on_servicio_id"
  end

  create_table "detalles_servicio_vehiculos", force: :cascade do |t|
    t.integer "servicio_id"
    t.integer "vehiculo_id", null: false
    t.text "descripcion"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servicio_id"], name: "index_detalles_servicio_vehiculos_on_servicio_id"
    t.index ["vehiculo_id"], name: "index_detalles_servicio_vehiculos_on_vehiculo_id"
  end

  create_table "facturas", force: :cascade do |t|
    t.string "numero_factura"
    t.datetime "fecha_factura"
    t.decimal "subtotal"
    t.decimal "impuestos"
    t.decimal "total"
    t.string "metodo_pago"
    t.string "estado"
    t.integer "cliente_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_facturas_on_cliente_id"
    t.index ["numero_factura"], name: "index_facturas_on_numero_factura", unique: true
    t.index ["user_id"], name: "index_facturas_on_user_id"
  end

  create_table "pedidos", force: :cascade do |t|
    t.string "nombre_pedido"
    t.datetime "fecha_pedido"
    t.string "estado"
    t.decimal "total"
    t.integer "proveedor_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proveedor_id"], name: "index_pedidos_on_proveedor_id"
    t.index ["user_id"], name: "index_pedidos_on_user_id"
  end

  create_table "productos", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.integer "cantidad_disponible"
    t.decimal "precio_unitario"
    t.decimal "precio_venta"
    t.string "sku"
    t.integer "proveedor_id", null: false
    t.datetime "fecha_registro"
    t.datetime "ultima_actualizacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proveedor_id"], name: "index_productos_on_proveedor_id"
    t.index ["sku"], name: "index_productos_on_sku", unique: true
  end

  create_table "proveedores", force: :cascade do |t|
    t.string "nombre"
    t.string "identificacion"
    t.string "telefono"
    t.string "correo"
    t.string "direccion"
    t.string "persona_contacto"
    t.datetime "fecha_registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identificacion"], name: "index_proveedores_on_identificacion", unique: true
  end

  create_table "servicios", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion"
    t.decimal "precio_base", precision: 10, scale: 2
    t.integer "duracion_estimada"
    t.string "categoria"
    t.boolean "activo", default: true
    t.datetime "fecha_registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activo"], name: "index_servicios_on_activo"
    t.index ["categoria"], name: "index_servicios_on_categoria"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
    t.string "apellido"
    t.string "identificacion"
    t.string "cargo"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "vehiculos", force: :cascade do |t|
    t.string "matricula"
    t.string "modelo"
    t.string "marca"
    t.integer "anio"
    t.string "color"
    t.text "descripcion"
    t.integer "cliente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vehiculos_on_cliente_id"
    t.index ["matricula"], name: "index_vehiculos_on_matricula", unique: true
  end

  add_foreign_key "detalles_facturas", "detalles_servicio_vehiculos", column: "detalle_servicio_vehiculo_id"
  add_foreign_key "detalles_facturas", "facturas"
  add_foreign_key "detalles_facturas", "productos"
  add_foreign_key "detalles_facturas", "servicios"
  add_foreign_key "detalles_pedidos", "pedidos"
  add_foreign_key "detalles_pedidos", "productos"
  add_foreign_key "detalles_servicio_productos", "productos"
  add_foreign_key "detalles_servicio_productos", "servicios"
  add_foreign_key "detalles_servicio_vehiculos", "servicios"
  add_foreign_key "detalles_servicio_vehiculos", "vehiculos"
  add_foreign_key "facturas", "clientes"
  add_foreign_key "facturas", "users"
  add_foreign_key "pedidos", "proveedores", column: "proveedor_id"
  add_foreign_key "pedidos", "users"
  add_foreign_key "productos", "proveedores", column: "proveedor_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "vehiculos", "clientes"
end
