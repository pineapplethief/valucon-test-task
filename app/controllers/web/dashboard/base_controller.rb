module Web
  module Dashboard
    class BaseController < ApplicationController
      before_filter :authenticate_user!
    end
  end
end
