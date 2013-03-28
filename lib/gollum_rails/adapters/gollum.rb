# ~*~ encoding: utf-8 ~*~
module GollumRails

  # Gollum Wiki connector classes
  #
  # TODO:
  #   * implement
  #
  # FIXME:
  #   currently nothing implemented
  #
  module Gollum

    # Sets the page class used by all instances
    attr_writer :page_class

    # Sets the wiki class used by all instances
    attr_writer :wiki_class

    # Sets the committer
    attr_writer :committer

    # Gets the Globally used Page class or use a new one if not defined
    #
    #
    # Returns the internal page class or a fresh ::Gollum::Page
    def page_class
      @page_class || ::Gollum::Page
    end

    # Gets the Globally used Page class or use a new one if not defined
    #
    #
    # Returns the internal page class or a fresh ::Gollum::Page
    def wiki_class
      @wiki_class || ::Gollum::Wiki
    end

    # Gets the current committer or using anon
    #
    #
    def committer
      @committer ||=
        if Committer.kind_of? ::Gollum::Committer
          Committer
        else
          ::Gollum::Committer
        end
    end

  end
end

