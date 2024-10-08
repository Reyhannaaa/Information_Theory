# -*- coding: utf-8 -*-

import math

data = [
    [30,0,10,0],
    [30,0,70,0],
    [30,1,20,0],
    [30,1,80,1],
    [60,0,40,0],
    [60,0,60,1],
    [60,1,50,0],
    [60,1,60,1]]

def split_features_labels(data):
  d = []
  label=[]
  d = [x[:-1] for x in data]
  label = [x[-1] for x in data]
  return d,label

features_values,label_values=split_features_labels(data)

def transpose_data(data):
  new_data = {'x1':[],'x2':[],'x3':[],'labels':[]}
  for col in data:
    new_data['x1'].append(col[0])
    new_data['x2'].append(col[1])
    new_data['x3'].append(col[2])
    new_data['labels'].append(col[3])
  return new_data

t_data = transpose_data(data)

t_data = transpose_data(data)

"""Entropy Calculation"""

def calculate_entropy(data,i):
  if i == 'a list':
    c = data
  else:
    c = [x[i] for x in data]
  c_set = set(c)
  c_count = {}
  for i in set(c):
    c_count[f'{i}_count']=c.count(i) / len(c)
  entropy=0.0
  for i,j in c_count.items():
   entropy += abs(j * math.log2(j))
  return entropy

"""Conditional Probability ***H(C|X)***"""

def calculate_conditional_entropy(X, Y):
    joint_prob = {}
    total_samples = len(X)
    for x, y in zip(X, Y):
        if (x, y) in joint_prob:
            joint_prob[(x, y)] += 1
        else:
            joint_prob[(x, y)] = 1
    conditional_prob = {}
    for (x, y), count in joint_prob.items():
        if y in conditional_prob:
            conditional_prob[y] += count
        else:
            conditional_prob[y] = count
    conditional_entropy = 0.0
    for (x, y), count in joint_prob.items():
        prob_xy = count / total_samples
        prob_y = conditional_prob[y] / total_samples
        conditional_entropy -= prob_xy * (math.log2(prob_xy / prob_y))
    return conditional_entropy

"""Calculate Information Gain ***I(C;X)***"""

def calculate_information_gain(feature_name,t_data):
  entropy_labels = calculate_entropy(t_data['labels'], 'a list')
  prob_cond_ent_label_feature = calculate_conditional_entropy(t_data['labels'],t_data[feature_name])
  information_gain = entropy_labels - prob_cond_ent_label_feature
  #information_gain_ratio = information_gain / calculate_entropy(t_data[feature_name],'a list')
  return information_gain

"""Calculate information gain ratio ***IGR(C,X)***"""

def calculate_information_gain_ratio(feature_name,t_data):
  return calculate_information_gain(feature_name,t_data) / calculate_entropy(t_data[feature_name],'a list')

list1 = []

def calculate_information_gain_ratio_for_features(list_of_features,t_data):
  l={}
  for i in list_of_features:
    if i != 'labels':
      l[i] = calculate_information_gain_ratio(i,t_data)
  return max(l, key=lambda k:l[k]),l

conditions = []

d,l=calculate_information_gain_ratio_for_features(t_data.keys(),t_data)

middle = int(len(t_data['x3'])/2)
threshold = (sorted(t_data['x3'])[middle] + sorted(t_data['x3'])[middle -1]) / 2
threshold_of_x3 = threshold

conditions.append((d,threshold_of_x3))

list_of_x3_subsets = {'True':[],'False':[]}
for i,j in enumerate(t_data['x3']):
  if j >= threshold_of_x3:
    list_of_x3_subsets['True'].append([t_data['x1'][i],t_data['x2'][i],t_data['x3'][i],t_data['labels'][i]])
  else:
    list_of_x3_subsets['False'].append([t_data['x1'][i],t_data['x2'][i],t_data['x3'][i],t_data['labels'][i]])

t_data_dep1 = t_data

t_data_dep2_True = transpose_data(list_of_x3_subsets['True'])

def transpose_t_data(data):
  l = []
  for i in range(len(data['x1'])):
    l.append(list())
    l[i].append(data['x1'][i])
    l[i].append(data['x2'][i])
    l[i].append(data['x3'][i])
    l[i].append(data['labels'][i])
  return l

t_data_dep2_False = transpose_data(list_of_x3_subsets['False'])

data_dep2_False = transpose_t_data(t_data_dep2_False)

#d,l=calculate_information_gain_ratio_for_features(['x1','x2','x3'],t_data_dep2_False)
#print(d,l)
d,l=calculate_information_gain_ratio_for_features(['x1','x2','x3'],t_data_dep2_True)
#conditions.append((d,l[d]))

middle = int(len(t_data_dep2_True['x3'])/2)
threshold = (sorted(t_data_dep2_True['x3'])[middle] + sorted(t_data_dep2_True['x3'])[middle -1]) / 2
threshold_of_second_x3 = threshold

conditions.append((d,threshold_of_second_x3))

list_of_x3_subsets = {'True':[],'False':[]}
for i,j in enumerate(t_data_dep2_True['x3']):
  if j >= threshold_of_second_x3:
    list_of_x3_subsets['True'].append([t_data_dep2_True['x1'][i],t_data_dep2_True['x2'][i],t_data_dep2_True['x3'][i],t_data_dep2_True['labels'][i]])
  else:
    list_of_x3_subsets['False'].append([t_data_dep2_True['x1'][i],t_data_dep2_True['x2'][i],t_data_dep2_True['x3'][i],t_data_dep2_True['labels'][i]])

t_data_dep3_True = list_of_x3_subsets['True']
t_data_dep3_False = list_of_x3_subsets['False']

t_data_dep3_True = transpose_data(t_data_dep3_True)

t_data_dep3_False = transpose_data(t_data_dep3_False)

d,l = calculate_information_gain_ratio_for_features(['x2','x3','labels'], t_data_dep3_True)

t_data_dep3_True

list_of_x2_subsets = {'True':[],'False':[]}
threshold_of_x2 = sum(t_data_dep3_True['x2']) / len(t_data_dep3_True['x2'])
for i,j in enumerate(t_data_dep3_True['x2']):
  if j >= threshold_of_x2:
    list_of_x2_subsets['True'].append([t_data_dep3_True['x1'][i],t_data_dep3_True['x2'][i],t_data_dep3_True['x3'][i],t_data_dep3_True['labels'][i]])
  else:
    list_of_x2_subsets['False'].append([t_data_dep3_True['x1'][i],t_data_dep3_True['x2'][i],t_data_dep3_True['x3'][i],t_data_dep3_True['labels'][i]])

conditions.append((d,threshold_of_x2))

t_data_dep4_False = transpose_data(list_of_x2_subsets['False'])
t_data_dep4_True = transpose_data(list_of_x2_subsets['True'])

"""                     t_data_dep1
                     /           \
    t_data_dep2_False          t_data_dep2_True
                             /             \
                    t_data_dep3_False    t_data_dep3_True   
                                          /            \
                                t_data_dep4_False   t_data_dep4_True   


"""

data_dep2_True=transpose_t_data(t_data_dep2_True)
data_dep2_False=transpose_t_data(t_data_dep2_False)

tree = {'True':[],'False':[]}

tree['False'].append(data_dep2_False)

tree['True'] = {'True':[],'False':[]}

data_dep3_False = transpose_t_data(t_data_dep3_False)

tree['True']['False'].append(data_dep3_False)

tree['True']['True']={'True':[],'False':[]}

data_dep4_True = transpose_t_data(t_data_dep4_True)

data_dep4_False = transpose_t_data(t_data_dep4_False)

tree['True']['True']['True'] = data_dep4_True
tree['True']['True']['False'] = data_dep4_False

def visualize_tree(data, parent=None, prefix=""):
    if isinstance(data, dict):
        for key, value in data.items():
            node = f"{prefix} {key}" if parent is not None else key
            print(node)
            visualize_tree(value, parent=node, prefix="├──")
    elif isinstance(data, list):
        for item in data:
            if isinstance(item, list):
                node = f"{prefix} {item}"
                print(node)
            else:
                visualize_tree(item, parent=parent, prefix="│   ")


# Visualize the tree
visualize_tree({None: tree})

while True:
  x1 = int(input('x1: '))
  x2 = int(input('x2(0/1): '))
  x3 = int(input('x3: '))
  sample = {'x1':x1,'x2':x2,'x3':x3}
  statement = list()
  for i in conditions:
    statement1 = sample[i[0]] > i[1]
    statement1 = str(statement1)
    if statement1 == "False":
      statement.append(statement1)
      break
    else:
      statement.append(statement1)
  if (len(statement) == 1):
    print("label:",tree[statement[0]][0][0][-1])
  elif (len(statement) == 2):
    print("label:",tree[statement[0]][statement[1]][0][0][-1])
  else:
    print("label",tree[statement[0]][statement[1]][statement[2]][0][-1])
  keep_testing = input("Do you want to continue? (yes/no) ")
  if keep_testing.lower() != 'yes':
    break
  #conditions

