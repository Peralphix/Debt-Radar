class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :inn, null: false
      t.date :birthdate

      t.jsonb :kad_arbitr_raw_data
      t.jsonb :kad_arbitr_parsed_data
      t.jsonb :bankrot_raw_data
      t.jsonb :bankrot_parsed_data
      t.jsonb :nalog_raw_data
      t.jsonb :nalog_parsed_data

      t.datetime :kad_arbitr_updated_at
      t.datetime :bankrot_updated_at
      t.datetime :nalog_updated_at

      t.timestamps
    end

    add_index :users, :inn, unique: true
  end
end
