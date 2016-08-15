module Web
  module Dashboard
    class TasksController < BaseController
      def index
        @tasks = policy_scope(Task).ordered
        @tasks = present(@tasks)
      end

      def show
        @task = find_task
        authorize @task
        @task = present(@task)
      end

      def new
        @task = current_user.tasks.build
      end

      def create
        @task = Task.new(task_params)
        @task.user = current_user if current_user.user?

        if @task.save
          flash[:notice] = t(:task_created)
          redirect_to dashboard_root_path
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @task = find_task
        authorize @task
      end

      def update
        @task = find_task
        authorize @task

        if @task.update(task_params)
          flash[:notice] = t(:task_updated)
          redirect_to dashboard_root_path
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @task = find_task
        authorize @task

        @task.destroy
        flash[:notice] = t(:task_destroyed)

        redirect_to dashboard_root_path
      end

      private

      def find_task
        Task.find(params[:id])
      end

      def task_params
        params_to_permit = [
          :name,
          :description,
          :state
        ]
        params_to_permit << :user_id if current_user.admin?
        params.require(:task).permit(*params_to_permit)
      end
    end
  end
end
