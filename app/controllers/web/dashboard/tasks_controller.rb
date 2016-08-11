module Web
  module Dashboard
    class TasksController < BaseController
      def index
        @tasks = policy_scope(Task).ordered
        @tasks = present(@tasks)
      end
    end
  end
end
