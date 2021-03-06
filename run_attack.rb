#!/usr/bin/ruby

require "fileutils"

#This method is used to copy all files the folder /usr/bin to the /tmp dictionary 
#symbolic link will be omitted. 
def copy_files2tmp()
  Dir.foreach('/usr/bin') do |filename|
  	src_path_file = '/usr/bin/'+filename
  	dest_path_file = '/tmp/' + filename
    if not File.symlink?(src_path_file)
    	if not File.exist?(dest_path_file)
    		FileUtils.cp(src_path_file, dest_path_file)
    		msg = "Completed copying the file %-20s to /tmp" % [filename]
    	end

    end
  end
end

copy_files2tmp()
