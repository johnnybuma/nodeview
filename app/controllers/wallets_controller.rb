class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[ show edit update destroy ]

  # GET /wallets or /wallets.json
  def index
    @wallets = Wallet.all
  end

  # GET /wallets/1 or /wallets/1.json
  def show
  end

  # GET /wallets/new
  def new
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit
  end

  # POST /wallets or /wallets.json
  def create
    @wallet = Wallet.new(wallet_params)

    @ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    @ip_addr = @ip.ip_address if @ip

    @conf_file = File.open(Dir.home + "/.bitcoin/bitcoin.conf").to_a

    @data_dir = @conf_file[4].to_s

    @data_dir = @data_dir.chomp[8, 25].strip

    @cookie_file = File.open( @data_dir + "/.cookie")

    @cookie_data = @cookie_file.read

    @cookie_file.close

    @urlstring_to_post = "http://"  + @cookie_data.to_s + "@" + @ip_addr + ":8332/"

    @wallet.post_request_uri = @urlstring_to_post

    @createwallet = HTTParty.post(@urlstring_to_post.to_str,
                                  :body => { :jsonrpc => '1.0',
                                             :id => 'curltext',
                                             :method => 'createwallet',
                                             :params => [
                                               @wallet.wallet_name,
                                               @wallet.disable_private_keys,
                                               @wallet.blank,
                                               @wallet.passphrase,
                                               @wallet.avoid_reuse,
                                               @wallet.descriptors,
                                               @wallet.load_on_startup,
                                               @urlstring_to_post
                                             ]
                                  }.to_json,
                                  :headers => { 'Content-Type' => 'application/json' } )






    respond_to do |format|
      if @wallet.save





        format.html { redirect_to wallet_url(@wallet), notice: "Wallet was successfully created." }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1 or /wallets/1.json
  def update
    respond_to do |format|
      if @wallet.update(wallet_params)
        format.html { redirect_to wallet_url(@wallet), notice: "Wallet was successfully updated." }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1 or /wallets/1.json
  def destroy
    @wallet.destroy

    respond_to do |format|
      format.html { redirect_to wallets_url, notice: "Wallet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wallet_params
      params.require(:wallet).permit(:wallet_name, :disable_private_keys, :blank, :passphrase, :avoid_reuse, :descriptors, :load_on_startup, :post_request_uri)
    end
end
