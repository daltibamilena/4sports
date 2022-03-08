class ApplicationController < ActionController::Base
  def home
    render template: "home/index"
  end
end
