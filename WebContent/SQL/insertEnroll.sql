CREATE OR REPLACE PROCEDURE InsertEnroll(studentID IN VARCHAR2, courseID IN VARCHAR2,
               courseIDNO IN NUMBER, result OUT VARCHAR2 )
IS
   CURSOR courseLIST(student_id VARCHAR2) IS
   SELECT NVL(c_id, 0) c_id
   FROM enroll
   WHERE s_id = student_id;

   credit_limit_over EXCEPTION;
   duplicate_course EXCEPTION;
   too_many_students EXCEPTION;
   duplicate_period EXCEPTION;
   courseSUM NUMBER;
   courseCREDIT NUMBER;
   courseCOUNT NUMBER;
   periodCOUNT1 NUMBER;
   periodCOUNT2 NUMBER;
   courseMAX NUMBER;
   courseCURRENT NUMBER;

BEGIN
<<<<<<< HEAD
   result := ' ';
   
   DBMS_OUTPUT.put_line(studentID || '님이 과목번호 ' || courseID ||
   ', 분반 ' || courseIDNO || '의 수강 등록을 요청하였습니다.');

   /*최대학점 초과*/
   SELECT SUM(c.c_credit)
   INTO courseSUM
   FROM course c, enroll e
   WHERE e.s_id = studentID AND e.c_id = c.c_id and e.c_number = c.c_number;
   
   IF courseSUM IS NULL THEN
      courseSUM := 0;
   END IF;   

   SELECT c_credit
   INTO courseCREDIT
   FROM course
   WHERE c_id = courseID AND c_number = courseIDNO;
   
   DBMS_OUTPUT.put_line(courseSUM || ' / ' || courseCREDIT);
   
   IF (courseSUM + courseCREDIT) >18 THEN
      RAISE credit_limit_over;
   END IF;

   /*중복된 과목*/
   FOR course_list IN courseLIST(studentID) LOOP
      IF course_list.c_id = courseID THEN
         RAISE duplicate_course;
      END IF;
   END LOOP;

   /*수강신청 인원 초과*/
   SELECT c_max, c_current
   INTO courseMAX, courseCURRENT
   FROM course
   WHERE c_id = courseID AND c_number = courseIDNO;

   DBMS_OUTPUT.put_line(courseMAX || ' / ' || courseCURRENT);

   IF (courseCURRENT+1) > courseMAX THEN
      RAISE too_many_students;
   END IF;
   
   /*중복된 시간*/
   SELECT COUNT(*)
   INTO periodCOUNT1
   FROM course c
   WHERE c.c_id = courseID AND c.c_period IN (SELECT c.c_period
         FROM enroll e, course c 
         WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
                     AND (e.c_id, e.c_number) IN (
                     SELECT enrolled_c.c_id, enrolled_c.c_number
                     FROM course new_c INNER JOIN course enrolled_c
                     ON new_c.c_day1 = enrolled_c.c_day1
                     WHERE new_c.c_id = courseID));

   SELECT COUNT(*)
   INTO periodCOUNT2
   FROM course c
   WHERE c.c_id = courseID AND c.c_period IN (SELECT c.c_period
         FROM enroll e, course c 
         WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
                     AND (e.c_id, e.c_number) IN (
                     SELECT enrolled_c.c_id, enrolled_c.c_number
                     FROM course new_c INNER JOIN course enrolled_c
                     ON new_c.c_day2 = enrolled_c.c_day2
                     WHERE new_c.c_id = courseID));

   DBMS_OUTPUT.put_line(periodCOUNT1 || ' / ' || periodCOUNT2);

   IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
      RAISE duplicate_period;
   END IF;

   INSERT INTO enroll(s_id, c_id, c_number)
   VALUES (studentID, courseID, courseIDNO);
   
   UPDATE course
   SET c_current = courseCURRENT + 1
   WHERE c_id = courseID AND c_number = courseIDNO;

   UPDATE student
   SET s_credit = (courseSUM + courseCREDIT)
   WHERE s_id = studentID;

   result := '수강신청이 완료되었습니다.';
   DBMS_OUTPUT.put_line(result);

   COMMIT;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('no data found');
   WHEN credit_limit_over THEN
      result := '최대학점을 초과하였습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course THEN
      result :='이미 수강신청한 과목입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN too_many_students THEN
      result :='최대 수강신청 인원을 초과하여 등록할 수 없습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_period THEN
      result :='같은 시간에 수강신청한 과목이 있습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN OTHERS THEN
      ROLLBACK;
      result := SQLCODE;
      DBMS_OUTPUT.put_line(result);
=======
	result := ' ';
	
	DBMS_OUTPUT.put_line(studentID || '�떂�씠 怨쇰ぉ踰덊샇 ' || courseID ||
	', 遺꾨컲 ' || courseIDNO || '�쓽 �닔媛� �벑濡앹쓣 �슂泥��븯����뒿�땲�떎.');

	/*理쒕���븰�젏 珥덇낵*/
	SELECT SUM(c.c_credit)
	INTO courseSUM
	FROM course c, enroll e
	WHERE e.s_id = studentID AND e.c_id = c.c_id and e.c_number = c.c_number;
	
	IF courseSUM IS NULL THEN
		courseSUM := 0;
	END IF;	

	SELECT c_credit
	INTO courseCREDIT
	FROM course
	WHERE c_id = courseID AND c_number = courseIDNO;
	
	DBMS_OUTPUT.put_line(courseSUM || ' / ' || courseCREDIT);
	
	IF (courseSUM + courseCREDIT) >18 THEN
		RAISE credit_limit_over;
	END IF;

	/*以묐났�맂 怨쇰ぉ*/
	FOR course_list IN courseLIST(studentID) LOOP
		IF course_list.c_id = courseID THEN
			RAISE duplicate_course;
		END IF;
	END LOOP;

	/*�닔媛뺤떊泥� �씤�썝 珥덇낵*/
	SELECT c_max, c_current
	INTO courseMAX, courseCURRENT
	FROM course
	WHERE c_id = courseID AND c_number = courseIDNO;

	DBMS_OUTPUT.put_line(courseMAX || ' / ' || courseCURRENT);

	IF (courseCURRENT+1) > courseMAX THEN
		RAISE too_many_students;
	END IF;
	
	/*以묐났�맂 �떆媛�*/
	SELECT COUNT(*)
	INTO periodCOUNT1
	FROM course c
	WHERE c.c_id = courseID AND c.c_period IN (SELECT c.c_period
			FROM enroll e, course c 
			WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
							AND (e.c_id, e.c_number) IN (
							SELECT enrolled_c.c_id, enrolled_c.c_number
							FROM course new_c INNER JOIN course enrolled_c
							ON new_c.c_day1 = enrolled_c.c_day1
							WHERE new_c.c_id = courseID));

	SELECT COUNT(*)
	INTO periodCOUNT2
	FROM course c
	WHERE c.c_id = courseID AND c.c_period IN (SELECT c.c_period
			FROM enroll e, course c 
			WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
							AND (e.c_id, e.c_number) IN (
							SELECT enrolled_c.c_id, enrolled_c.c_number
							FROM course new_c INNER JOIN course enrolled_c
							ON new_c.c_day2 = enrolled_c.c_day2
							WHERE new_c.c_id = courseID));

	DBMS_OUTPUT.put_line(periodCOUNT1 || ' / ' || periodCOUNT2);

	IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
		RAISE duplicate_period;
	END IF;

	INSERT INTO enroll(s_id, c_id, c_number)
	VALUES (studentID, courseID, courseIDNO);
	
	UPDATE course
	SET c_current = courseCURRENT + 1
	WHERE c_id = courseID AND c_number = courseIDNO;

	UPDATE student
	SET s_credit = (courseSUM + courseCREDIT)
	WHERE s_id = studentID;

	result := '�닔媛뺤떊泥��씠 �셿猷뚮릺�뿀�뒿�땲�떎.';
	DBMS_OUTPUT.put_line(result);

	COMMIT;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.put_line('no data found');
	WHEN credit_limit_over THEN
		result := '理쒕���븰�젏�쓣 珥덇낵�븯����뒿�땲�떎.';
		DBMS_OUTPUT.put_line(result);
	WHEN duplicate_course THEN
		result :='�씠誘� �닔媛뺤떊泥��븳 怨쇰ぉ�엯�땲�떎.';
		DBMS_OUTPUT.put_line(result);
	WHEN too_many_students THEN
		result :='理쒕�� �닔媛뺤떊泥� �씤�썝�쓣 珥덇낵�븯�뿬 �벑濡앺븷 �닔 �뾾�뒿�땲�떎.';
		DBMS_OUTPUT.put_line(result);
	WHEN duplicate_period THEN
		result :='媛숈�� �떆媛꾩뿉 �닔媛뺤떊泥��븳 怨쇰ぉ�씠 �엳�뒿�땲�떎.';
		DBMS_OUTPUT.put_line(result);
	WHEN OTHERS THEN
		ROLLBACK;
		result := SQLCODE;
		DBMS_OUTPUT.put_line(result);
>>>>>>> d09a88ceb95bd0965745ffe6af820eecf754c402
END;
/