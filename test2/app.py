import numpy as np
import pandas as pd
import time
from matplotlib import pyplot as plt
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
st = time.time() 
train=pd.read_csv('train.csv')
lable=train['label']
lable=to_categorical(lable,num_classes=10)
X_train=train.drop(['label'],axis=1)

model = Sequential()
model.add(Dense(800, activation='relu',input_dim=X_train.shape[1]))
model.add(Dense(800, activation='relu'))
model.add(Dense(10 , activation='softmax',))
model.compile(loss='categorical_crossentropy', optimizer='Adam', metrics=['accuracy'])
#model.summary()
model.fit(x=X_train , y=lable , epochs=10)
et = time.time()
print(et-st)