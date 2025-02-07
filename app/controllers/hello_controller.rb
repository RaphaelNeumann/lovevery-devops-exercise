class HelloController < ApplicationController
    def index
        @today = Date.today.strftime("%A, %e %B %Y")
        @secret = ENV['SECRET']
    end
end
