# include <fstream>
//para los archivos
#include<iostream>
#include<conio.h>
#include<stdio.h>
using namespace std;
int main(){
	
	ofstream fiche ("F:\\archi.txt");
	if (!fiche){
		cout << "No se ha podido abrir";
	}
	else{
		string numero;
		string nombre;
		cin >> numero;
		cin >> nombre;
		fiche<< numero;
		fiche<< "  ";
		fiche<<nombre;
//		const char* elvis1="f";
//		
//		fiche.put(elvis1);
	}
	fiche.close();
	//cerramos el modo escritura y leemos
	ifstream leer("F:\\archi.txt");
	if(!leer){
		cout<<"No se ha abierto correctamente";
	}
	else{
		char elvis[9];
		leer.getline(elvis,9);
		printf("%s",elvis);
		
	}
	return 0;
}
