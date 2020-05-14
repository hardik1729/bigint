#include<iostream>
#include<fstream>
using namespace std;

void sub(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,long long int &j,const long long int x,const long long int y,const long long int l){
	long long int v=0;
	if(i<y-l){
		fin1.seekg(x-i-1,ios::beg);
		fin2.seekg(y-i-1,ios::beg);
		char q1,q2;
		fin1>>q1;
		fin2>>q2;
		v=(q1-48)-(q2-48)-c;
		if(v<0){
			v=v+10;
			c=1;
		}else{
			c=0;
		}
		i++;
		sub(fin1,fin2,foutr,c,h,i,j,x,y,l);
		if(j==0 && v!=0){
			j=1;
		}
		if(j==1){
			foutr<<v;
			h++;
		}
	}else if(i<x-l){
		fin1.seekg(x-i-1,ios::beg);
		char q1;
		fin1>>q1;
		v=(q1-48)-c;
		if(v<0){
			v=v+10;
			c=1;
		}else{
			c=0;
		}
		i++;
		sub(fin1,fin2,foutr,c,h,i,j,x,y,l);
		if(j==0 && v!=0){
			j=1;
		}         
		if(j==1){
			foutr<<v;
			h++;
		}
	}
	return;
}