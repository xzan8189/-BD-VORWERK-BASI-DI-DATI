
/*operazione 13*/
SELECT DISTINCT Nome, Cognome, Email 
FROM PARTECIPANTE AS P 
WHERE P.CF NOT IN (	SELECT CF 
					FROM partecipa AS pa 
                    WHERE pa.Acquisto=1);

/*operazione 14*/
SELECT Nome, Cognome 
FROM DIPENDENTE AS D 
WHERE D.Tipo='RAPPRESENTANTE' AND D.CF NOT IN(	SELECT CF_D 
												FROM VENDITA AS V 
												WHERE DATEDIFF(CURDATE(),V.Data_richiesta)<=90);
                                                    
/*OPERAZIONE 15*/
SELECT C.Nome, C.Cognome, C.Via, C.Civico, C.CAP, s.Premio_nome
FROM CLIENTE AS C, ACCOUNTt AS A, sceglie AS s 
WHERE C.CF=A.CF AND A.Username=s.Username;

/*operazione 16*/
DELETE FROM RICETTA 
WHERE (Nome, Autore) IN(	SELECT DISTINCT G.Nome, G.Autore 
							FROM GOURMET AS G, possiede AS p 
                            WHERE G.Nome=p.Ricetta_nome AND G.Autore=p.Ricetta_autore 
                            GROUP BY G.Nome, G.Autore 
                            HAVING AVG(p.Voto)<3 AND COUNT(p.Voto)>=10);
          
/*OPERAZIONE 17*/
SELECT DISTINCT B.Nome, B.Autore 
FROM BASE AS B, possiede AS p 
WHERE B.Nome=p.Ricetta_nome AND B.Autore=p.Ricetta_autore 
GROUP BY B.Nome, B.Autore 
HAVING AVG(p.Voto)>4 AND COUNT(p.Voto)>=10;
			
/*OPERAZIONE 18*/
SELECT DISTINCT Nome, Cognome, COUNT(D.CF) 
FROM DIPENDENTE AS D, VENDITA AS V 
WHERE D.CF=V.CF_D AND D.Tipo='RAPPRESENTANTE' GROUP BY CF_D;

/*OPERAZIONE 19*/
SELECT Nome, Cognome, Via, Civico, CAP 
FROM CLIENTE AS C, VENDITA AS V 
WHERE V.CF_C=C.CF AND DATEDIFF(CURDATE(),V.Data_richiesta)<=5;

/*operazione 20*/
SELECT P.Nome, P.Cognome
FROM PARTECIPANTE AS P, CLIENTE AS C, VENDITA AS V, ROBOT_1 AS R 
WHERE P.CF=C.CF AND V.CF_C=C.CF AND V.Seriale=R.Seriale AND R.Modello LIKE ?;

/*operazione 21*/
SELECT DISTINCT C.Nome, C.Cognome, C.CF 
FROM CLIENTE AS C, vendita AS v 
WHERE C.CF=v.CF_C AND v.IBAN IS NOT NULL 
GROUP BY C.Nome, C.Cognome, C.CF HAVING COUNT(*)>=2;

/*operazione 22*/
SELECT C.Via, C.Civico, C.CAP 
FROM CLIENTE AS C, SPEDIZIONE_1 AS S, ROBOT_1 AS R, VENDITA AS V 
WHERE C.CF=V.CF_C AND V.Seriale=R.Seriale AND R.`#spedizione`=S.`#spedizione` AND S.`#spedizione` = ?;

/*operazione 23*/
SELECT A.Punti
FROM ACCOUNTT AS A 
WHERE ACCOUNTT.Username LIKE ?; 

/*SCHCRL97R66B453B*/
/*operazione 24*/
SELECT DISTINCT DI.Nome, DI.Cognome
FROM DIPENDENTE AS DI 
WHERE DI.CF IN (	SELECT DISTINCT DI.CF 
					FROM DIPENDENTE AS DI, DIMOSTRAZIONE AS D, partecipa AS p 
					WHERE DI.CF=D.CF AND D.Username=p.Username AND D.`Data`=p.`Data` AND D.CF=p.CF_D
					GROUP BY DI.CF, D.Username, D.`Data` 
					HAVING COUNT(DISTINCT Acquisto)=1) 
AND DI.CF IN (	SELECT DISTINCT D.CF 
				FROM DIMOSTRAZIONE AS D, partecipa AS p 
                WHERE D.Username=p.Username AND D.`Data`=p.`Data` AND D.CF=p.CF_D AND p.Acquisto='1');

/*OPERAZIONE 25*/
SELECT D.Nome, D.Cognome 
FROM DIPENDENTE AS D, SPEDIZIONE_1 AS S 
WHERE D.CF=S.CF AND DATEDIFF(CURDATE(), S.`Data`)<=60;