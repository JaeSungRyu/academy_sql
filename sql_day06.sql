-------------------------------------------------------------
-- PL/SQL 계속
-------------------------------------------------------------
---------------IN, OUT 모드 변수를 사용하는 프로시저
SHOW SERVEROUTPUT;
SET SERVEROUTPUT ON;


-- 문제) 한달 급여를 입력(IN 모드 변수) 하면
--      일년 급여(OUT 모드 변수)를 계산해주는 프로시저를 작성

--  1) SP 이름 : sp_calc_year_sal
--  2) 변수    : IN => v_sal
--              OUT => v_sal_year
--  3) PROCEDURE 작성
CREATE OR REPLACE PROCEDURE sp_calc_year_sal
(  v_sal       IN  NUMBER
 , v_sal_year  OUT NUMBER)
IS
BEGIN
    v_sal_year := v_sal * 12;
END  sp_calc_year_sal;
/

-- 4) 컴파일 : SQL*PLUS CLi 라면 위 코드를 복사 붙여넣기
--            Oracle SQL Developer : ctrl + Enter 키 입력
-- Procedure SP-CALC_YEAR_SAL이(가) 컴파일되었습니다.
--           오류가 존재하면 SHOW errors 명령으로 확인
-- 5) OUT 모드 변수가 있는 프로시저이므로 BIND 변수가 필요
--   VAR 명령으로 SQL*PLUS 의 변수를 선언하는 명령
--   DESC 명령 : SQL*PLUS 

VAR v_sal_year_bind NUMBER
;

-- 6)프로시저 실행 : EXEC[UTE] : SQL*PLUS 명령
EXEC sp_calc_year_sal(1200000, :V_SAL_YEAR_BIND)

-- 7) 실행 결과가 담긴 BIND 변수를 SQL*PLUS 에서 출력
PRINT v_sal_year_bind
/*
V_SAL_YEAR_BIND
---------------
       14400000
*/

--실습 6) 여러 형태의 변수를 사용하는 sp_variables 를 작성
/*
    IN 모드 변수 : v_deptno, v_loc
    지역변수     : v_hiredate, v_empno, v_msg
    상수        : v_max
*/

-- 1) 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_variables
   (  v_deptno  IN  NUMBER
    , v_loc     IN  VARCHAR2)
IS
    -- IS ~ BEGIN 사이는 지역변수 선언/초기화
    v_hiredate      DATE;
    v_empno         NUMBER := 1999;
    v_msg           VARCHAR2(500) DEFAULT 'Hello, PL/SQL';
  -- CONSTANT는 상수를 만드는 설정  
    v_max CONSTANT  NUMBER := 5000;
BEGIN
    -- 위에서 정의된 값들을 출력
    Dbms_Output.Put_Line('v_hiredate:'||v_hiredate);
    v_hiredate := sysdate;
    Dbms_OutPUT.Put_Line('v_hiredate:'||v_hiredate);
    Dbms_OutPUT.Put_Line('v_deptno:'||v_deptno);
    Dbms_OutPUT.Put_Line('v_loc:'||v_loc);
    Dbms_OutPUT.Put_Line('v_empno:'||v_empno);
    
    v_msg := '내일 지구가 멸망하더라도 오늘 사과나무를 심겠다. by.스피노자';
    DBMS_OUTPUT.PUT_LINE('v_msg:'||v_msg);
    
    -- 상수인 v_max 에 할당시도
    -- v_max :=10000;
    
END  sp_variables;
/

-- 2) 컴파일 / 디버깅

-- 3) VAR : BIND 변수가 필요하면 선언

-- 4) EXEC
SET SERVEROUTPUT ON
EXEC SP_VARIABLES('10', '하와이')
EXEC SP_VARIABLES('20', '스페인')
EXEC SP_VARIABLES('30', '제주도')
EXEC SP_VARIABLES('40', '몰디브')

-- 5) PRINT : BIND 변수에 값이 저장되었으면 출력
EXEC SP_VARIABLES(10);
SHOW ERRORS;

--------------------------------------------
--PL/SQL변수 : REFERENCE 변수의 사용
---1.%TYPE
--DEPT 테이블의 부서번호를 입력(IN모드)받아서  
--부서명을(OUT모드) 출력하는 저장 프로시저 작성

----(1)SP 이름 :sp_get_dname
----(2)IN 변수 :v_deptno
----(3)OUT 변수 :d_name

--1.프로시저 작성
CREATE OR REPLACE PROCEDURE sp_get_dname
(v_deptno IN DEPT.DEPTNO%TYPE
,v_dname OUT dept.DNAME%TYPE)
IS
BEGIN
 SELECT d.DNAME
   INTO v_dname
   FROM dept d
  WHERE d.deptno = v_deptno;
END sp_get_dname;
/
show errors;





--(2)컴파일 디버깅


--3.VAR : BIND변수가 필요하면 선언
VAR dname_bind VARCHAR(30);

--4.EXEC : 프로시저 실행
EXEC sp_get_dname(10,:v_dname_bind)

--5.PRINT : BIND 변수가 있으면 출력
PRINT v_





--2)rowtype 변수
/*특정 체이블의 한 행을 컬럼의 순서대로
  타입,크기를 그대로 맵핑한 변수*/
--  dept테이블의 부서번호를 입력(IN모드) 받아서
--  부서 전체 정보를 화면 출력하는 저장 프로시저 작성
--sp_get_dinfo
--IN모드 변수 : d_deptno
CREATE OR REPLACE PROCEDURE sp_get_dinfo
(v_deptno IN DEPT.DEPTNO%TYPE)
IS
--v.dinfo 변수는 dept테이블의 항 행의 정보를 한번에 담는 변수
v_dinfo dept%ROWTYPE;
BEGIN
      --IN모드로 입력된 v_deptno에 해당하는 부서정보
      --1행을 조회하여
      --deptno테이블의 rowtype 변수인 v_dinfo에 저장
 SELECT d.DEPTNO
       ,d.dname
       ,d.LOC
   INTO v_dinfo  --INTO절에는 명시되는 변수는 1행만 저장 가능
   FROM dept d
  WHERE d.deptno = v_deptno; --deptno는 pk기 때문에 한행만 조회 
  DBMS_OUTPUT.PUT_LINE('부서번호:'||v_dinfo.deptno);
  DBMS_OUTPUT.PUT_LINE('부서이름:'||v_dinfo.dname);
  DBMS_OUTPUT.PUT_LINE('부서위치:'||v_dinfo.loc);
  
END sp_get_dinfo;
/

exec sp_get_dinfo(10);
exec sp_get_dinfo(20);
exec sp_get_dinfo(30);


----------------------------------------------
--수업 중 실습
--문제) 한 사람의 사번을 입력받으면 그 사람의 소속 부서명, 부서 위치를 
--     함께 화면 출력

--1.프로시저 작성
CREATE OR REPLACE PROCEDURE sp_get_emp_info
(v_empno  IN EMP.EMPNO%TYPE)
IS
 --emp 테이블의 한 행을 받을 rowtype
        v_emp emp%ROWTYPE;
 --dept 테이블의 한 행을 받을 rowtype
        v_dept dept%ROWTYPE;
BEGIN
--sp의 좋은 점은 여러개의 쿼리를 
--순차적으로 실행하는 것이 가능
--변수를 활용할 수 있기 때문에

--1.IN모드 변수로 들어오는 한 직원의 정보를 조회
   SELECT e.*
     INTO v_emp
     FROM emp e
    WHERE e.empno = v_empno
;
--2. 1의 결과에서 직원의 부서 번호를 얻을 수 있으므로
--   부서정보 조회
   SELECT d.*
     INTO v_dept
     FROM dept d
    WHERE d.deptno = v_emp.deptno
    ;
    
    --3.v_emp,v_dept에서 필요한 필드만 화면 출력
    dbms_output.put_line('직원이름:'||v_emp.ename);
    dbms_output.put_line('소속부서:'||v_dept.dname);
    dbms_output.put_line('부서위치:'||v_dept.loc);
END sp_get_emp_info;
/
SHOW ERRORS;
--4.실행
EXEC sp_get_emp_info(7654);
show errors;
   --(1)sp이름 : sp_get_emp_info
   --(2)IN변수 : v_empno
   --(3)%TYPE,%ROWTYPE 변수 활용


-------------------------------
--PL/SQL 변수 : RECORD TYPE 변수의 사용
-------------------------------
--RECORD TYPE : 한개 혹은 그 이상 테이블에서
--              원하는 컬럼만 추출하여 구성


--문제)사번을 입력(IN모드변수)받아서
--    그 직원의 매니저 이름,부서이름,부서위치,급여등급 함께 출력
----(1)SP이름 : sp_get_emp_info_detail
----(2)IN변수 : v_empno
----(3)RECORD변수 : v_emp_record


--1.프로시저 작성
CREATE OR REPLACE PROCEDURE sp_get_emp_info_detail
(v_empno IN emp.empno%TYPE)
IS
 --1.RECORD 타입 선언
 TYPE emp_record_type IS RECORD
 (r_empno       EMP.EMPNO%TYPE
 ,r_ename       EMP.ENAME%TYPE
 ,r_mgrname     EMP.ENAME%TYPE
 ,r_dname       DEPT.DNAME%TYPE
 ,r_loc         DEPT.LOC%TYPE
 ,r_salgrade    SALGRADE.GRADE%TYPE
 );
 
 --2.1에서 선언한 타입의 변수를 선언
 v_emp_record  emp_record_type;
BEGIN

--3. 1에서 선언한 RECORD타입은 조인의 결과를 받을 수 있음
SELECT e.EMPNO
      ,e.ENAME
      ,e1.ENAME
      ,d.DNAME
      ,d.LOC
      ,s.GRADE
  INTO v_emp_record
  FROM emp e,emp e1
      ,dept d
      ,salgrade s
 WHERE e.mgr = e1.empno(+)  --mgr 베정 안된 직원
   AND e.deptno = d.deptno(+)  --dept 배정 안된 직원
   AND e.SAL BETWEEN s.LOSAL AND s.HISAL
   AND e.EMPNO = v_empno
  ;
    DBMS_OUTPUT.PUT_LINE('사      번:'||v_emp_record.r_empno);
    DBMS_OUTPUT.PUT_LINE('이      름:'||v_emp_record.r_ename);
    DBMS_OUTPUT.PUT_LINE('매  니  저:'||v_emp_record.r_mgrname);
    DBMS_OUTPUT.PUT_LINE('부  서  명:'||v_emp_record.r_dname);
    DBMS_OUTPUT.PUT_LINE('부 서 위 치:'||v_emp_record.r_loc);
    DBMS_OUTPUT.PUT_LINE('급 여 등 급:'||v_emp_record.r_salgrade);

END;
/

show errors;

exec sp_get_emp_info_detail(7654);
exec sp_get_emp_info_detail(7839);
exec sp_get_emp_info_detail(6666);



---------------------------------
--프로시저는 다른 프로시저에서 호출가능

--ANONYMOUS PROCEDURE룰 사용하여 지금 정의한
--sp_get_emp_info_detail 실행

DECLARE
    v_empno      EMP.EMPNO%TYPE;

BEGIN
        SELECT e.empno
          INTO v_empno
          FROM emp e
         WHERE e.empno = 7902;

   sp_get_emp_info_detail(v_empno);
END;
/





-----------------------------------------
--PL/SQL 변수 : 아규먼트 변수 IN OUT모드의 사용
-----------------------------------------
 --IN : SP로 값이 전달될 때 사용,입력용
 --     프로시저를 사용하는 쪽(SQL*PLUS)에서 프로시저로 전달
-----------------------------------------
--OUT : SP에서 수행결과 값이 저장되는 용도, 출력용
--      프로시저는 리턴이 없기 때문에
--      SP를 호풀한 쪽에 돌려주는 방법으로 사용
------------------------------------------
--IN OUT : 하나의 매개 변수에 입력,출력을 함께 사용
------------------------------------------
--문제)기본 숫자값을 입력받아 숫자 포맷화 $'9,999.00'
--    출력하는 프로시저를 작성 IN OUT모드를 활용


--(1) sp 이름: sp_chng_number_format
--(2) IN OUT 변수: v_nember
--(3) BIND 변수

--1.프로시저 작성
CREATE OR REPLACE PROCEDURE sp_chng_number_format
(v_number IN OUT VARCHAR2)
IS
BEGIN
--1.입력된 초기 상태의값 출력
DBMS_OUTPUT.PUT_LINE('초기 입력 값:'||v_number);
--2.숫자 패턴화 변경
v_number :=TO_CHAR(TO_NUMBER(v_number),'$9,999.99');
--3.화면 출력으로 변경 된 패턴 확인
DBMS_OUTPUT.PUT_LINE('패턴 적용 값:'||v_number);

END sp_chng_number_format;
/

show errors;
--2.컴파일/디버깅

--3.VAR : BIND 변수 선언
VAR v_number_bind VARCHAR2(30);
--4.EXEC : 실행,,
--4.bind변수에 1000을 저장
exec :v_number_bind := 1000;
exec sp_chng_number_format(:v_number_bind)
--5.PRINT : BIND 변수 출력
PRINT v_number_bind;


--위의 문제를 다른 방법으로 풀이 : SELECT ~ INTO절을 사용
--SELECT INTO절을 사용
--1.프로시저 작성
CREATE OR REPLACE PROCEDURE sp_chng_number_format1
(in_number IN  NUMBER
,out_number OUT VARCHAR2)
IS
BEGIN
--IN_NUMBER로 입력된 값을
--OUT_NUMBER 변수로
SELECT TO_CHAR(in_number,'$9,999.99')
  INTO out_number
  FROM dual
  ;
END sp_chng_number_format1;
/

show errors;
VAR v_out_number_bind VARCHAR2(1000);

--4.EXEC : 실행
exec sp_chng_number_format1(1000);

--4.bind변수에 1000을 저장
exec :v_number_bind := 1000;
exec sp_chng_number_format(:v_number_bind:v_out_number_bind);
--5.PRINT : BIND 변수 출력
PRINT v_number_bind;


----------------------------------------
--매개변수 전달법
---1.위치에 의한 전달 법
exec sp_chng_number_format1(1000,:v_out_number_bind);
---2.변수명에 의한 전달
exec sp_chng_number_format1(in_number=>2000,out_number=>:v_out_number_bind);
exec sp_chng_number_format1(out_number=>:v_out_number_bind,in_number=>3000);

print v_out_number_bind;


----------------------------------------------------
--PL/SQL제어문
----------------------------------------------------
--1.IF 제어문
-- IF ~THEN ~[ELSIF ~ THEN] ~ ELSE ~END IF;

--JOB별로 경조사비를 급여대비 일정 비율로 지급하고 있다.
--각 직원들의 경조사비 지원금을 구하는 프로시저 작성
/*
        CLERK       :5%
        SALESMAN    :4%
        MANAGER     :3.7%
        ANALYST     :3%
        PRESIDENT   :1.5%
*/

--(1)SP 이름 : sp_get_tribute_fee
--(2)IN 변수 : v_empno(사번타입)
--(3)OUT 변수 : v_tribute_fee(급여타입)

--1.프로시저 작성

CREATE OR REPLACE PROCEDURE sp_get_tribute_fee
        (v_empno       IN  EMP.EMPNO%TYPE
        ,v_tribute_fee OUT EMP.SAL%TYPE)
IS
    --사번인 직원의 직무를 저장할 지역 변수 선언
    v_job   EMP.JOB%TYPE;
    --2.사번인 직원의 급여를 저장할 지역변수 선언
    v_sal   EMP.SAL%TYPE;


BEGIN
    --1.입력된 사번 직원의 직무를 조회
    SELECT e.JOB,e.SAL
      INTO v_job,v_sal
      FROM emp e
     WHERE e.EMPNO = v_EMPNO
     ;
    
    /*
        CLERK       :5%
        SALESMAN    :4%
        MANAGER     :3.7%
        ANALYST     :3%
        PRESIDENT   :1.5%
    */ 
     --일정 비율로 v_tribute_fee를 계산
     IF v_job ='CLERK' THEN v_tribute_fee := v_sal * 0.05;  
     ELSIF v_job ='SALESMAN'  THEN v_tribute_fee := v_sal * 0.04;  
     ELSIF v_job ='MANAGER'   THEN v_tribute_fee := v_sal * 0.037;  
     ELSIF v_job ='ANALYST'   THEN v_tribute_fee := v_sal * 0.03;  
     ELSIF v_job ='PRESIDENT' THEN v_tribute_fee := v_sal * 0.016;  
     END IF;
END sp_get_tribute_fee;
/
--2.컴파일/디버깅

--3.BIND변수에 생성
VAR v_tribute_fee_BIND NUMBER;
--4.실행
EXEC sp_get_tribute_fee(v_tribute_fee => :v_tribute_fee_bind,v_empno=>7566);
--5.출력
PRINT v_tribute_fee_BIND;
/*
V_TRIBUTE_FEE_BIND
------------------
            110.08
*/

---------------------------------------
--2.LOOP 기본 반복문
---------------------------------------
--ANONYMOUS PROCEDURE 로 실행 예
--문제1)1~10까지의 합을 출력


DECLARE
    --1.초기값 설정
    v_init NUMBER :=0;
    --2.합산을 위한 변수 설정
    v_sum  NUMBER :=0;
BEGIN
    LOOP
        V_init := v_init +1;
        v_sum  := v_sum + v_init;
    DBMS_OUTPUT.PUT_LINE('1~10합산결과:'||v_sum);
    --반복문 종료 조건
    EXIT WHEN v_init = 10;
    
    END LOOP
    ;
END;
/
------------------------------------------
--2.LOOP : FOR LOOP 카운터 변수를 사용하는 반복문
------------------------------------------
--지정된 횟수만큼 실행 반복문
--문제)1~20사이의 3의 배수 출력
DECLARE
    --1.for loop에서 사용할 카운터 변수 선언
    cnt NUMBER := 0;
BEGIN
    --2.LOOP문 작성
    FOR cnt IN 1..20 LOOP
    IF(MOD(cnt,3)=0) 
        THEN DBMS_OUTPUT.PUT_LINE(cnt);
    END IF;
    END LOOP;
END;
/
/*
3
6
9
12
15
18
*/


--------------------------------
--2.LOOP:WHILE LOOP조건에 따라 수행되는 반복문
--------------------------------
--문제1)1~20사이의 수 중에서 2의 배수를 화면 출력
--ANONMOUYS로 바로 수행
DECLARE
    --반복 조건으로 사용할 횟수 변수 선언
    cnt      number :=0;
BEGIN
    --WHILE 반복문 작성
    WHILE cnt < 20 LOOP
    cnt := cnt+2;
    DBMS_OUTPUT.PUT_LINE(cnt);
    END LOOP;
END;
/

------------------------------------
--PL/SQL : Stored Function(저장함수)
------------------------------------
--대부분 sp랑 유사
--IS 블록 전에 RETURN구문이 존재
--RETURN 구문에는 문장 종료기호(;)없음
--실행은 기존 사용하는 함수와 동일하게 SELECT,WHERE 절 등에 사용


--문제)부서번호 입력받아 해당 부서의 급여 평균 구하는 함수 작성

--(1)FN이름 : fn_avg_sal_by_dept
--(2)IN변수 : v_deptno(부서번호 타입)
--(3)지역변수 : v_avg_sal(급여타입) 계산된 평균 급여를 저장

--1.함수작성

CREATE OR REPLACE FUNCTION fn_avg_sal_by_dept
    (v_deptno       IN      DEPT.DEPTNO%TYPE)
    return number
IS
    v_avg_sal EMP.SAL%TYPE;
    
BEGIN
    --부서별 급여 평균을 avg() 함수를 사용하여 구하고 저장
    SELECT avg(sal)
      INTO v_avg_sal
      FROM emp e
     WHERE e.DEPTNO = v_deptno
     ;
     --계산 결과를 반올림하여 리턴
     RETURN ROUND(v_avg_sal);
     
END fn_avg_sal_by_dept;
/
SHOW ERRORS;
--2.컴파일 디버깅

--3.이 함수를 사용하는 쿼리를 작성하여 실행
SELECT fn_avg_sal_by_dept(10) AS "부서 급여 평균"
  FROM dual;



--10번 부서의 급여 평균을 알고 싶다.
SELECT fn_avg_sal_by_dept(10) AS "부서 급여 평균"
  FROM dual;


SELECT AVG(sal)
  FROM emp
 WHERE deptno = 10
 ;
 
 --30번 부서의 급여 평균보다 높은 급여 평균을 받는 부서는?
 SELECT e.deptno
       ,avg(e.SAL)
   FROM emp e
  GROUP BY e.DEPTNO
  HAVING AVG(e.SAL) > fn_avg_sal_by_dept(30)
;



------------------------------------------
--SP/FN 에서 예외 처리
------------------------------------------
--예외처리 : 오라클에서 프로시저 실행 중 발생할 수 있는
--         이미 잘 알려진 상황에 대한 사전 정의 예외 목록을 제공

CREATE OR REPLACE PROCEDURE sp_get_emp_info_detail
(v_empno IN emp.empno%TYPE)
IS
 --1.RECORD 타입 선언
 TYPE emp_record_type IS RECORD
 (r_empno       EMP.EMPNO%TYPE
 ,r_ename       EMP.ENAME%TYPE
 ,r_mgrname     EMP.ENAME%TYPE
 ,r_dname       DEPT.DNAME%TYPE
 ,r_loc         DEPT.LOC%TYPE
 ,r_salgrade    SALGRADE.GRADE%TYPE
 );
 
 --2.1에서 선언한 타입의 변수를 선언
 v_emp_record  emp_record_type;
BEGIN

--3. 1에서 선언한 RECORD타입은 조인의 결과를 받을 수 있음
SELECT e.EMPNO
      ,e.ENAME
      ,e1.ENAME
      ,d.DNAME
      ,d.LOC
      ,s.GRADE
  INTO v_emp_record
  FROM emp e,emp e1
      ,dept d
      ,salgrade s
 WHERE e.mgr = e1.empno  --mgr 베정 안된 직원
   AND e.deptno = d.deptno  --dept 배정 안된 직원
   AND e.SAL BETWEEN s.LOSAL AND s.HISAL
   AND e.EMPNO = v_empno
  ;
    DBMS_OUTPUT.PUT_LINE('사      번:'||v_emp_record.r_empno);
    DBMS_OUTPUT.PUT_LINE('이      름:'||v_emp_record.r_ename);
    DBMS_OUTPUT.PUT_LINE('매  니  저:'||v_emp_record.r_mgrname);
    DBMS_OUTPUT.PUT_LINE('부  서  명:'||v_emp_record.r_dname);
    DBMS_OUTPUT.PUT_LINE('부 서 위 치:'||v_emp_record.r_loc);
    DBMS_OUTPUT.PUT_LINE('급 여 등 급:'||v_emp_record.r_salgrade);

  --5.NO_DATA_FOUND 예외 처리
  EXCEPTION 
       WHEN NO_DATA_FOUND
       THEN DBMS_OUTPUT.PUT_LINE('해당직원의 매니저 혹은 부서가 배정되지 않았습니다.');

END;
/

show errors;

exec sp_get_emp_info_detail(7654);
exec sp_get_emp_info_detail(7839);
exec sp_get_emp_info_detail(6666);

--2.DUP_VAL_ON_INDEX
--문제)member 테이블에 member_id,member_name을
--    입력받아서 신규로 1행을 추가하는
--    sp_insert_member 작성

--.1프로시저 작성
CREATE OR REPLACE PROCEDURE sp_insert_member
    (v_member_id   IN  member.member_id%TYPE
    ,v_member_name   IN  MEMBER.MEMBER_NAME%TYPE)
IS

BEGIN
    --입력된 IN 모드 변수값을 INSERT 시도
    INSERT INTO member(member_id,member_name)
    VALUES(v_member_id,v_member_name)
    ;
    COMMIT;
     DBMS_OUTPUT.PUT_LINE(v_member_id||'신규 추가 진행');
    --입력시도에는 항상 DUP_VAL_ON_INDEX예외 위험 존재
    EXCEPTION 
         WHEN DUP_VAL_ON_INDEX
         THEN --이미 존재하는 키의 값이면 신규 추가가 아니라
              --수정으로 진행
              UPDATE member m
                 SET m.member_name = v_member_name
               WHERE m.member_id = v_member_id
               ;
               --처리내용을 화면 출력
                DBMS_OUTPUT.PUT_LINE(v_member_id||'가 이미 존재하므로 멤버 정보 수정 진행');
END sp_insert_member;
/
show errors;

exec sp_insert_member('M13','채한나');
exec sp_insert_member('M11','홍길동');



