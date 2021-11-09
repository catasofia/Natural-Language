"""
NLP 2021 - IST

Group 25:
Catarina Sousa 93695
Nelson Trindade 93743
"""

import sys
import nltk

from nltk.tokenize import word_tokenize

from sklearn.svm import SVC
from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer, TfidfVectorizer

#Downloads necessary
nltk.download('punkt')
nltk.download('wordnet')

  
def parseLine(line):
  line = line.replace("\n","").replace("\"","").replace(",","").split("\t")
  return [x for x in [x for x in line if x!=""] if x!=" "]

def parser(fileName):
  labels, sentences=[],[]

  with open(fileName,'r',encoding='UTF8') as file:
    for line in file:
      line = parseLine(line)

      if (len(line)==2): #Q&A only
        labels.append("")
        sentences.append(line)
      else: #Label&Q&A
        labels.append(line[0])
        sentences.append(line[1:])
  return labels, sentences

def processing(sentences):
  questionsList = []
  for i in sentences:
    tokens = word_tokenize(str(i))
    questionsList.append(' '.join(tokens))
  return questionsList

# process input files
test_file = sys.argv[2]
train_file = sys.argv[4]

labels, questions = parser(train_file)
trainProcessed = processing(questions)

labelsTest, questionsTest = parser(test_file)
testProcessed = processing(questionsTest)

#initialize functions
classifier = SVC()
countVectorizer = CountVectorizer()
tfIdfTransformer = TfidfTransformer()

#fit transform in training set and transform for test set
trainVector = countVectorizer.fit_transform(trainProcessed)
testVector  = countVectorizer.transform(testProcessed)

#Transform a count matrix to a normalized tf or tf-idf representation.
train_tfidf = tfIdfTransformer.fit_transform(trainVector)
test_tfidf  = tfIdfTransformer.transform(testVector) 

classifier.fit(train_tfidf, labels)
labels_predict = classifier.predict(test_tfidf)

#output predictions
for prediction in labels_predict:
  print(prediction)