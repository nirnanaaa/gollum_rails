module GollumRails
  # Playground
  module Orm
    extend ActiveSupport::Concern
    def save
      super
    end
  end
end
