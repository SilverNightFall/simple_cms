class DemoController < ApplicationController

  def index
  	#render('hello')
 	#redirect_to(:action => 'other_hello')
  end

  def hello
  	@array = [1, 2, 3, 4, 5]
  	#redirect_to("http://www.lynda.com")
  end

  def other_hello
  	render :text => ('Hello Everyone')
  end

end
