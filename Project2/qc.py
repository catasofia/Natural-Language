from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize
import sys

from nltk.stem.porter import *
from nltk.stem import WordNetLemmatizer
from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer, TfidfVectorizer
from sklearn import svm
from sklearn.svm import SVC

import nltk
nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')

  
def parser(fileName):
  sentences=[]
  data=[]
  labels =[]

  with open(fileName,'r',encoding='UTF8') as file:
    while True:
      line=file.readline().replace("\n","").replace("\"","").replace(",","").split("\t")
      if (line==[""]):
        break
      labels.append(line[0])
      sentences.append(line[1:])
  return labels, sentences

def processing(sentences):
  questionsList = []
  stemmer = PorterStemmer()
  lemmatizer = WordNetLemmatizer()

  for i in sentences:
    tokens = word_tokenize(str(i))

    minusculo = [word.lower() for word in tokens]

    stem = [stemmer.stem(word) for word in minusculo]

    lemma = [lemmatizer.lemmatize(word) for word in filtered_words]

    questions = ' '.join(lemma)

    questionsList.append(questions)
  
  return questionsList

# process input files

train_file = sys.argv[4]
test_file = sys.argv[2]

labels, questions = parser(train_file)
trainProcessed = processing(questions)

labelsTest, questionsTest = parser(test_file)
testProcessed = processing(questionsTest)

#support vector machines

countVectorizer = CountVectorizer()


#fit transform in training set and transform for test set
trainVector = countVectorizer.fit_transform(trainProcessed)
testVector  = countVectorizer.transform(testProcessed)

tfIdfTransformer = TfidfTransformer()
train_tfidf = tfIdfTransformer.fit_transform(trainVector)
test_tfidf  = tfIdfTransformer.transform(testVector)

classifier = svm.SVC()
classifier.fit(train_tfidf, labels)

labels_predict = classifier.predict(test_tfidf)


#output predictions
for prediction in labels_predict:
    print(prediction)