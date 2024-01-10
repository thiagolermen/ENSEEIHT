-- Time-stamp: <19 oct 2012 15:00 queinnec@enseeiht.fr>

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Version avec machine à etats. Pas de priorité définie.
package body LR.Synchro.Basique is
   
   function Nom_Strategie return String is
   begin
      return "Basique, par machine à états";
   end Nom_Strategie;
   
   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is
      type state_enum is (READING, WRITING, FREE);
      state : state_enum := FREE;
      reader : Integer := 0; 
   begin
      loop
         if state = READING then
            select
               accept Demander_Lecture;
               reader := reader + 1;
            or 
               accept Terminer_Lecture;
               reader := reader - 1;
            end select;

            if reader = 0 then
               state := FREE;
            end if;
         elsif state = FREE then
            select
               accept Demander_Lecture;
               state := READING;
               reader := reader + 1;
            or 
               accept Demander_Ecriture;
               state := WRITING;
            or
               terminate;
            end select;
         elsif state = WRITING then 
            accept Terminer_Ecriture;
            state := FREE;
         end if;
      end loop;
   exception
      when Error: others =>
         Put_Line("**** LectRedTask: exception: " & Ada.Exceptions.Exception_Information(Error));
   end LectRedTask;

   procedure Demander_Lecture is
   begin
      LectRedTask.Demander_Lecture;
   end Demander_Lecture;

   procedure Demander_Ecriture is
   begin
      LectRedTask.Demander_Ecriture;
   end Demander_Ecriture;

   procedure Terminer_Lecture is
   begin
      LectRedTask.Terminer_Lecture;
   end Terminer_Lecture;

   procedure Terminer_Ecriture is
   begin
      LectRedTask.Terminer_Ecriture;
   end Terminer_Ecriture;

end LR.Synchro.Basique;
