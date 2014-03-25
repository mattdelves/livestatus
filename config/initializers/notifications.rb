require 'livestatus/statistic'

ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|
  # Save the payload
  Livestatus::Statistic.save_notification payload
end
