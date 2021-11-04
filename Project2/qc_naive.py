import sys
import numpy as np
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer

from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer, TfidfVectorizer
from sklearn.svm import SVC

from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import train_test_split
 

import nltk
nltk.download('punkt')
nltk.download('wordnet')

def parser(fileName):
  data, labels, sentences=[],[],[]

  with open(fileName,'r',encoding='UTF8') as file:
    for line in file:
      line=line.replace("\n","").replace("\"","").replace(",","").split("\t")
      labels.append(line[0])
      sentences.append(line[1:])
  return labels, sentences

def processing(sentences):
  questionsList = []
  stemmer = PorterStemmer()
  lemmatizer = WordNetLemmatizer()

  for i in sentences:
    tokens = word_tokenize(str(i))

    lowCase = [word.lower() for word in tokens]

    stem = [stemmer.stem(word) for word in lowCase]

    lemma = [lemmatizer.lemmatize(word) for word in stem]

    questionsList.append(' '.join(tokens))
  
  return questionsList

test_file = sys.argv[2]
train_file = sys.argv[4]

labels, questions = parser(train_file)
questionsProcessed = processing(questions)

labelsTest, questionsTest = parser(test_file)
testProcessed = processing(questionsTest)

cv = CountVectorizer()

X = cv.fit_transform(questionsProcessed).toarray()
y = labels

X_train, X_test, y_train, y_test = train_test_split(
           X, labels, test_size = 0.1, random_state = 0)

classifier = GaussianNB();
classifier.fit(X_train, y_train)

y_pred = classifier.predict(testProcessed)


for line in y_pred:
    aux, trash = line.split('\n')
    y_res.append(aux)


for line in labelsTest:
    aux, trash = line.split('\n')
    y_label.append(aux)

print('\n'.join('\t'.join(x) for x in zip(y_label,y_res) if x[0] != x[1]))

# Model Accuracy: how often is the classifier correct?
#print(y_res)
#print('-')
#print(y_label)
print("Accuracy:",metrics.accuracy_score(y_label, y_res) * 100 , "%")
