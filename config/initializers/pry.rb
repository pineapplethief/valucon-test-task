# Show red environment name in pry prompt for non development environments
if Rails.env.staging? || Rails.env.production?
  old_prompt = Pry.config.prompt
  env = Pry::Helpers::Text.red(Rails.env.upcase)
  Pry.config.prompt = [
    proc { |*args| "#{env} #{old_prompt.first.call(*args)}" },
    proc { |*args| "#{env} #{old_prompt.second.call(*args)}" },
  ]
end
