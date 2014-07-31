# ~*~ encoding: utf-8 ~*~
module Gollum
  # Responsible for handling the commit process for a Wiki.  It sets up the
  # Git index, provides methods for modifying the tree, and stores callbacks
  # to be fired after the commit has been made.  This is specifically
  # designed to handle multiple updated pages in a single commit.
  class Committer
    # Gets the instance of the Gollum::Wiki that is being updated.
    attr_reader :wiki

    # Gets a Hash of commit options.
    attr_reader :options

    # Initializes the Committer.
    #
    # wiki    - The Gollum::Wiki instance that is being updated.
    # options - The commit Hash details:
    #           :message   - The String commit message.
    #           :name      - The String author full name.
    #           :email     - The String email address.
    #           :parent    - Optional Grit::Commit parent to this update.
    #           :tree      - Optional String SHA of the tree to create the
    #                        index from.
    #           :committer - Optional Gollum::Committer instance.  If provided,
    #                        assume that this operation is part of batch of
    #                        updates and the commit happens later.
    #
    # Returns the Committer instance.
    def initialize(wiki, options = {})
      @wiki      = wiki
      @options   = options
      @callbacks = []
      after_commit { |*args| Hook.execute(:post_commit, *args) }
    end

    # Public: References the Git index for this commit.
    #
    # Returns a Rugged::Index.
    def index
      @index ||= begin
                   rep = @wiki.repo.index
                   if !@wiki.repo.head_unborn?
                     rep.read_tree(@wiki.repo.head.target.tree)
                   end
                   rep
                 end
    end

    # Public: The committer for this commit.
    #
    # Returns a Grit::Actor.
    def actor
      @actor ||= begin
        @options[:name]  = @wiki.default_committer_name if @options[:name].to_s.empty?
        @options[:email] = @wiki.default_committer_email if @options[:email].to_s.empty?
        {name: @options[:name], email: @options[:email] ,time:Time.now}
      end
    end

    # Public: The parent commits to this pending commit.
    #
    # Returns an array of Grit::Commit instances.
    def parents
      if GitAccess.sha?(@wiki.ref)
        ref_oid = @wiki.ref
      else
        ref_oid = @wiki.repo.ref("refs/heads/#{@wiki.ref}").target.oid
      end

      @parents ||= begin
        arr = [@options[:parent] || @wiki.repo.lookup(ref_oid)]
        arr.flatten!
        arr.compact!
        arr
      end
    end

    # Adds a page to the given Index.
    #
    # dir    - The String subdirectory of the Gollum::Page without any
    #          prefix or suffix slashes (e.g. "foo/bar").
    # name   - The String Gollum::Page filename_stripped.
    # format - The Symbol Gollum::Page format.
    # data   - The String wiki data to store in the tree map.
    # allow_same_ext - A Boolean determining if the tree map allows the same
    #                  filename with the same extension.
    #
    # Raises Gollum::DuplicatePageError if a matching filename already exists.
    # This way, pages are not inadvertently overwritten.
    #
    # TODO Add check for Gollum::DuplicatePageError
    #
    # Returns nothing (modifies the Index in place).
    def add_to_index(dir, name, format, data, allow_same_ext = false)
      @options ||= {}
      dir.gsub!(' ', '-')
      name.gsub!(' ', '-')
      path = @wiki.page_file_name(name, format)
      dir  = '/' if dir.strip.empty?
      fullpath = ::File.join(*[@wiki.page_file_dir, dir, path].compact)
      fullpath = fullpath[1..-1] if fullpath =~ /^\//
      oid = @wiki.repo.write(data, :blob)
      index.add(path: fullpath, oid: oid, mode: 0100644)
      @options[:tree] = index.write_tree(@wiki.repo)
    end

    # Removes a page from the given Index
    #
    # fullpath - The String representation of the location of the file
    #
    # Returns nothing
    def remove_from_index(fullpath)
      index.remove(fullpath)
      @options ||= {}
      @options[:tree] = index.write_tree(@wiki.repo)
    end

    # Update the given file in the repository's working directory if there
    # is a working directory present.
    #
    # dir    - The String directory in which the file lives.
    # name   - The String name of the page or the stripped filename
    #          (should be pre-canonicalized if required).
    # format - The Symbol format of the page.
    #
    # Returns nothing.
    def update_working_dir(dir, name, format)
    end

    # Writes the commit to Git and runs the after_commit callbacks.
    #
    # Returns the String SHA1 of the new commit.
    def commit
      @options ||= {}
      @options[:author] = actor
      @options[:committer] = @options[:author]
      @options[:parents] = @wiki.repo.empty? ? [] : [ @wiki.repo.head.target ].compact
      @options[:update_ref] = 'HEAD'
      sha1 = Rugged::Commit.create(@wiki.repo, options)
      @callbacks.each do |cb|
        cb.call(self, sha1)
      end
      sha1
    end

    # Adds a callback to be fired after a commit.
    #
    # block - A block that expects this Committer instance and the created
    #         commit's SHA1 as the arguments.
    #
    # Returns nothing.
    def after_commit(&block)
      @callbacks << block
    end

    # Determine if a given page (regardless of format) is scheduled to be
    # deleted in the next commit for the given Index.
    #
    # map   - The Hash map:
    #         key - The String directory or filename.
    #         val - The Hash submap or the String contents of the file.
    # path - The String path of the page file. This may include the format
    #         extension in which case it will be ignored.
    #
    # Returns the Boolean response.
    def page_path_scheduled_for_deletion?(map, path)
      parts = path.split('/')
      if parts.size == 1
        deletions = map.keys.select { |k| !map[k] }
        downfile  = parts.first.downcase.sub(/\.\w+$/, '')
        deletions.any? { |d| d.downcase.sub(/\.\w+$/, '') == downfile }
      else
        part = parts.shift
        if rest = map[part]
          page_path_scheduled_for_deletion?(rest, parts.join('/'))
        else
          false
        end
      end
    end

    # Determine if a given file is scheduled to be deleted in the next commit
    # for the given Index.
    #
    # map   - The Hash map:
    #         key - The String directory or filename.
    #         val - The Hash submap or the String contents of the file.
    # path - The String path of the file including extension.
    #
    # Returns the Boolean response.
    def file_path_scheduled_for_deletion?(map, path)
      parts = path.split('/')
      if parts.size == 1
        deletions = map.keys.select { |k| !map[k] }
        deletions.any? { |d| d == parts.first }
      else
        part = parts.shift
        if rest = map[part]
          file_path_scheduled_for_deletion?(rest, parts.join('/'))
        else
          false
        end
      end
    end

    # Proxies methods t
    def method_missing(name, *args)
      args.map! { |item| item.respond_to?(:force_encoding) ? item.force_encoding('ascii-8bit') : item }
      puts name
      index.send(name, *args)
    end
  end
end
