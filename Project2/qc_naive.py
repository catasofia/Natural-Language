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

    questionsList.append(' '.join(lemma))
  
  return questionsList

test_file = sys.argv[2]
train_file = sys.argv[4]

labels, questions = parser(train_file)
questionsProcessed = processing(questions)

print(questionsProcessed)

labelsTest, questionsTest = parser(test_file)
testProcessed = processing(questionsTest)

classifier = GaussianNB();
classifier.fit(questionsProcessed, labels)

y_pred = classifier.predict(testProcessed)

for i in y_pred:
  print(i)
