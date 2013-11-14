from __future__ import with_statement
import subprocess, sys, re
if len(sys.argv)!=2:
  print "usage:python process.py <dir>"
  exit(0)
results_base="/data2/blast_project/ansys/results"
results_src=results_base+"/"+sys.argv[1]
results_dst=results_base+"/"+sys.argv[1]+"_processed"
output = subprocess.Popen(['ls ' + results_src  + ' | grep B_A | wc -l', ''],shell=True, stdout=subprocess.PIPE).communicate()[0]
b_count = int(output)
output = subprocess.Popen(['ls ' + results_src  + ' | grep O_P | wc -l', ''],shell=True, stdout=subprocess.PIPE).communicate()[0]
o_count = int(output)
output = subprocess.Popen(['ls ' + results_src  + ' | grep I_P | wc -l', ''],shell=True, stdout=subprocess.PIPE).communicate()[0]
i_count = int(output)
output = subprocess.Popen(['ls ' + results_src  + ' | grep L_P | wc -l', ''],shell=True, stdout=subprocess.PIPE).communicate()[0]
l_count = int(output)
subprocess.call(['mkdir -p ' + results_dst,''],shell=True)
subprocess.call(['mkdir -p ' + results_dst + '/brain',''],shell=True)
subprocess.call(['mkdir -p ' + results_dst + '/outer',''],shell=True)
subprocess.call(['mkdir -p ' + results_dst + '/inner',''],shell=True)
subprocess.call(['mkdir -p ' + results_dst + '/load',''],shell=True)
b_nodes = {}
o_nodes = {}
i_nodes = {}
l_nodes = {}
with open(results_src + "/BRAIN_NODE_LOCATIONS") as locations_f:
  location_regex = re.compile("\s+(\d+)\s+([\d\.\-E]+)\s+([\d\.\-E]+)\s+")
  for line in locations_f:  
    r = location_regex.match(line)
    if r:
      n = int(r.group(1))
      b_nodes[n] = {}
      b_nodes[n]['x'] = r.group(2)
      b_nodes[n]['y'] = r.group(3)
      b_nodes[n]['data'] = {}
time_regex = re.compile("\s+TIME=\s*(\d\.\d+E-?\d+)\s*")
accel_regex = re.compile("\D+(\d+)\s+-?\d+\.\d*(?:E-?\d+)?\s*-?\d+\.\d*(?:E-?\d+)?\s*(-?\d+\.\d*(?:E-?\d+)?)")
pres_regex = re.compile("\s+(\d+)\s*(-?\d+\.\d*(?:E-?\d+)?)")
strain_regex = re.compile("\D+(\d+)\s+-*\d\.\d+E-?\d+\s*-*\d\.\d+E-*\d+\s*-*\d\.\d+E-*\d+\s*-*\d\.\d+E-*\d+\s*(-*\d\.\d+E-?\d+)")
for i in range(1,b_count+1):
  time = None
  with open(results_src + "/B_A_" + str(i)) as b_a_f:
    for line in b_a_f:
      if not time:
        r = time_regex.match(line)
        if r:
          time_str = r.group(1)
          time = float(time_str)
      else:
        r = accel_regex.match(line)
        if r:
          n = int(r.group(1))
          b_nodes[n]['data'][time] = {}
          b_nodes[n]['data'][time]["str"]=time_str
          b_nodes[n]['data'][time]['a'] = r.group(2)
  with open(results_src + "/B_P_" + str(i)) as b_p_f:
    for line in b_p_f:
      r = pres_regex.match(line)
      if r:
        n = int(r.group(1))
        b_nodes[n]['data'][time]['p'] = r.group(2)
  with open(results_src + "/B_S_" + str(i)) as b_s_f:
    for line in b_s_f:
      r = strain_regex.match(line)
      if r:
        n = int(r.group(1))
        b_nodes[n]['data'][time]['s'] = r.group(2)
with open(results_src + "/OUTER_NODE_LOCATIONS") as locations_f:
  location_regex = re.compile("\s+(\d+)\s+([\d\.\-E]+)\s+([\d\.\-E]+)\s+")
  for line in locations_f:  
    r = location_regex.match(line)
    if r:
      n = int(r.group(1))
      o_nodes[n] = {}
      o_nodes[n]['x'] = r.group(2)
      o_nodes[n]['y'] = r.group(3)
      o_nodes[n]['data'] = {}
for i in range(1,o_count+1):
  time = None
  with open(results_src + "/O_P_" + str(i)) as b_p_f:
    for line in b_p_f:
      if not time:
        r = time_regex.match(line)
        if r:
          time_str = r.group(1)
          time = float(time_str)
      else:
        r = pres_regex.match(line)
        if r:
          n = int(r.group(1))
          o_nodes[n]['data'][time] = {}
          o_nodes[n]['data'][time]["str"]=time_str
          o_nodes[n]['data'][time]['p'] = r.group(2)
with open(results_src + "/INNER_NODE_LOCATIONS") as locations_f:
  location_regex = re.compile("\s+(\d+)\s+([\d\.\-E]+)\s+([\d\.\-E]+)\s+")
  for line in locations_f:  
    r = location_regex.match(line)
    if r:
      n = int(r.group(1))
      i_nodes[n] = {}
      i_nodes[n]['x'] = r.group(2)
      i_nodes[n]['y'] = r.group(3)
      i_nodes[n]['data'] = {}
for i in range(1,i_count+1):
  time = None
  with open(results_src + "/I_P_" + str(i)) as b_p_f:
    for line in b_p_f:
      if not time:
        r = time_regex.match(line)
        if r:
          time_str = r.group(1)
          time = float(time_str)
      else:
        r = pres_regex.match(line)
        if r:
          n = int(r.group(1))
          i_nodes[n]['data'][time] = {}
          i_nodes[n]['data'][time]["str"]=time_str
          i_nodes[n]['data'][time]['p'] = r.group(2)
with open(results_src + "/LOAD_NODE_LOCATIONS") as locations_f:
  location_regex = re.compile("\s+(\d+)\s+([\d\.\-E]+)\s+([\d\.\-E]+)\s+")
  for line in locations_f:  
    r = location_regex.match(line)
    if r:
      n = int(r.group(1))
      l_nodes[n] = {}
      l_nodes[n]['x'] = r.group(2)
      l_nodes[n]['y'] = r.group(3)
      l_nodes[n]['data'] = {}
for i in range(1,l_count+1):
  time = None
  with open(results_src + "/L_P_" + str(i)) as b_p_f:
    for line in b_p_f:
      if not time:
        r = time_regex.match(line)
        if r:
          time_str = r.group(1)
          time = float(time_str)
      else:
        r = pres_regex.match(line)
        if r:
          n = int(r.group(1))
          l_nodes[n]['data'][time] = {}
          l_nodes[n]['data'][time]["str"]=time_str
          l_nodes[n]['data'][time]['p'] = r.group(2)
for k,v in enumerate(b_nodes):
  n = open(results_dst + "/brain/node" + str(v), 'w')
  n.write("(" + b_nodes[v]['x'] +","+ b_nodes[v]['y'] + ")\n")
  for k2 in sorted(b_nodes[v]['data']):
        v2 = b_nodes[v]['data'][k2]
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
for k,v in enumerate(o_nodes):
  n = open(results_dst + "/outer/node" + str(v), 'w')
  n.write("(" + o_nodes[v]['x'] +","+ o_nodes[v]['y'] + ")\n")
  for k2 in sorted(o_nodes[v]['data']):
    v2 = o_nodes[v]['data'][k2]
    a = -1
    p = -1
    s = -1
    if 'p' in v2:
      p = v2['p']
      toprint=v2['str'] + "\t" +str(a) + "\t" + str(p) + "\t" +str(s) + "\n"
      n.write(toprint)
  n.close()
for k,v in enumerate(i_nodes):
  n = open(results_dst + "/inner/node" + str(v), 'w')
  n.write("(" + i_nodes[v]['x'] +","+ i_nodes[v]['y'] + ")\n")
  for k2 in sorted(i_nodes[v]['data']):
    v2 = i_nodes[v]['data'][k2]
    a = -1
    p = -1
    s = -1
    if 'p' in v2:
      p = v2['p']
      toprint=v2['str'] + "\t" +str(a) + "\t" + str(p) + "\t" +str(s) + "\n"
      n.write(toprint)
  n.close()
for k,v in enumerate(l_nodes):
  n = open(results_dst + "/load/node" + str(v), 'w')
  n.write("(" + l_nodes[v]['x'] +","+ l_nodes[v]['y'] + ")\n")
  for k2 in sorted(l_nodes[v]['data']):
    v2 = l_nodes[v]['data'][k2]
    a = -1
    p = -1
    s = -1
    if 'p' in v2:
      p = v2['p']
      toprint=v2['str'] + "\t" +str(a) + "\t" + str(p) + "\t" +str(s) + "\n"
      n.write(toprint)
  n.close()
