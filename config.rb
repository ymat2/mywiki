require 'gollum/app'


## General options
wiki_options = {
  page_file_dir: 'source',
  css: true,
  mathjax: false,
  emoji: true
}
Precious::App.set(:wiki_options, wiki_options)

## BASIC comfirmation
module Precious
  class App < Sinatra::Base
    use Rack::Auth::Basic, 'Private Wiki' do |username, password|
      users = File.open(File.expand_path('users.json', __dir__)) do |file|
        JSON.parse(file.read, symbolize_names: true)
      end
      name = username.to_sym
      digested = Digest::SHA256.hexdigest(password)
      if users.key?(name) && digested == users[name][:password]
        Precious::App.set(:author, users[name])
      end
    end

    before do
      session['gollum.author'] = settings.author
    end
  end
end
