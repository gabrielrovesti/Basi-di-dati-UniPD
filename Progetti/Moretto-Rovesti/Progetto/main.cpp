#include <iostream>
#include <string>
#include <vector>

#include "dependencies/include/libpq-fe.h"

using std::cout;
using std::cin;
using std::string;
using std::vector;

#define PG_HOST "127.0.0.1"
#define PG_USER "giuliomoretto"
#define PG_PASSWORD "root"
#define PG_PORT 5433
#define PG_DB "fogfestival"

//g++ main.cpp -I /Users/giuliomoretto/basidati/fog   -L dependencies/lib -lpq -o db  -std=c++11

PGresult* doQuery(PGconn* conn, string query){

    PGresult* res;
    res = PQexec(conn,query.c_str());

    if(query.find("SELECT") != string::npos){
        //Do query
        if(PQresultStatus(res) != PGRES_TUPLES_OK){
            cout<<"Errore di esecuzione query "<<query<<" "<<PQerrorMessage(conn);
            return res;
        }
    }else{
        //Do command
        if(PQresultStatus(res)!=PGRES_COMMAND_OK){
            cout<<"Errore esecuzione "<<PQerrorMessage(conn);

        }
    }

    //No error so return
    return res;

}

void printSeparatorRow(int ncol, const vector<int>& maxLengths){
    
     for(int c=0; c<ncol; c++){

        cout<<"+";
        int spaces = maxLengths[c]+1;
        for(int s=0; s<spaces; s++){
            cout<<"-";
        }
         if(c<ncol-1)
             cout<<"-";
         else
             cout<<"-+";
    }

    cout<<"\n";

}

void printTable(PGresult* res){

    cout<<"\n";

    const int ncol = PQnfields(res);
    const int nrows = PQntuples(res);

    vector<int> maxLengths;
    
    //Set lenghts to column title
    for(int c=0; c<ncol; c++){
        char* name = PQfname(res,c);
        maxLengths.push_back(strlen(name));
    }    
 
    //Set lenght to max value length
    for(int r=0; r<nrows; r++){
        for(int c=0; c<ncol; c++){
            const char* val = PQgetvalue(res,r,c);
            int len = strlen(val);
            if(len>maxLengths[c])
                maxLengths[c] = len;
        }
    }

    printSeparatorRow(ncol,maxLengths);

    //Display Columns
    for(int c=0; c<ncol; c++){
        char* name = PQfname(res,c);
        int spaces = maxLengths[c]-strlen(name);
        if(spaces<0)
            spaces *= -1;

        cout<<"| "<<name;
        for(int s=0; s<spaces; s++){
            cout<<" ";
        }
        if(c<ncol-1)
            cout<<" ";
        else
            cout<<" |";
    }

    cout<<"\n";

    printSeparatorRow(ncol,maxLengths);


    //Diplay values
    for(int r=0; r<nrows; r++){
        for(int c=0; c<ncol; c++){
            const char* val = PQgetvalue(res,r,c);
            int spaces = maxLengths[c]-strlen(val); 
            if(spaces<0)
                spaces *= -1;   

            cout<<"| "<<val;
            for(int s=0; s<spaces; s++){
                cout<<" ";
            }
            if(c<ncol-1)
                cout<<" ";
            else
                cout<<" |";
                
        }
        cout<<"\n";
    }

    printSeparatorRow(ncol,maxLengths);

    cout<<"\n";

}

void printMainMenu(){

    vector<string> choices = {
        "1 - Festival che ha ricevuto più sponsorizzazioni",
        "2 - Artisti headliner del festival con più partecipazione media in base alle giornate",
        "3 - Prezzo medio pagato dai clienti paganti per edizione di un certo festival",
        "4 - Artisti non headliner che hanno soggiornato nel camerino VIP più grande e più frequentato",
        "5 - Numero di concerti effettuati per le combinazioni di tipologia di impianto audio e luci",
    };

    for(auto i = choices.begin(); i != choices.end(); ++i){
        cout<<*i<<"\n"; 
    }

}

int selectChoice() {
	
    int choice = 0;
	
    while(choice == 0) {
		
        cout << "Inserisci scelta (da 1 a 5, -1 per uscire)";
		cin >> choice;
        
	}

	return choice;
}

int main(int argc, char **argv){

    //parse argv for connection arguments

    
    //do connection and test
    char connParams[120];
    sprintf(connParams,"user=%s password=%s dbname=%s port=%d",PG_USER,PG_PASSWORD,PG_DB,PG_PORT);
    PGconn *conn;
    conn = PQconnectdb(connParams);

    if(PQstatus(conn)!= CONNECTION_OK){
        cout<<"Errore di connessione: "<<PQerrorMessage(conn);
    }

    //print welcome + menu
    cout<<"Benvenuto seleziona una query inserendo il numero corrispondente"<<"\n";

   
    
    int choice = 0;
    
    while(choice != -1){

        printMainMenu();
    
        choice = selectChoice();

        PGresult* res;
    
        switch(choice){

            case 1:{ //Festival che ha ricevuto più sponsorizzazioni
                res = doQuery(conn,"SELECT festival, totale FROM sponsorizzazioni_totali_festival WHERE totale >= (SELECT MAX(totale) FROM sponsorizzazioni_totali_festival);");
                printTable(res);
                PQclear(res);

                break;
            }
            case 2:{ //Artisti headliner del festival con più partecipazione media in base alle giornate
                res = doQuery(conn,"SELECT artista.nome FROM artista,giornata,concerto WHERE concerto.giornata = giornata.data_effettiva AND artista.nome = concerto.artista AND artista.headliner = true AND giornata.festival = ( SELECT festival FROM media_biglietti_festival WHERE media_biglietti_giornata >= (SELECT MAX (media_biglietti_giornata) FROM media_biglietti_festival);");
                printTable(res);
                PQclear(res);

                break;
            }

            case 3:{ //Prezzo medio pagato dai clienti paganti per edizione di un certo festival
                cout<<"Seleziona un edizione del festival"<<"\n";

                PGresult* fres = doQuery(conn,"SELECT nome FROM festival ORDER BY data_inizio");
                const int nrows = PQntuples(fres);
                for(int r=0;r<nrows;r++){
                    cout<<(r+1)<<" - "<<PQgetvalue(fres,r,0)<<"\n";
                }

                int festivalChoice = 0;

                while(festivalChoice==0){
                    cin >> festivalChoice;
                    if(festivalChoice < 1 || festivalChoice>nrows)
                        festivalChoice = 0;
                }

                string festival = PQgetvalue(fres,festivalChoice-1,0);

                res = doQuery(conn,"SELECT AVG(prezzo) FROM biglietto, acquisto_biglietto, acquisto WHERE biglietto.id = acquisto_biglietto.biglietto AND acquisto_biglietto.acquisto = acquisto.id AND biglietto.festival = '"+festival+"'");
                printTable(res);
                PQclear(res);

                break;
            }

            case 4:{ //Artisti non headliner che hanno soggiornato nel camerino VIP più grande e più frequentato
                res = doQuery(conn,"SELECT artista.nome FROM occupazione, camerino, artista WHERE occupazione.camerino = camerino.id AND occupazione.artista = artista.nome AND artista.headliner = false AND camerino.grandezza =  ( SELECT MAX(grandezza) FROM camerino, camerino_servizio, servizio WHERE camerino.id = camerino_servizio.camerino AND servizio.nome = camerino_servizio.servizio AND servizio.solo_vip = true GROUP BY camerino.id LIMIT 1) GROUP BY artista.nome, occupazione.camerino; ");
                printTable(res);
                PQclear(res);

                break;
            }

            case 5: {//Numero di concerti effettuati per le combinazioni di tipologia di impianto audio e luci
                res = doQuery(conn,"SELECT palcoscenico.impianto_audio, palcoscenico.impianto_luci, COUNT(*) AS numero_concerti FROM concerto, palcoscenico WHERE concerto.palcoscenico = palcoscenico.nome AND CONCAT(palcoscenico.impianto_audio, palcoscenico.impianto_luci) IN (SELECT CONCAT(P1.impianto_audio,P1.impianto_luci) FROM palcoscenico P1, palcoscenico P2	WHERE P1.impianto_audio != P2.impianto_audio AND P1.impianto_luci != P2.impianto_luci) GROUP BY CONCAT(palcoscenico.impianto_audio, palcoscenico.impianto_luci), palcoscenico.impianto_audio, palcoscenico.impianto_luci;");
                printTable(res);
                PQclear(res);

                break;
            }
            default:
                if(choice != -1)
                    cout<<"Scelta non valida"<<"\n";
            
        }

    }

    PQfinish(conn);

    return 1;

}
