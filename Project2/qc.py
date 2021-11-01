from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize, word_tokenize
import random



import nltk
nltk.download('stopwords')
nltk.download('punkt')

sentences={}
data=[]

with open('dev_clean.txt','r',encoding='UTF8') as file:
  while True:
    line=file.readline().replace("\n","").replace("\"","").replace(",","").split("\t")
    #print(line)
    if (line==[""]):
      break
    label, sentence, answer = line[0], line[1], line[2]
    """ ps = PorterStemmer()
    words = word_tokenize(sentence)
    print(words)
    steming = [ps.stem(word) for word in words] 

    filtered_words = [word for word in steming if word not in stopwords.words('english')]
    print(filtered_words) """
    data+=([(sentence, label),])
  
  tokens=set(word.lower() for words in data for word in word_tokenize(words[0]))
  train=[({word: (word in word_tokenize(x[0])) for word in tokens}, x[1]) for x in data] 
  print(tokens)
  print(train)


  random.shuffle(train)


  train_x=train[0:400]
  test_x=train[400:500] 
  model = nltk.NaiveBayesClassifier.train(train_x)
  model.show_most_informative_features()

  acc=nltk.classify.accuracy(model, test_x)
  print("Accuracy:", acc)

  #sentences[str([line[1],line[2]])] = line[0]