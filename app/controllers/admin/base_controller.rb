class Admin::BaseController < ApplicationController
  before_action :check_admin
end
