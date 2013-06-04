class Identifier < ActiveRecord::Base
  
  # audited, not on Rails 4 yet

  belongs_to :addressable, :polymorphic => true
  belongs_to :personable, :polymorphic => true

  # removed, prevents @contact.save operations if present
  # validates_presence_of :identifiable_id, :identifiable_type, :name, :value
  validates :rank, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than => 10}
   
  # this doesn't seem to work?
  scope :ranked, order("rank DSC")
  
  after_initialize :defaults

  def defaults
     unless persisted?
       self.rank ||= 1
    end
  end
  
  
end
