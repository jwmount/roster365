class AddHourlyHireRateToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :hourly_hire_rate, :decimal
  end
end
