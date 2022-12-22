import time
import numpy as np
#import pandas as pd
from numpy import genfromtxt
import random
#import matplotlib.pyplot as mlp
time_list=[]
def acc(pre,y):
    s=0
    for i in range(len(y)):
        if pre[i]==y[i]:
            s+=1
    return s/len(y)
def recall(pre,y):
    su=0
    makh=0
    for i in range(len(y)):
        if pre[i]==1 and y[i]==1:
            su+=1
            makh+=1
        elif pre[i]==0 and y[i]==1:
            makh+=1
    return su/makh
def precision(pre,y):
    su=0
    makh=0
    for i in range(len(y)):
        if pre[i]==1 and y[i]==1:
            su+=1
            makh+=1
        elif pre[i]==1 and y[i]==0:
            makh+=1
    return su/makh
for ts in range(100):
    st = time.time()    
    data = genfromtxt('breast_data.csv', delimiter=',')
    y = genfromtxt('breast_truth.csv', delimiter=',')
    traindata=data[0:round(0.8*len(data))]
    testdata=data[round(0.8*len(data)):]
    trainy=y[0:round(0.8*len(y))]
    testy=y[round(0.8*len(y)):]
    pre=np.zeros(len(testy))
    listofacc=[]
    for k in range (10):
        if k % 2 ==1:
            for i in range(len(testdata)):
                dis=[]
                for j in range(len(traindata)):
                    dis.append(np.linalg.norm(testdata[i]-traindata[j]))
                sortindex=np.argsort(dis)
                l=0
                for m in range (k):
                    if trainy[sortindex[m]]==1:
                        l+=1
                    else:
                        l-=1
                if l>0:
                    pre[i]=1
                else:
                    pre[i]=0
            listofacc.append(acc(pre,testy))
            if k==5:
                recall(pre,testy)
                precision(pre,testy)
    z=[1,3,5,7,9]
    et = time.time()
    time_list.append(et - st)
print(np.average(time_list))
#mlp.plot(z,listofacc)