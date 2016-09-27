require 'sinatra'
require 'fileutils'
require 'tempfile'
require 'net/http'
require 'json'
require 'yaml'

get '/' do
	erb :signupform
end
get '/participants/:username' do
	#Display user information. Query PuppetDB for the Azure object for that particular user
        yaml_string = File.read 'users.yaml'
	data = YAML.load yaml_string
	username = params['username']
	user = data.fetch("users").select {|s| s.include? username}
	fullname = user[0].fetch(username).fetch("fullname")
	"#{fullname}"
end
post '/participant' do
	#Create an Azure VM, console user, node group, blah. If succesfull, redirect to get '/participants/:username'
	yaml_string = File.read 'users.yaml'
	data = YAML.load yaml_string
	new_user = { 'fullname' => params['fullname'], 'email' => params['email'], 'password' => params['password']}
	username = params['username']
	data["users"] << { username => new_user }
	output = YAML.dump data
	File.write('users.yaml', output)
	redirect to("/participants/#{username}")
end

