from __future__ import with_statement
import subprocess, sys, re

def process(results_src,results_dst,char,name, subdir, regex):
  time_regex = re.compile("\s+TIME=\s*(\d\.\d+E-?\d+)\s*")
  location_regex = re.compile("\s+(\d+)\s+([\d\.\-E]+)\s+([\d\.\-E]+)\s+")
  subprocess.call(['mkdir -p ' + results_dst + '/'+ subdir,''],shell=True)
  cmd = 'ls ' + results_src  + ' | grep ' + char  + '_P | wc -l'
  output = subprocess.Popen([cmd, ''],shell=True, stdout=subprocess.PIPE).communicate()[0]
  count = int(output)
  nodes = {}
  with open(results_src + "/"+name+"_NODE_LOCATIONS") as locations_f:
    for line in locations_f:  
      r = location_regex.match(line)
      if r:
        n = int(r.group(1))
        nodes[n] = {}
        nodes[n]['x'] = r.group(2)
        nodes[n]['y'] = r.group(3)
        nodes[n]['data'] = {}
  for i in range(1,count+1):
    time = None
    with open(results_src + "/"+ char +"_P_" + str(i)) as p_f:
      for line in p_f:
        if not time:
          r = time_regex.match(line)
          if r:
            time_str = r.group(1)
            time = float(time_str)
          else:
            r = regex.match(line)
            if r:
              n = int(r.group(1))
              nodes[n]['data'][time] = {}
              nodes[n]['data'][time]["str"]=time_str
              nodes[n]['data'][time][char] = r.group(2)
  for k,v in enumerate(nodes):
    n = open(results_dst + "/"+subdir+"/node" + str(v), 'w')
    n.write("(" + nodes[v]['x'] +","+ nodes[v]['y'] + ")\n")
    for k2 in sorted(nodes[v]['data']):
      v2 = nodes[v]['data'][k2]
      a = -1
      p = -1
      s = -1
      if 'a' in v2:
        a = v2['a']
      if 'p' in v2:
        p = v2['p']
      if 's' in v2:
        s = v2['s']
      toprint=v2['str'] + "\t" +str(a) + "\t" + str(p) + "\t" +str(s) + "\n"
      n.write(toprint)
    n.close()

def main():
  if len(sys.argv)!=2:
    print "usage:python process.py <dir>"
    exit(0)
  results_base="/data2/blast_project/ansys/results"
  results_src=results_base+"/"+sys.argv[1]
  results_dst=results_base+"/"+sys.argv[1]+"_processed"
  subprocess.call(['mkdir -p ' + results_dst,''],shell=True)
  #pres_regex = re.compile("\s+(\d+)\s*(-?\d+\.\d*(?:E-?\d+)?)")
  pres_regex = re.compile("^\s*(\d+)\s*([0-9\.\-]+)$")
  process(results_src,results_dst,'B','BRAIN','brain', pres_regex)
  
if __name__ == "__main__":
  main()