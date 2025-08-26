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

ActiveRecord::Schema[8.0].define(version: 2025_08_26_042029) do
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

  create_table "invoice_details", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.string "tipo_item"
    t.integer "quantity"
    t.decimal "cost_item"
    t.text "description"
    t.integer "service_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_details_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_details_on_product_id"
    t.index ["service_id"], name: "index_invoice_details_on_service_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "numero_factura"
    t.datetime "fecha_factura"
    t.decimal "subtotal"
    t.decimal "impuestos"
    t.decimal "total"
    t.string "metodo_pago"
    t.string "estado"
    t.integer "client_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["numero_factura"], name: "index_invoices_on_numero_factura", unique: true
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "cantidad"
    t.decimal "precio_unitario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "nombre_pedido"
    t.datetime "fecha_pedido"
    t.string "estado"
    t.decimal "total"
    t.integer "supplier_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_orders_on_supplier_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.integer "cantidad_disponible"
    t.decimal "precio_unitario"
    t.decimal "precio_venta"
    t.string "sku"
    t.integer "supplier_id", null: false
    t.datetime "fecha_registro"
    t.datetime "ultima_actualizacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "service_product_details", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "product_id", null: false
    t.integer "cantidad_usada"
    t.decimal "precio_unitario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_service_product_details_on_product_id"
    t.index ["service_id"], name: "index_service_product_details_on_service_id"
  end

  create_table "service_vehicle_details", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "vehicle_id", null: false
    t.text "descripcion"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_vehicle_details_on_service_id"
    t.index ["vehicle_id"], name: "index_service_vehicle_details_on_vehicle_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "nombre"
    t.string "identificacion"
    t.string "telefono"
    t.string "correo"
    t.string "direccion"
    t.string "persona_contacto"
    t.datetime "fecha_registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identificacion"], name: "index_suppliers_on_identificacion", unique: true
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

  create_table "vehicles", force: :cascade do |t|
    t.string "matricula"
    t.string "modelo"
    t.string "marca"
    t.integer "anio"
    t.string "color"
    t.text "descripcion"
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_vehicles_on_client_id"
    t.index ["matricula"], name: "index_vehicles_on_matricula", unique: true
  end

  add_foreign_key "invoice_details", "invoices"
  add_foreign_key "invoice_details", "products"
  add_foreign_key "invoice_details", "services"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "users"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
  add_foreign_key "orders", "suppliers"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "suppliers"
  add_foreign_key "service_product_details", "products"
  add_foreign_key "service_product_details", "services"
  add_foreign_key "service_vehicle_details", "services"
  add_foreign_key "service_vehicle_details", "vehicles"
  add_foreign_key "sessions", "users"
  add_foreign_key "vehicles", "clients"
end
