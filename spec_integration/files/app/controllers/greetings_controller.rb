class GreetingsController < ApplicationController
  def new
  end

  def create
    @email = Greeting.new(params[:email])
    if @email.deliver
      flash[:notice] = 'Email sent!'
      redirect_to new_greeting_path
    else
      flash[:error] = 'Oh noes!'
      render :action => 'new'
    end
  end
end
