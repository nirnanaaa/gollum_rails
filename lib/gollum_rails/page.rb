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
  #   * find_or_initialize_by_id
  #
  class Page < Adapters::ActiveModel::Callback
    include ::ActiveModel::Conversion
    extend ::ActiveModel::Naming
    
    # Gets / Sets the gollum page
    attr_accessor :gollum_page

    # Initializes a new Page
    #
    #
    # if save() or create() is called, the 
    def initialize(attrs)
      attrs.each{|k,v| self.instance_variable_set("@#{k}", v)}
    end

    #########
    # Setters
    #########
     
    # Sets the wiki instance
    attr_writer :wiki

    # Sets the pages name
    attr_writer :name

    # Sets the contents content
    attr_writer :content

    # Sets the commit Hash
    attr_writer :commit

    # Sets the format
    attr_writer :format
    
    #########
    # Getters
    #########

    # Gets the wiki instance
    def wiki
      @wiki || Adapters::Gollum::Connector.wiki_class
    end

    # Gets the pages' name
    def name
      @name || @gollum_page.name
    end

    # Gets the raw content of the current page
    def content
      @content || @gollum_page.raw_content
    end

    # Need to implement the Committer connector (forgot it completely)
    # Gets the commit Hash from current object
    def commit
      @commit
    end

    # Gets the pages format
    def format
      @format || @gollum_page.format
    end

    # Gets the validator
    def self.validator
      Adapters::ActiveModel::Validation
    end

    #############
    # activemodel
    #############

    # Handles the connection betweet plain activemodel and Gollum
    # Saves current page in GIT wiki
    #
    # Examples:
    #
    def save
      self.class.superclass.run_callback :save do
        puts "test"
        puts @wiki.page(@name) 
      end
    end

    # Checks if 
    def valid?
    end
    
    def self.create
      run_callback :create do

      end
    end

    def self.find
      run_callback :find do
        
      end
    end

    def self.validate(&block)
      validator = self.validator.new
      block.call validator 
    end
    def self.register_validations_for(*args)
      context = <<-END
      END
      self.validator.class_eval(context)
    end


    # module templates following:


    def update_attributes(&block)
    end
    
    def delete
      run_callback :delete do
      end
    end

    #callbacks


    def self.method_missing(name, *args)
    end
    
    def self.find_or_initialize_by_id
    end

    def self.format_supported?(format)
    end

  end
end
