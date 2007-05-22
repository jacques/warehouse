class Permission < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
  before_create { |r| r.active = true }
  validates_presence_of :repository_id
  attr_accessible :login, :admin, :path, :full_access

  def login
    l = read_attribute :login
    l.blank? ? '*' : l
  end
  
  def formatted_path
    "/#{path}"
  end

  def self.grant(repository, options = {})
    returning repository.all_permissions.build do |m|
      m.active     = true
      m.attributes = options
      yield m
      m.save
    end
  end
end