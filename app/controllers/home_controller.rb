class HomeController < ApplicationController

  def index

    @cookie_file = File.open("/mnt/BTC-DATA/.cookie")

    @cookie_data = @cookie_file.read

    @cookie_file.close

    @chain_uri = 'http://192.168.1.36:8332/rest/chaininfo.json'

    @response = HTTParty.get(@chain_uri)

    @transaction_uri = 'http://192.168.1.36:8332/rest/tx/509650706cdd3d844654a16f03e67bdfb4cca995ed4c6dc97e11f1b4895edbc1.json'

    @tx_res = HTTParty.get(@transaction_uri)


    @urlstring_to_post = "http://"  + @cookie_data.to_s + "@192.168.1.36:8332/"

    @result = HTTParty.post(@urlstring_to_post.to_str,
                            :body => { :jsonrpc => '1.0',
                                       :id => 'curltext',
                                       :method => 'getblockchaininfo',
                                       :params => []
                            }.to_json,
                            :headers => { 'Content-Type' => 'application/json' } )





  end


end