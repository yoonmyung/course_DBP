CREATE OR REPLACE TRIGGER pwd_trigger
BEFORE
UPDATE on STUDENT
FOR EACH ROW

DECLARE
 underflow_five EXCEPTION;
 invalid_value EXCEPTION;
 nLength NUMBER := 0;
 nBlank NUMBER := 0;

BEGIN
 nLength := length(:new.s_pwd);
 nBlank := instr(:new.s_pwd, ' ', 1, 1);

 IF (nLength < 4) THEN
  RAISE underflow_five;
 END IF;

 IF (nBlank > 0) THEN
  RAISE invalid_value;
 END IF;

EXCEPTION 
 WHEN underflow_five THEN
  RAISE_APPLICATION_ERROR(-20002, '비밀번호는 4자리 이상 입력하세요.');
 WHEN invalid_value THEN
  RAISE_APPLICATION_ERROR(-20003, '비밀번호에 공란은 입력되지 않습니다.'); 

END;
/