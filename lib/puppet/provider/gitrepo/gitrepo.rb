require 'fileutils'

Puppet::Type.type(:gitrepo).provide(:gitrepo) do

    desc "Provides support for the gitrepo provider."

    def create
        destroy
        clone
        ownership
        mode
    end

    def destroy
        FileUtils.rm_rf resource[:path]
    end

    def exists?
        if File.directory?(resource[:path] + "/.git")
            ownership; mode; return true
        end
    end

    def clone
        if resource[:recursive]
            system "git clone --recursive '#{resource[:source]}' '#{resource[:path]}'"
        else
            system "git clone '#{resource[:source]}' '#{resource[:path]}'"
        end
    end

    def ownership
        if resource[:owner] or resource[:group]
            owner = resource[:owner] || nil
            group = resource[:group] || nil
            excld = resource[:exclude] || nil
            system "find '#{resource[:path]}' -not -iwholename '#{excld}' | xargs chown '#{owner}':'#{group}'"
        end
    end

    def mode
        if resource[:mode]
            mode = resource[:mode] || nil
            excld = resource[:exclude] || nil
            system "find '#{resource[:path]}' -type f -not -iwholename '#{excld}' | xargs chmod '#{mode}'"
            mode = mode.gsub("4","5").gsub("6","7")
            system "find '#{resource[:path]}' -type d -not -iwholename '#{excld}' | xargs chmod '#{mode}'"
        end
    end
end
