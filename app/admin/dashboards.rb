#ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

ActiveAdmin.register_page "Dashboard" do
=begin
  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
#       span I18n.t("active_admin.dashboard_welcome.welcome")
#       small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    h2 section "Active Jobs" do

     if Job.count > 0
      # jobs = Job.is_active?.by_start_on
      jobs = Job.includes(:solution).is_active?.started.ongoing.by_start_on.limit(10)

        table_for jobs do
          column :name do |job|
            link_to job.name, admin_solution_job_path( job.solution, job )
          end

          column :start do |job|
            job.start_on.strftime("%d %b, %Y")
          end

          column :end do |job|
            job.finished_on.strftime("%d %b, %Y")
          end

        end
      else
        h3 'There are no active jobs.'
      end
    end

 # section "Dockets" do
 #   div do
      # render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
 #     render 'new_docket' 
 #   end
 # end

    h2 section "Daily Schedules" do

      if Schedule.count > 0
        schedules = Schedule.by_start_on
 
          table_for schedules do
            column :date do |schedule|
              link_to schedule.day.strftime("%A, %d %B, %Y"), admin_job_schedule_path( schedule.job, schedule )
            end
 
            column :project do |schedule|
              link_to schedule.job.solution.quote.project.name, 
                 admin_company_project_path( schedule.job.solution.quote.project.company, schedule.job.solution.quote.project)
            end

            column :equpment do |schedule|
              schedule.job.solution.equipment_name
            end
 
            column "Plan" do |schedule|
              schedule.equipment_units_today.to_s
            end
      
            column "Got" do |schedule|
              schedule.engagements.size.to_s
            end
      
            # active_support/core_ext/date/calculations.rb.
            # active_support/core_ext/date_time/calculations.rb.
            # active_support/core_ext/time/calculations.rb.
            column "Action" do |schedule|
              if schedule.day < Date.current
                'NONE--Date is past'
              else
                case 
                when  schedule.equipment_units_today == schedule.engagements.size
                  'OK'
  #             status_tag (schedule.equipment_units_today == schedule.engagements.size ? "OK" : "No"), (schedule.equipment_units_today == schedule.people.size ? :ok : :error)      
                when schedule.equipment_units_today > schedule.engagements.size
                  h5 link_to "HIRE", new_admin_schedule_engagement_path(schedule)
                else
                  'Evaluate'
                end
              end
            end
      
            column "Engagement" do |schedule|
              if schedule.day >= Date.current
                link_to "Roster", admin_schedule_engagements_path(schedule)
              end
            end

#      column "Dockets" do |schedule|
#        @docket = Docket.new
#        render 'new_docket' 
#        @docket.number = 12345
#        @docket.date_worked = Date.today
#        @docket.save!
#      end

          end

        else
          h3 'There are no active Schedules.'
        end#if
      end


     h2 section "Recent Companies" do
      h3 ul do
        Company.order("updated_at DESC").limit(15).collect do |company|
          li link_to(company.name, admin_company_path(company))
        end
      end
    end

    h2 section "15 Most Recently Contacted People" do
      h3 ul do
        Person.order("updated_at DESC").limit(15).collect do |person|
          li link_to(person.display_name + ' -- '+"#{person.company.name}", admin_company_person_path(person.company, person))
        end
      end
    end

  end
=end
end

