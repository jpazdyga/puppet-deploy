module Puppet::Parser::Functions
  newfunction(:customfunct) do |args|
    filename = args[0]
    test = args[1]
    userid = `id`
    date = `date "+%Y-%m-%d %H:%M:%S" | tr '\n' ' '`
    str = "[" + date + "] " + "This is a test: " + test + ". Here's the id info: " + userid
    File.open(filename, 'a') {|fd| fd.puts str }
  end
end
