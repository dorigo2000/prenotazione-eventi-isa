class RegistrationsController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            redirect_to events_path, notice: "Registrazione completata con successo!"
        else
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:nome, :cognome, :telefono, :data_nascita, :tipo, :email, :password, :password_confirmation)
    end
end