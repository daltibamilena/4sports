class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == "application/json" }

  before_action :authenticate_user!

  def require_admin
    unless current_user && current_user.admin == true
      respond_to do |format|
        format.html
        format.json { render json: current_user, status: :unauthorized }
      end
    end
  end
end
