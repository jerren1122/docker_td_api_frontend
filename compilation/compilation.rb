class Compilation
  require 'rest-client'
  require 'json'

  attr_accessor(:header, :json_store, :aggregate_hash, :omdb_host, :ny_times_host)

  def initialize
    @omdb_host = ENV['omdb_hostname'] ? ENV['omdb_hostname'] : 'localhost'
    @ny_times_host = ENV['ny_times_hostname'] ? ENV['ny_times_hostname'] : 'localhost'
    @header = {"content-type" => "charset=utf-8"}
    parse_input_json
    self.send(aggregate_hash['Method'])
  end

  def return_article
    aggregate_hash.merge!(get_movie)
    aggregate_hash.merge!(get_article)
    keys_to_keep = ['Abstract']
    print JSON.generate( remove_keys(keys_to_keep, aggregate_hash.clone))
  end

  private
  def get_movie
    url = "http://#{omdb_host}:8080/get-movie"
    keys_to_keep = ['Movie']
    local_input = remove_keys(keys_to_keep, aggregate_hash.clone)
    body = local_input.to_json
    raw_response = RestClient::Request.execute(method: :get, url: url, timeout: 10, headers: header, payload: body)
    JSON.parse(eval(raw_response))
  end

  def get_article
    url = "http://#{ny_times_host}:8081/get-article"
    keys_to_keep = ['Year']
    local_input = remove_keys(keys_to_keep, aggregate_hash.clone)
    body = local_input.to_json
    raw_response = RestClient::Request.execute(method: :get, url: url, timeout: 10, headers: header, payload: body)
    JSON.parse(eval(raw_response))
  end

  def remove_keys(keys_to_keep, hash)
    hash.keep_if {|key, value| keys_to_keep.include?(key)}
  end

  def parse_input_json
    @aggregate_hash = {}
    array = ARGV[0].scan(/(\w+) |(\w+)/).flatten.compact
    until array.empty?
      value = array.pop
      key = array.pop
      @aggregate_hash.store(key, value)
    end
  end
end

comp = Compilation.new