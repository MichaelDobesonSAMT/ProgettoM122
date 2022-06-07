# Progetto Matrix - Backup

  Il mio progetto consiste di 2 sotto progetti: **Backup di File** ed **Effetto Matrix**.

## Backup di File (Backup.ps1)
Questo progetto serve, come dal nome, a fare un backup dei file. Lo script ha **3 parametri**, però si deve avviare con **almeno 2 parametri**:
-  **-path**: andrà ad indicare la cartella da analizzare per fare il backup dei file/directory;
-  **-dest**: andrà ad indicare la cartella per mettere il backup;
-  **-whatif**: funziona come tutti gli altri -whatif, in cui esegue lo script senza fare le modifiche a file o cartelle, apparte nel log file che mostra tutti passagi se;
    
Il modo che lo script funzionerà e che entrerà in ogni sottocartella e **copierà ogni file** e lo incollerà facendo un **controllo**: se il file copiato ha già avuto un backup precedentemente e quindi non ci sono stati cambiamenti, allora non farà un sovrascrittura. Altrimenti i file vengono sempre incollati e anche sovrascritti. Se per caso un file però viene cancellato, allora il programma lo cancellerà dal backup. Tutto questo verrà registrato in un file di log che si presenterà dentro il percorso del secondo parametro (-dest).

Quando lo script è finito si dovrebbe avere **una copia esatta con la stessa gerarchia di cartelle e file ed in più il file di log.**

## Effetto Matrix (Matrix.ps1)

Questo progetto non ha necessariamente molto utilizzo, però in pratica, mentre lo script di Backup è in avvio questo script si avvierà e apre **un’altra scheda di Powershell** che copre tutto lo schermo (ovviamente si può chiudere o mettere da parte se non si vuole) cambiando lo sfondo a nero e i caratteri a verde chiaro.

Sulla nuova scheda di Powershell verrà riprodotto l’effetto notevole dal film Matrix, in cui casualmente un numero di colonne casuali di caratteri randomici scenderanno fino in fondo allo schermo. 

## Progetto (Progetto.ps1)
Per avviare tutto il progetto in modo corretto, devi avviare lo script **Progetto.ps1** con gli stessi parametri detti precedentemente in Backup di File.
Lo script **gestisce correttamente eventuali errori**, che verranno anche loro registrati in maniera ordinata nel file di log.

## Sintassi

```powershell
.\Progetto.ps1 -path <string> -dest <string> [-whatif]
```
created by Michael Yorke Dobeson
