import sys

from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer

from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer, TfidfVectorizer
from sklearn.svm import SVC

import nltk
nltk.download('punkt')
nltk.download('wordnet')

  
def parser(fileName):
  data, labels, sentences=[],[],[]

  with open(fileName,'r',encoding='UTF8') as file:
    for line in file:
      line=line.replace("\n","").replace("\"","").replace(",","").split("\t")
      if len(line)==2:
          sentences.append(line)
      else:
          labels.append(line[0])
          sentences.append(line[1:])
  return labels, sentences

def processing(sentences):
  questionsList = []
  stemmer = PorterStemmer()
  lemmatizer = WordNetLemmatizer()

  for i in sentences:
    tokens = word_tokenize(str(i))

    """ lowCase = [word.lower() for word in tokens]

    stem = [stemmer.stem(word) for word in lowCase]

    lemma = [lemmatizer.lemmatize(word) for word in stem] """

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
countVectorizer = CountVectorizer()
tfIdfTransformer = TfidfTransformer()
classifier = SVC()

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
