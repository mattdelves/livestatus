ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, finish, id, payload|

  # Payload: {:controller=>"DashboardController", :action=>"home", :params=>{"controller"=>"dashboard", "action"=>"home"}, :format=>:html, :method=>"GET", :path=>"/", :status=>200, :view_runtime=>220.13, :db_runtime=>0}

end
