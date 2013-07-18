# handle SU facts
path=File.join(Puppet[:vardir],"sufact")


if File.directory? "#{path}"
  Dir.foreach(path) do |entry|
    entry.chomp
    if File.file? "#{path}/#{entry}"
      Facter.add(entry) do
	setcode do
	  contents = File.read("#{path}/#{entry}")
	  contents.chomp
	end
      end
    end
  end
end
