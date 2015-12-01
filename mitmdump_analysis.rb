def fread_ary(f)
  a = []
  while line = f.gets
    a << line.chomp
  end
  return a
end

def read_ary(fname = nil)
  if fname && fname != '-'
    File.open(fname, 'r'){|f| return fread_ary(f)}
  else
    return fread_ary($stdin)
  end
end

class PacketInfo
  def initialize(id, dstIP, sCode, error)
    @num = 1
    @id = id
    @dstIP = dstIP
    @sCode = sCode
    @error = error
  end
  attr_accessor :num, :id, :dstIP, :sCode, :error
end

pdata = []

filename = ARGV.shift

lineData = read_ary(filename)
lineData.each{|tmp|
  keyindex = tmp.index("SSL handshake error")
  if keyindex != nil
    pdata << PacketInfo.new(tmp.split(':')[1], " ",tmp.split(':')[2],tmp.split(':')[3]+tmp.split(':')[4])
  end
}

pdata.each{|tmp|
  lineData.each{|tmp2|
    if tmp2.include?(tmp.id) && tmp2.include?("transparent to")
      stmp2 = tmp2.split(':')
      tmp.dstIP = stmp2[2].split(' ')[2] + ":" + stmp2[3].chomp
    end
  }
}

data = []
flag = 0
pdata.each { |tmp|
  data.each { |tmp2|
    if tmp2.dstIP == tmp.dstIP && tmp2.error == tmp.error && tmp2.id != tmp.id
      flag = 1
    else
      flag = 0
    end
  }
  if flag == 0 
    data << tmp
  end
}

p "--------------------------SSL handshake error List--------------------------"
data.each { |tmp| 
  p "IP Address: " + tmp.dstIP + ", Error: " + tmp.error
}


p "--------------------------Access List--------------------------"
p2data = []
p2data << PacketInfo.new("", "", "", "")

lineData.each{|tmp|
  keyindex = tmp.index("transparent to")
  if keyindex != nil
    dIP = tmp.split(':')[2].split(' ')[2]+ ":" +tmp.split(':')[3].chomp
    flag = 0
    p2data.each { |tmp|
      if tmp.dstIP == dIP
        tmp.num = tmp.num + 1
        flag = 1
      end
    }
    if flag == 0 
       p2data << PacketInfo.new("", dIP, "", "")
    end
  end
}

p2data.delete_at(0)
c = p2data.sort{|aa, bb|
  bb.num <=> aa.num
}

c.each{|tmp|
p "IP Address: " + tmp.dstIP.to_s + ", Num: " + tmp.num.to_s
}





