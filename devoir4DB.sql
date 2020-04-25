--GROUPE : Hasna Edmagh et Chaima Chati 

-----Q1
create or replace trigger trigg1 
before insert or update or delete on Pilote
declare NH number;
begin
SELECT EXTRACT(HOUR FROM SYSTIMESTAMP)/12/30/24 AS CURRENT_HOUR into NH FROM DUAL;
if INSERTING then
if NH>18 AND NH<8 then
RAISE_APPLICATION_ERROR(-20501,'Insertion impossible à cette heure..');end if;
END IF;
if UPDATING then
if NH>18 AND NH<8 then
RAISE_APPLICATION_ERROR(-20502,'Mise à jour impossible à cette heure.');end if;
END IF;
if DELETING then
if NH>18 AND NH<8 then
RAISE_APPLICATION_ERROR(-20503,'Suppression impossible à cette heure.');end if;
END IF;

END;
/

----Q2


CREATE OR REPLACE TRIGGER TRG_pil
AFTER  DELETE OR INSERT OR UPDATE  -- after de l'insertion
ON PILOTE   -- sur la table pilote
FOR EACH ROW      -- pour chaque ligne
Begin
Insert into Audit_Pilote_Table ( username, timestamp,
id, old_last_name, new_last_name, old_comm, new_comm, old_salary, new_salary) -- on valorise la colonne JOB
VALUES (USER,SYSDATE,:NEW."NOPILOT", :OLD."NOM", :NEW."NOM", :OLD."COMM",:NEW."COMM", :OLD."SAL",:NEW."SAL") ;
End ;
/

-----Q3
 CREATE TRIGGER commTr
AFTER  DELETE OR INSERT OR UPDATE  -- after de l'insertion
ON PILOTE 
FOR EACH ROW 
BEGIN
 UPDATE PILOTE SET COMM = (sal*(10/100)) WHERE COMM = :NEW.COMM ;
END ;
/




----Q4

create or replace trigger trigg4 before  update of SAL on Pilote
FOR EACH ROW
begin
if :new.SAL= :old.SAL+ :old.SAL*0.1 OR :new.SAL= :old.SAL- :old.SAL*0.1 then
ROLLBACK;
END IF;
END;
/


----Q5
create or replace trigger Ajout-pilote before  insert on Pilote
begin
EXECUTE IMMEDIATE 'revoke INSERT on pilote from user';
dbms_output.put_line('utlisateur non autorise');
END;
/


----Q6
create or replace trigger verif_nhvol after  insert or update on Avion
declare N NUMBER;
begin
 select avg(NBHVOL)into N from Avion ;
 if N>2000000 THEN
dbms_output.put_line('NB heures trop eleve');
end if;
END;
/


----Q7

CREATE OR REPLACE TRIGGER ligne
AFTER update ON Pilote
for each row
declare nbmodif INT;
BEGIN
nbmodif := nbmodif+COUNT(ROW);
dbms_output.put_line('nbmodifier: ' || nbmodif); 
END;
/




----Q8
ALTER TRIGGER verif_nhvol DISABLE;
ALTER TABLE nom_table DISABLE ALL TRIGGERS;