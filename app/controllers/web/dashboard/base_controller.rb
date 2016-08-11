module Web
  module Dashboard
    class BaseController < Web::BaseController
      before_filter :authenticate_user!
    end
  end
end
