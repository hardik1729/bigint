#include<iostream>
#include<fstream>
using namespace std;

void add(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,const long long int x,const long long int y,const unsigned int b){
	long long int v=0;
	if(x==y){
		if(i<x-1){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			c=v/b;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y,b);
			char out=48+(v%b);
			foutr<<out;
			h++;
		}else if(i==x-1){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			base_case(foutr,v,h,b);
		}
	}else{
		if(i<y){
			fin1.seekg(x-i-1,ios::beg);
			fin2.seekg(y-i-1,ios::beg);
			char q1,q2;
			fin1>>q1;
			fin2>>q2;
			v=(q1-48)+(q2-48)+c;
			c=v/b;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y,b);
			char out=48+(v%b);
			foutr<<out;
			h++;
		}else if(i<x-1){
			fin1.seekg(x-i-1,ios::beg);
			char q1;
			fin1>>q1;
			v=(q1-48)+c;
			c=v/b;
			i++;
			add(fin1,fin2,foutr,c,h,i,x,y,b);
			char out=48+(v%b);
			foutr<<out;
			h++;
		}else if(i==x-1){
			fin1.seekg(x-i-1,ios::beg);
			char q1;
			fin1>>q1;
			v=(q1-48)+c;
			base_case(foutr,v,h,b);
		}
	}
	return;
}