class MainController < ApplicationController

  def index
    @docker = Pathname('/.dockerenv').exist?
  end
  
end
