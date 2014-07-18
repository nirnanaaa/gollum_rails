module GollumRails
  module Core
    extend ActiveSupport::Concern
    module ClassMethods

      # Checks if the fileformat is supported
      #
      # format - String
      #
      # Returns true or false
      def format_supported?(format)
        Gollum::Markup.formats.include?(format.to_sym)
      end

      # Resets the folder to /
      def reset_folder
        set_folder(nil)
      end

      # Sets the folder
      def set_folder(options)
        if options.is_a? Hash
          return if options.empty?
          base = options[:base]
          options = options[:folder]
        end
        Setup.wiki_options ||= {}
        Setup.wiki_options[:page_file_dir] = options

        Setup.wiki_options[:base_path] = (base || options) || ''
      end
      alias_method :folder=, :set_folder
    end

    # Initializes a new Page
    #
    # attrs - Hash of attributes
    #
    # commit must be given to perform any page action!
    def initialize(attrs = {})
      assign_attributes(attrs)
      _update_page_attributes if attrs[:gollum_page]
      yield self if block_given?
      run_callbacks :initialize unless _initialize_callbacks.empty?
    end

    # Allows you to set all the attributes by passing in a hash of attributes with
    # keys matching the attribute name
    #
    # new_attributes - Hash - Hash of arguments
    def assign_attributes(new_attributes)
      if !new_attributes.respond_to?(:stringify_keys)
        raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
      end
      return if new_attributes.blank?
      attributes = new_attributes.stringify_keys
      attributes.each do |k, v|
        _assign_attribute(k, v)
      end
    end

    def url_path #:nodoc:
      File.split(url)
    end

    def path_name #:nodoc:
      f = full_path.first
      return '/' if f == '.'
      f
    end

    def full_path #:nodoc:
      File.split(name)
    end

    def file_name #:nodoc:
      full_path.last
    end

    def cname #:nodoc:
      Gollum::Page.cname(self.name)
    end

    # Gets a canonicalized filename of the page
    def canonicalized_filename
      Gollum::Page.canonicalize_filename(name)
    end

    # == Previews the page - Mostly used if you want to see what you do before saving
    #
    # This is an extremely fast method!
    # 1 rendering attempt take depending on the content about 0.001 (simple markdown)
    # upto 0.004 (1000 chars markdown) seconds, which is quite good
    #
    #
    # format - Specify the format you want to render with see {self.format_supported?}
    #          for formats
    #
    # Returns a String
    def preview(format=:markdown)
      require 'active_support/core_ext/string/output_safety'
      wiki.preview_page(name, content, format).formatted_data.html_safe
    end

    # == Gets the url for current page from Gollum::Page
    #
    # Returns a String
    def url
      if gollum_page
        gollum_page.url_path
      end
    end

    # == Gets the title for current Gollum::Page
    #
    # Returns a String
    def title
      gollum_page.title
    end

    # == Gets formatted_data for current Gollum::Page
    #
    # Returns a String
    def html_data
      gollum_page.formatted_data
    end
    # == Gets raw_data for current Gollum::Page
    #
    # Returns a String
    def raw_data
      gollum_page.raw_data
    end

    # == Gets the history of current gollum_page
    #
    # Returns an Array
    def history
      return nil unless persisted?
      gollum_page.versions
    end

    # == Gets the last modified by Gollum::Committer
    #
    # Returns a String
    def last_changed_by
      "%s <%s>" % [history.first.author.name, history.first.author.email]
    end

    # == Compare 2 Commits.
    #
    # sha1 - SHA1
    # sha2 - SHA1
    def compare_commits(sha1,sha2=nil)
      Page.wiki.full_reverse_diff_for(@gollum_page,sha1,sha2)
    end

    # == Checks if current page is a subpage
    def sub_page?
      return nil unless persisted?
      @gollum_page.sub_page
    end

    # == Gets the version of current commit
    #
    def current_version(long=false)
      return nil unless persisted?
      unless long
        @gollum_page.version_short
      else
        @gollum_page.version.to_s
      end

    end

    private

    # == Gets the right commit out of 2 commits
    #
    # commit_local - local commit Hash
    #
    # Returns local_commit > class_commit
    def get_right_commit(commit_local)
      com = commit if commit_local.nil?
      com = commit_local if !commit_local.nil?
      return com
    end

    def _assign_attribute(key, value)
      public_send("#{key}=", value)
    rescue NoMethodError
      if respond_to?("#{key}=")
        raise
      end
    end

    # == Updates local attributes from gollum_page class
    #
    def _update_page_attributes
      @name = gollum_page.name
      @content= gollum_page.raw_data
      @format = gollum_page.format
    end

  end
end
