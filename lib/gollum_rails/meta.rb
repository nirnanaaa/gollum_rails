module GollumRails
  module Meta
    extend ActiveSupport::Concern

    # == Checks if this page has a Yaml part
    #
    # Example YAML part:
    #
    # ---
    # title: "My Page"
    #
    # ---
    #
    # YAML part is seperated from the rest by `---` before and after
    # the content
    #
    # Returns true or false
    def has_yaml?
      !!raw_meta
    end

    # == Gets the pages raw Yaml header.
    #
    #
    # Returns either the raw yaml or an empty string
    def raw_meta
      raw_data.match(/^(?<headers>---\s*\n.*?\n?)^(---\s*$\n?)/m).to_s
    end

    # == Gets the parsed meta data
    #
    #
    # Returns parsed YAML
    def meta
      @meta ||= YAML.load(raw_meta)
    rescue Psych::SyntaxError => e
      {error: e}
    end

    # == Example for meta data usage:
    #
    # Gets the title from the meta data
    #
    # Returns the title or nil
    def meta_title
      meta['title']
    end

    # == Gets the parsed html without the YAML part
    #
    # Returns a string
    def html_without_yaml
      gollum_page.markup_class.render(raw_data.tap{|s| s.slice!(raw_meta.to_s)})
    end

  end
end
