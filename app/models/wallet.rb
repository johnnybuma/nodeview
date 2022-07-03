class Wallet < ApplicationRecord

  #before_save :create_wallet


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

    self.post_request_uri = @urlstring_to_post

    @createwallet = HTTParty.post(@urlstring_to_post.to_str,
                                  :body => { :jsonrpc => '1.0',
                                             :id => 'curltext',
                                             :method => 'createwallet',
                                             :params => [
                                               self.wallet_name,
                                               self.disable_private_keys,
                                               self.blank,
                                               self.passphrase,
                                               self.avoid_reuse,
                                               self.descriptors,
                                               self.load_on_startup,
                                               self.post_request_uri
                                             ]
                                  }.to_json,
                                  :headers => { 'Content-Type' => 'application/json' } )

  end


end
