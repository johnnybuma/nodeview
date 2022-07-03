class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.string :wallet_name
      t.boolean :disable_private_keys
      t.boolean :blank
      t.string :passphrase
      t.string :avoid_reuse
      t.boolean :descriptors
      t.boolean :load_on_startup
      t.string :post_request_uri

      t.timestamps
    end
  end
end
