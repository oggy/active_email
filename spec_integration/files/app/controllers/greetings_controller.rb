class GreetingsController < ApplicationController
  def new
    @greeting = Greeting.new
  end

  def create
    @greeting = Greeting.new(params[:greeting])
    if @greeting.deliver
      flash[:notice] = 'Email sent!'
      redirect_to new_greeting_path
    else
      flash[:error] = 'Oh noes!'
      render :action => 'new'
    end
  end
end
