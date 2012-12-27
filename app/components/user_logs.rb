class UserLogs < Netzke::Basepack::Grid
  def configure(c)
    super

    c.model = "ActsAsLoggable::Log"
    c.title = "User History"
    c.data_store = {auto_load: false}
    c.scope = lambda { |rel| puts session.inspect; rel.where(:loggable_type => 'User',:loggable_id => session[:selected_user_id]);}
    c.strong_default_attrs = {
      :loggable_type => 'User',
      :loggable_id => session[:selected_user_id],
      :log_action_type => 'ActsAsLoggable::UserAction'
    }
    c.columns = [
      { :name => :start_date, :format => "g:ia - D, M j - Y", :width => 165 },
      { :name => :hours, :getter => lambda { |rec| (rec.end_date - rec.start_date)/3600 }, :sorting_scope => :sort_by_duration},
      :description,
      { :name => :user_action__action },
      :created_at,
      :updated_at
    ]
  end

  def default_fields_for_forms
    [
      :start_date,
      :end_date,
      :description,
      { :name => :user_action__action}
    ]
  end

  #override with nil to remove actions
  def default_bbar
    [ :apply, :add_in_form, :search ]
  end
end