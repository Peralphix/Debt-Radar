class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.references :user, null: false, foreign_key: true

      t.string :vin
      t.string :sts_number
      t.string :registration_number

      t.jsonb :zalog_raw_data
      t.jsonb :zalog_parsed_data
      t.jsonb :traffic_fines_raw_data
      t.jsonb :traffic_fines_parsed_data

      t.datetime :zalog_updated_at
      t.datetime :traffic_fines_updated_at

      t.timestamps
    end

    add_index :vehicles, :vin, unique: true
    add_index :vehicles, :registration_number, unique: true
    add_index :vehicles, :sts_number, unique: true
  end
end
