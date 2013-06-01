ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        #span I18n.t("active_admin.dashboard_welcome.welcome")
        #small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    section "Active Jobs" do

      jobs = Job.is_active?.by_start_on
#     jobs = Job.includes(:solution).is_active?.started.ongoing.by_start_on.limit(10)

      table_for jobs do
        column :job_name do |job|
          link_to(job.name, admin_job_path(job))
        end

        column :start do |job|
          job.start_on.strftime("%d %b, %Y")
        end

        column :end do |job|
          job.finished_on.strftime("%d %b, %Y")
        end

      end
    end

    section "Daily Schedules" do

      schedules = Schedule.by_start_on

        table_for schedules do
          column :job_name do |schedule|
            schedule.job.name
          end

          column :day do |schedule|
            # link_to(job.display_name, admin_job_path(job))
            link_to schedule.day.strftime("%d %b, %Y"), admin_job_schedule_path(schedule.job.id, schedule.id)
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
              'None'
            else
              case 
              when  schedule.equipment_units_today == schedule.engagements.size
                'OK'
#             status_tag (schedule.equipment_units_today == schedule.engagements.size ? "OK" : "No"), (schedule.equipment_units_today == schedule.people.size ? :ok : :error)      
              when schedule.equipment_units_today > schedule.engagements.size
                link_to "HIRE", new_admin_schedule_engagement_path(schedule)
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
#        @docket.booking_no = 12345
#        @docket.date_worked = Date.today
#        @docket.save!
#      end

        end
      end


    section "Recent Companies" do
      ul do
        Company.order("updated_at DESC").limit(15).collect do |company|
          li link_to(company.name, admin_company_path(company))
        end
      end
    end

    section "Recent People" do
      ul do
        Person.order("updated_at DESC").limit(15).collect do |person|
          li link_to(person.display_name, admin_person_path(person))
        end
      end
    end

  end # content
end