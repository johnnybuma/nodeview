class HomeController < ApplicationController

  def index

    @ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    @ip_addr = @ip.ip_address if @ip

    @conf_file = File.open(Dir.home + "/.bitcoin/bitcoin.conf").to_a

    @data_dir = @conf_file[4].to_s


    @data_dir = @data_dir.chomp[8, 25].strip


    @cookie_file = File.open( @data_dir + "/.cookie")

    @cookie_data = @cookie_file.read

    @cookie_file.close

    @urlstring_to_post = "http://"  + @cookie_data.to_s + "@" + @ip_addr + ":8332/"


    @chain_uri = 'http://' + @ip_addr + ':8332/rest/chaininfo.json'

    @response = HTTParty.get(@chain_uri)

    @transaction_uri =  'http://' + @ip_addr + ':8332/rest/tx/509650706cdd3d844654a16f03e67bdfb4cca995ed4c6dc97e11f1b4895edbc1.json'

    @tx_res = HTTParty.get(@transaction_uri)



    @getblockchaininfo = HTTParty.post(@urlstring_to_post.to_str,
                            :body => { :jsonrpc => '1.0',
                                       :id => 'curltext',
                                       :method => 'getblockchaininfo',
                                       :params => []
                            }.to_json,
                            :headers => { 'Content-Type' => 'application/json' } )

    @listwallets = HTTParty.post(@urlstring_to_post.to_str,
                            :body => { :jsonrpc => '1.0',
                                       :id => 'curltext',
                                       :method => 'listwallets',
                                       :params => []
                            }.to_json,
                            :headers => { 'Content-Type' => 'application/json' } )



    @getbalances = HTTParty.post(@urlstring_to_post + "wallet/MAKO-NODE".to_str,
                                 :body => { :jsonrpc => '1.0',
                                            :id => 'curltext',
                                            :method => 'getbalances'
                                 }.to_json,
                                 :headers => { 'Content-Type' => 'application/json' } )
  end

  def create_wallet

    @ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    @ip_addr = @ip.ip_address if @ip

    @conf_file = File.open(Dir.home + "/.bitcoin/bitcoin.conf").to_a

    @data_dir = @conf_file[4].to_s


    @data_dir = @data_dir.chomp[8, 25].strip


    @cookie_file = File.open( @data_dir + "/.cookie")

    @cookie_data = @cookie_file.read

    @cookie_file.close

    @urlstring_to_post = "http://"  + @cookie_data.to_s + "@" + @ip_addr + ":8332/"

    @createwallet = HTTParty.post(@urlstring_to_post.to_str,
                                 :body => { :jsonrpc => '1.0',
                                            :id => 'curltext',
                                            :method => 'createwallet',
                                            :params => [params['wallet_name']]
                                 }.to_json,
                                 :headers => { 'Content-Type' => 'application/json' } )

  end


end