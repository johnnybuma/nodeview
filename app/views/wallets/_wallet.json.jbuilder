json.extract! wallet, :id, :wallet_name, :disable_private_keys, :blank, :passphrase, :avoid_reuse, :descriptors, :load_on_startup, :post_request_uri, :created_at, :updated_at
json.url wallet_url(wallet, format: :json)
