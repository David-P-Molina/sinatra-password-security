require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do #File with links to signup or login
		erb :index
	end

	get "/signup" do#renders a for to create a new user.
		erb :signup
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
	  
		if user.save
		  redirect "/login"
		else
		  redirect "/failure"
		end
	  end 

	get "/login" do#renders a form for logging in
		erb :login
	end

	post "/login" do
		user = User.find_by(:username => params[:username])

		if user && user.authenticate(params[:password])
		  session[:user_id] = user.id
		  redirect "/success"
		else
		  redirect "/failure"
		end
	  end 

	get "/success" do#should be displayed once a user succssfully logs in
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do#Will be accessed if there is an error logging in or signing up
		erb :failure
	end

	get "/logout" do#clears the session data and redirects to homepage
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
