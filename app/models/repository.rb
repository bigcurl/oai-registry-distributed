class Repository < ActiveRecord::Base
  attr_accessible :url

  validates :uuid, :uniqueness => true,
            :presence => true
  validates :url, :uniqueness => true,
            :presence => true

  before_validation :generate_uuid, :create => true

  def generate_uuid
    begin
      uuid = SecureRandom.uuid
      r = Repository.find_by_uuid uuid # raises an error if empty
      raise if r
    rescue
      retry
    end
    self[:uuid] = uuid
  end

  def url=(url)
    url = Addressable::URI.heuristic_parse(url)
    self[:url] = url.to_s.downcase
  end
end
