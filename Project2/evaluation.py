import sys
from sklearn import metrics

y_test = open(sys.argv[1])
y_pred = open(sys.argv[2])

y_label = list()
y_res = list()

for line in y_pred:
    aux, trash = line.split('\n')
    y_res.append(aux)


for line in y_test:
    aux, trash = line.split('\t')[0:2]
    y_label.append(aux)

print('\n'.join('\t'.join(x) for x in zip(y_label,y_res) if x[0] != x[1]))

# Model Accuracy: how often is the classifier correct?
#print(y_res)
#print('-')
#print(y_label)
print("Accuracy:",metrics.accuracy_score(y_label, y_res) * 100 , "%")