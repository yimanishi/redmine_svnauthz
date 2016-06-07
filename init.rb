Redmine::Plugin.register :redmine_svnauthz do
  name 'Redmine Svnauthz plugin'
  author 'Y.Imanishi'
  description 'svnauthz manager'
  version '0.0.1'
  url 'https://github.com/yimanishi/redmine_svnauthz'
  author_url 'https://github.com/yimanishi/redmine_svnauthz'

  project_module :svnauthz do
    permission :view_svnauthz, :svnauthz_settings => [:index]
    permission :manage_svnauthz,
      :svnauthz_settings => [:new, :edit, :create, :update, :destroy],
      :require => :member
  end

  menu :project_menu, :svnauthz,
       {:controller => 'svnauthz_settings', :action => 'index'},
       :param => :project_id

end
