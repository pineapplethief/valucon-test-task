module Web
  class TasksController < BaseController
    def index
      @tasks = Task.all.ordered
      @tasks = present(@tasks)
    end
  end
end
