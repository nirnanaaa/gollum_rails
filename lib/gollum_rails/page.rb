module GollumRails

  # Main class, used to interact with rails.
  #
  # Methods, which are available:
  #   * find
  #   * update_attributes
  #   * find_by_*
  #   * create
  #   * new
  #   * save
  #   * delete
  #   * find_or_initialize_by_name
  #
  class Page
    include ::ActiveModel::Model

    include Callbacks
    include Core
    include Store
    include Validation
    include Persistance
    include Finders

  end
  
  ActiveSupport.run_load_hooks(:gollum, Page)
  
 end
