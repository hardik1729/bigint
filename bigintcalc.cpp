#include<iostream>
#include<fstream>
#include "add.h"
#include "sub.h"
#include "mult.h"
using namespace std;

int main(){
	fstream fin1,fin2,foutr;
	fin1.open("p.txt");
	fin2.open("q.txt");
	foutr.open("r.txt");
	long long int h=0;
	char s1,s2,q;
	cin>>q;
	long long int x=0;
	long long int y=0;
	while(1){
		fin1>>s1;
		if(s1=='+' || s1=='-'){break;}
		x++;
	}

	while(2){
		fin2>>s2;
		if(s2=='+' || s2=='-'){break;}
		y++;
	}

	if(q=='*'){
		if((s1=='+' && s2=='-')||(s1=='-' && s2=='+')){
			q='-';
		}else{
			q='+';
		}
		if(y>x){
			fin1.close();
			fin2.close();
			fin1.open("q.txt");
			fin2.open("p.txt");
			x=x+y;
			y=x-y;
			x=x-y;
		}
		fin2.seekg(0,ios::beg);
		fin2>>s2;
		if(y==1 && s2=='0'){
			foutr<<"0"<<q;
			cout<<"1"<<endl<<x<<" "<<y;
			return 0;
		}

		long long int c=0;
		long long int i=0;
		long long int j=0;
		long long int k=0;
		long long int l=0;
		mult(fin1,fin2,foutr,c,h,i,j,k,l,x,y);

	}else if((q=='+' && s1==s2)||(q=='-' && s1!=s2)){
		if(q=='+' && s1=='-'){
			q='-';
		}else if(q=='+' && s1=='+'){
			q='+';
		}else if(s1=='+'){
			q='+';
		}else{
			q='-';
		}
		
		if(y>x){
			fin1.close();
			fin2.close();
			fin1.open("q.txt");
			fin2.open("p.txt");
			x=x+y;
			y=x-y;
			x=x-y;
		}

		long long int c=0;
		long long int i=0;

		add(fin1,fin2,foutr,c,h,i,x,y);
		
	}else if((q=='+' && s1!=s2)||(q=='-' && s1==s2)){
		int a=0;
		if(s1=='-'){
			fin1.close();
			fin2.close();
			fin1.open("q.txt");
			fin2.open("p.txt");
			x=x+y;
			y=x-y;
			x=x-y;
			a=1;
		}
		long long int l=0;
		if(y>x){
			if(a==1){
				fin1.close();
				fin2.close();
				fin1.open("p.txt");
				fin2.open("q.txt");
				}else if(a==0){
						fin1.close();
						fin2.close();
						fin1.open("q.txt");
						fin2.open("p.txt");
				}
				x=x+y;
				y=x-y;
				x=x-y;
				q='-';
			}else if(x==y){
				long long int k=0;
					while(k==0 && l<x){
						fin1.seekg(l,ios::beg);
						fin2.seekg(l,ios::beg);
						char q1,q2;
						fin1>>q1;
						fin2>>q2;
						k=q1-q2;
						l++;
					}
					if(k<0){
						if(a==1){
					fin1.close();
					fin2.close();
					fin1.open("p.txt");
					fin2.open("q.txt");
				}else if(a==0){
					fin1.close();
					fin2.close();
					fin1.open("q.txt");
					fin2.open("p.txt");
				}
						l=l-1;
						q='-';
					}else if(k>0){
						fin1.seekg(-1,ios::cur);
						fin2.seekg(-1,ios::cur);
						l=l-1;
						q='+';
					}else if(k==0){
						foutr<<"0+";
						cout<<"1"<<endl<<x<<" "<<y<<endl;
						return 0;
					}
			}else{
				q='+';
			}

			long long int c=0;
			long long int i=0;
			long long int j=0;
			sub(fin1,fin2,foutr,c,h,i,j,x,y,l);
		
	}   
	foutr<<q;
	cout<<h<<endl<<x<<" "<<y<<endl; 
}
