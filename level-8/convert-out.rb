require "json"

example = "[{:run=>0, :port=>46065, :num=>0, :time=>8.976657}, {:run=>1, :port=>46067, :num=>0, :time=>1345846299.69727}, {:run=>2, :port=>46069, :num=>0, :time=>9.056112}, {:run=>3, :port=>46072, :num=>0, :time=>1345846299.77804}, {:run=>4, :port=>46085, :num=>0, :time=>9.848265}, {:run=>5, :port=>46087, :num=>0, :time=>1345846299.86534}, {:run=>6, :port=>46089, :num=>0, :time=>9.928508}, {:run=>7, :port=>46091, :num=>0, :time=>1345846299.94466}, {:run=>8, :port=>46093, :num=>0, :time=>10.008968}, {:run=>9, :port=>46095, :num=>0, :time=>1345846300.02484}];[{:run=>10, :port=>46099, :num=>1, :time=>10.100633}, {:run=>11, :port=>46103, :num=>1, :time=>1345846300.28285}, {:run=>12, :port=>46105, :num=>1, :time=>10.180518}, {:run=>13, :port=>46107, :num=>1, :time=>1345846300.36562}, {:run=>14, :port=>46110, :num=>1, :time=>10.257894}, {:run=>15, :port=>46134, :num=>1, :time=>1345846301.67601}, {:run=>16, :port=>46136, :num=>1, :time=>10.337581}, {:run=>17, :port=>46138, :num=>1, :time=>1345846301.75794}, {:run=>18, :port=>46141, :num=>1, :time=>10.419079}, {:run=>19, :port=>46172, :num=>1, :time=>1345846303.33459}];[{:run=>20, :port=>46174, :num=>2, :time=>10.498952}, {:run=>21, :port=>46176, :num=>2, :time=>1345846303.41434}, {:run=>22, :port=>46179, :num=>2, :time=>10.582506}, {:run=>23, :port=>46188, :num=>2, :time=>1345846303.95064}, {:run=>24, :port=>46190, :num=>2, :time=>10.662454}, {:run=>25, :port=>46192, :num=>2, :time=>1345846304.03088}, {:run=>26, :port=>46195, :num=>2, :time=>10.743794}, {:run=>27, :port=>46204, :num=>2, :time=>1345846304.57184}, {:run=>28, :port=>46206, :num=>2, :time=>10.821525}, {:run=>29, :port=>46208, :num=>2, :time=>1345846304.65189}];[{:run=>30, :port=>46211, :num=>3, :time=>10.901781}, {:run=>31, :port=>46220, :num=>3, :time=>1345846305.19612}, {:run=>32, :port=>46222, :num=>3, :time=>10.988563}, {:run=>33, :port=>46224, :num=>3, :time=>1345846305.27634}, {:run=>34, :port=>46234, :num=>3, :time=>11.57739}, {:run=>35, :port=>46236, :num=>3, :time=>1345846305.35612}, {:run=>36, :port=>46238, :num=>3, :time=>11.657106}, {:run=>37, :port=>46241, :num=>3, :time=>1345846305.44157}, {:run=>38, :port=>46262, :num=>3, :time=>12.972289}, {:run=>39, :port=>46264, :num=>3, :time=>1345846305.5215}];[{:run=>40, :port=>46266, :num=>4, :time=>13.051812}, {:run=>41, :port=>46269, :num=>4, :time=>1345846305.60484}, {:run=>42, :port=>46286, :num=>4, :time=>14.109051}, {:run=>43, :port=>46288, :num=>4, :time=>1345846305.68473}, {:run=>44, :port=>46290, :num=>4, :time=>14.249428}, {:run=>45, :port=>46308, :num=>4, :time=>1345846306.75503}, {:run=>46, :port=>46310, :num=>4, :time=>14.329215}, {:run=>47, :port=>46312, :num=>4, :time=>1345846306.83567}, {:run=>48, :port=>46315, :num=>4, :time=>14.409626}, {:run=>49, :port=>46324, :num=>4, :time=>1345846307.37532}];"

# should create a json file of output
file = nil
ARGV.each do |b|
  file = b
end

unless file
  data = example
else
  File.open(file, "r") do |infile|
    data = ""
    while (line = infile.gets)
      data += line
    end
  end
end

# assume the begginning & end match this "[...];"
data = data[1..-3]
#p '--- data ---'
#p data
objs = data.split("];[")
#p '--- objs ---'
#p objs

rows = []

for row in objs
  #p '--- row ---'
  #p row
  row_out = []
  
  # the split removes {} from the middles, we'll remove them from the start & end and place them back in when eval'ing
  row = row[1..-2]
  items = row.split("}, {")

  for item in items
    item = item[0..-2] if item.end_with?("}")
    #p '--- item ---'
    #p item
    begin
      obj = eval("{#{item}}")
    end
    #p '--- obj ---'
    #p obj
    row_out.push(obj)
  end
  rows.push(row_out)
end

print rows.to_json
