------------------------------------
--PL/SQL
------------------------------------
--1.ANNONYMOUS PROCEDURE : 이름없이 1회 실행 저장 프로시저

--출력 설정 SQL*PLUS 설정
--기본 OFF로 설정
SHOW SERVEROUTPUT;
--ON으로 변경
SET SERVEROUTPUT ON; 

--1)변수선언이 있는 ANNONYMOUS PROCEDURE 작성
DECLARE 
        name VARCHAR2(20) := 'Hannam Univ';
        --name 변수는 선언하며 값을 저장
        year NUMBER;
        --year변수는 선언만 하고 값을 저장하지 않음
BEGIN
        --프로시저에서 실행할 로직을 작성
        --일반적으로 sql구문처리가 들어감
        --변수처리,비교,반복 등의 로직이 들어감
        
        --year값에 변수저장
        year :=1956;
        
        --화면출력
        DBMS_OUTPUT.put_line(name||' since '||year);
END;
/


--DECLEAR에서는 변수만 선언
--BEGIN에서 값을 저장
--출력

DECLARE 
        name VARCHAR2(20); 
        --name 변수 선언
        year NUMBER;
        --year 변수 선언
BEGIN
        --프로시저에서 실행할 로직을 작성
        --일반적으로 sql구문처리가 들어감
        --변수처리,비교,반복 등의 로직이 들어감
        
        --,NAME,year값에 변수저장
        NAME := 'Hannam Univ';
        year := 1956;
        
        --화면출력
        DBMS_OUTPUT.put_line(name||' since '||year);
END;
/


--2)변수 선언이 없는 1회용 프로시저는 DECLARE 블록 생략 가능
BEGIN
DBMS_OUTPUT.PUT_LINE('한남대학교 개교 1956년');
END
;
/

-----------------------------------------
--2.STORED PROCEDURE
-----------------------------------------
--반복적으로 호출하여 사용하기 위한 목적으로
--PROCEDURE을 DBMS에 선 컴파일 하여 저장하고
--사용하는 객체

--TABLE,SEQUENCE,VIEW등과 같은 객체이므로
--동일한 이름의 다른 테이블명 등으로 생성 불가능

--1)저장 프로시져(SP)의 생성

CREATE OR REPLACE PROCEDURE sp_maxim
        (name       IN VARCHAR2
        ,message    IN VARCHAR2)
IS
BEGIN
         DBMS_OUTPUT.PUT_LINE(name||' : '|| message);
END sp_maxim;
/

--ORACLE SQL Developer ==>ctnl + enter 입력으로 컴파일 진행
--SQL*PLUS명령창 코드 붙여넣기로 컴파일 가능

--PROCEDURE SP_MAXIM이 컴파일 되었습니다.
--저장 프로시저는 컴파일과 동시 실행이 아님. 컴파일만 실행
--실행은 따로 해야함
--구문에 오류가 있으면 오류와 함께 컴파일 진행
--오류 상태로 컴파일 됨 프로시저는 실행이 안됨



--3)오류 상태로 컴파일 되면 오류 수정 후 재컴파일 진행
SHOW ERRORS;
--  PLS-00103: Encountered the symbol "END" when expecting one of the following:


--4)실행
--------a)BIND변수를 선언(OUT변수가 선언된 경우만)
--------b)excute명령을 실행
--------c)PRINT명령으로 BIND 변수값 출력(OUT변수가 선언된 경우만)


--EXECUTE 프로시저 이름(전달할값1,전달할값2) : SQP*PLUS
EXECUTE SP_MAXIM('소크라테스','너 자신을 알라');
EXECUTE SP_MAXIM('홍길동','호부호형을 못하니...');
EXECUTE SP_MAXIM('데카르트','나는 생각한다. 고로 나는 존재한다');
EXECUTE SP_MAXIM('장 폴 사르트','인생은 B와 D사이의 c이다');

--입력 아규먼트가 없는 SP작성
CREATE OR REPLACE PROCEDURE sp_maxim_noargs
IS
    --지역변수 선언 블록,BEGIN~END사이에서 사용되는 변수 선언 부
    --변수타입 선언시 크기까지 지정
    name        VARCHAR2(30) := '소크라테스';
    message     VARCHAR2(100) := '너 자신을 알라';
BEGIN
 DBMS_OUTPUT.PUT_LINE(name||' : '|| message);
END sp_maxim_noargs;
/
EXECUTE sp_maxim_noargs;


----------------------------------------
--OUT 모드 변수가 있는 SP
--1)sp_maxim을 OUT 변수가 있는 SP로 수정
CREATE OR REPLACE PROCEDURE sp_maxim
(name       IN VARCHAR2
,message    IN VARCHAR2
,result     OUT VARCHAR2)
IS
BEGIN
--블록안에서 바로 출력
 DBMS_OUTPUT.PUT_LINE(name||' : '|| message);
--result OUT변수에 저장
result := name||' : '|| message;
END sp_maxim;
/

--procedure SP_MAXIM(가) 컴파일 되었습니다.
--2)실행을 위해

--a)BIND 변수를 선언 : SQL*PLUS의 변수
--VAR[IABLE] 바인드변수이름 타입
VAR v_maxim_result VARCHAR2(200)
-- BIND변수를 출력
PRINT v_maxim_result

----b)EXECUTE로 SP실행 
EXECUTE sp_maxim('소크라테스','너 자신을 알라',:v_maxim_result)
/*소크라테스 : 너 자신을 알라
PL/SQL 프로시저가 성공적으로 완료되었습니다.*/

----c)PRINT로 BIND 변수를 출력
PRINT v_maxim_result


