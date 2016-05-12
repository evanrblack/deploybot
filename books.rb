def book(file)
  lines = File.readlines(file)
  start = rand(lines.length)
  length = rand(1..5)
  lines[start..start+length].join
end
