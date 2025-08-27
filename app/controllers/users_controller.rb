class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    # Prevenir creación de administradores desde el frontend
    if @user.cargo == 'administrador'
      @user.errors.add(:cargo, "no puede ser administrador. Los administradores solo pueden ser creados por el sistema.")
      render :new, status: :unprocessable_entity
      return
    end
    
    if @user.save
      redirect_to @user, notice: 'Usuario creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Prevenir actualización a administrador desde el frontend
    if params[:user][:cargo] == 'administrador' && !@user.admin?
      @user.errors.add(:cargo, "no puede ser administrador. Los administradores solo pueden ser creados por el sistema.")
      render :edit, status: :unprocessable_entity
      return
    end
    
    if @user.update(user_params)
      redirect_to @user, notice: 'Usuario actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Prevenir eliminación del administrador
    if @user.admin?
      redirect_to users_path, alert: 'No se puede eliminar al administrador del sistema.'
      return
    end
    
    @user.destroy
    redirect_to users_path, notice: 'Usuario eliminado exitosamente.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nombre, :apellido, :email_address, :password, :identificacion, :cargo)
  end
end
