ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  # Save the payload
  Statistic.save_notification payload
end
