#include<iostream>
#include<fstream>
using namespace std;

void add(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,const long long int x,const long long int y){
	long long int v=0;
	if(x==y){
		if(i<x-1){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			c=v/10;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y);
			foutr<<v%10;
			h++;
		}else if(i==x-1){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			foutr<<v;
			long long int aa=0;
			while(v!=0){
				aa++;
				v=v/10;
			}
			if(aa==0){aa=1;}
			h=h+aa;
		}
	}else{
		if(i<y){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			c=v/10;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y);
			foutr<<v%10;
			h++;
		}else if(i<x-1){
			fin1.seekg(x-i-1,ios::beg);
			char q1;
			fin1>>q1;
			v=(q1-48)+c;
			c=v/10;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y);
			foutr<<v%10;
			h++;
		}else if(i==x-1){
			fin1.seekg(x-i-1,ios::beg);
			char q1;
			fin1>>q1;
			v=(q1-48)+c;
			foutr<<v;
			long long int aa=0;
			while(v!=0){
				aa++;
				v=v/10;
			}
			h=h+aa;
		}
	}
	return;
}