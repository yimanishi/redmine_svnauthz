class SvnauthzSettingsController < ApplicationController
  unloadable
  menu_item :svnauthz_settings
  before_filter :find_project, :authorize
  before_filter :find_svnauthz_setting, :except => [:index, :new, :create]

  def index
    @svnauthz_settings = SvnauthzSettings.find(:all, :conditions => {:project_id => @project.id}, :order => 'group_flag desc')
  end

  def new
    @svnauthz_settings = SvnauthzSettings.new()
  end

  def create
    @svnauthz_settings = SvnauthzSettings.new(params[:svnauthz_settings])
    @svnauthz_settings.project_id = @project.id
    if @svnauthz_settings.save
      create_svnauthz_file
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_svnauthz_settings_path(@project)
    end
  end

  def update
    @svnauthz_settings.attributes = params[:svnauthz_settings]
    if @svnauthz_settings.save
      create_svnauthz_file
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_svnauthz_settings_path(@project)
    end
  end

  def edit
  end

  def destroy
    @svnauthz_settings.destroy
    create_svnauthz_file
    redirect_to project_svnauthz_settings_path(@project)
  end

private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_svnauthz_setting
    @svnauthz_settings = SvnauthzSettings.find_by_id(params[:id])
    render_404 unless @svnauthz_settings
  end

  def create_svnauthz_file
    svnauthz_file = Rails.root.to_s + "/public/svnauthz.conf"
    f = File.open(svnauthz_file, 'w')
    svnauthz_params = SvnauthzSettings.find(:all, :conditions => {:project_id => @project.id}, :order => 'group_flag desc')
    svnauthz_params.each { | svnauthz_param | 
      f.puts svnauthz_param.directory
      svnauthz_param.permission.split("|").each { | permit |
        if svnauthz_param.directory == "[groups]"
          permit = get_group_member( permit )
        end
        f.puts permit
      }
      f.puts ''
    }
    f.close
  end

  def get_group_member( permit_str )
    @project.principals.find(:all, :conditions => [ 'type = ?', 'Group' ]).each { | group |
      group_members = group.users.collect { | user | user.login }
      permit_str.gsub!("@" + group.lastname, group_members.join(','))
      logger.debug("DEBUG : " + group.lastname + " : " + permit_str)
    }
    return permit_str
  end

end
