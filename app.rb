require 'sinatra'
require 'json'
require_relative './my_user_model'
set('views', './views')
enable :sessions

set :port, 8080
set :bind, '0.0.0.0'

get '/users' do
    User.all.collect do |row|
        row.to_hash.exept(:password).to_json + "\n"
    end
  
end

post '/sign_in'do
    params['email']
    params['password']
    users=User.all
    user=users.filter{|user|user.email==params['email'] && user.password==params['password']}.first
    if user
        session[:user_id] = user.id
        "Signed in => user_id:" + session[:user_id].to_s
    else
        "Not authorized"
    end
    
end

post '/users' do
    User.create(params)
    "User created"
end

put '/users' do
    params['password']
    params['new_password']
    if params ['new_password']
        User.update(session[:user_id],'password', params['new_password'])
        "Password updated =>"+ User.get(session[:user_id]).to_hash.to_json
        else
            "Password not updated"
        end

end


delete '/users' do
    if session[:user_id]
        User.destroy(session[:user_id])
        "User deleted"

    else
        "User unindentified. Delete impossible."
    end
end

delete '/sign_out' do
    if session[:user_id]
        session.clear
        "Signed out=> user_id:" + session[:user_id].to_s
    else
        "User is not signed in"
    end
end

get'/' do
    erb :index
end