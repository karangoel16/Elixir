from nltk.book import *
import numpy as np
import pandas as pd
##hyperparameters

#Smoothing model Jelinek-Mercer smoothing (interpolation)

lamda=0.9
def create_dict(text1,token):
	dict={}
	encoder={}
	decoder={}
	for i in token:
		if i.upper() in dict:
			dict[i.upper()]+=1
		else:
			encoder[i.upper()]=len(encoder);
			decoder[len(decoder)]=i.upper();
			dict[i.upper()]=1;
	return dict,encoder,decoder
def excel_data(encoder,mat):
	row=[];
	for i in range(0,len(decoder)):
		row.append(decoder[i]);
	df=pd.DataFrame(mat,index=row,columns=row)
	writer = df.to_excel('result.xlsx')
	writer.save()
def create_dict_2(text1,unigram,encoder,decoder):
	dict={}
	mat=np.zeros((len(unigram),len(unigram)))
	for i in range(0,len(text1)-1):
		check=text1[i].upper()+' '+text1[i+1].upper();
		if check in dict:
			dict[check]+=1
		else:
			dict[check]=1;
	for key in dict:
		pair1,pair2=key.split(' ')
		dict[key]=dict[key]/unigram[pair1]
		mat[encoder[pair1]][encoder[pair2]]=dict[key]
	for i in range(0,len(unigram)):
		for j in range(0,len(unigram)):
			mat[i][j]=lamda*mat[i][j]+((1-lamda)*unigram[decoder[j]]/len(text1));
	return mat

if __name__=="__main__":
	dict_one,encoder,decoder=create_dict(text1,text1.tokens)
	mat=create_dict_2(text1,dict_one,encoder,decoder)
	excel_data(encoder,mat)