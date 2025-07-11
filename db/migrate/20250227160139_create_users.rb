class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :cognome
      t.string :tipo
      t.string :email
      t.string :telefono
      t.date :data_nascita
      t.string :password_digest

      t.timestamps
    end
  end
end
