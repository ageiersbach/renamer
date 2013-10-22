class Renamer
	$home
	$dest
	$count

	def initialize(path, dest)
		$home = path
		$dest = dest
    $count = 0
	end
  
  def rename_files
    folders =  Dir.entries($home).select {|entry| File.directory? File.join($home,entry) and !(entry =='.' || entry == '..') }
    folders.each do |folder|
      #puts "#{folder}"
      @files = Dir.glob($home + "/" + folder + "/*.pdf")
      if @files.any?
        Dir.chdir($dest)
        Dir.mkdir(folder) unless Dir.exists?(folder)
        rename(@files, folder)
        $count += 1
      end
    end
    puts "renamed #{$count} files."
  end

	def rename(files, foldername)
		files.each do |f|
			@old_name = File.basename(f, File.extname(f))
      @new_name = new_filename(@old_name) << File.extname(f)
      #puts "#{@new_name} to #{$dest}"
      if File.file?($dest + foldername + "/" + @newname)
        File.rename(f, $dest + foldername + "/" + @new_name + "-copy")
      else
        File.rename(f, $dest + foldername + "/" + @new_name)
      end
      @new_name.clear
		end
	end
	
	def new_filename(old_name) 
		@final_filename = ""
    @newname = ""
    filenames = old_name.split('-')
    filenames.each do |f|
      f_ints = f.count("0-9")
      if f_ints < 4
        if @newname.empty?
          @newname << f.strip
        else
          @newname << "; " << f.strip
        end
      else
        @date = parse_date(f.strip)
        if @date.empty?
          if @newname.empty?
            @newname << f.strip
          else
            @newname << "; " << f.strip
          end
        end
      end
    end
   
    if @date
      @final_filename << @date << "#" << @newname
    else
      @final_filename << "#" << @newname
    end

	end
	
	def parse_date(num)
    a,b,c = num.split('.')
    @date = "" 
    #puts "trying to parse #{num}"
    if (a.length<4 && c.length==2) 
      @year = "20" + c
      @month = a
      @day = b  
    elsif (a.length==4)
      @year = a
      @month = b 
      @day = c
    else
     puts "parse #{num} failed." 
    end

    unless a && b && c
      return @date
    end

    @date << @year
    if @month.length < 2
      @date << "0"
    end
    
    @date << @month
    if @day.length < 2
      @date << "0"
    end
    
    @date << @day
    @date
	end

end

scans = Renamer.new(ENV['home'], ENV['dest'])
scans.rename_files
