---- JOIN 계속..

-- 조인 구문 구조

 

-- 1. 오라클 전용 조인 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1, 테이블2 별칭2 [, ....]
 WHERE 별칭1.공통컬럼1 = 별칭2.공통컬럼1  -- 조인 조건을 WHERE 에 작성
  [AND 별칭1.공통컬럼2 = 별칭n.공통컬럼2] -- FROM 에 나열된 테이블이 2개가 넘을 때 조인 조건 추가
  [AND ... 추가 가능한 일반 조건들 등장]
  ;

-------------------------------------------------------

  -- 2. NATURAL JOIN을 사용하는 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...
  FROM 테이블1 별칭1 NATURAL JOIN 테이블2 별칭2
                  [NATURAL JOIN 테이블n 별칭n]
;
-------------------------------------------------------

-- 3. JOIN ~ USING 을 사용하는 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 USING (공통컬럼) -- 공통컬럼에 별칭 사용하지 않음
;
--------------------------------------------------------

-- 4.  JOING ~ ON 을 사용하는 구조 : 표준 SQL 구문

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 ON(별칭1.공통컬럼2 = 별칭n.공통컬럼2)
                   JOIN 테이블2 별칭2 ON(별칭1.공통컬럼n = 별칭n.공통컬럼n)
;
--------------------------------------------------------
--문제1)emp ,salgrade 테이블을 사용하여 직원의 급여에 따른 등급을 함께 조회
--     emp테이블에는 salgrade 테이블과 연결할 수 있는 동일한 값이 없음

SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,s.GRADE
  FROM emp e
     ,salgrade s
 WHERE e.SAL BETWEEN s.LOSAL AND s.HISAL
 ;
 
 ---
 
 
 
 -- 2.(+)연산자 JOIN 구문 구조
 SELECT .....
   FROM 테이블1 별칭1,테이블2 별칭2
 WHERE 별칭1,공동컬럼(+) = 별칭2.공동컬럼 /*RIGHT OUTER JOIN,왼쪽 테이블의 NULL데이터 출력*/
 WHERE 별칭1,공동컬럼 = 별칭2.공동컬럼(+); /*LEFT OUTER JOIN,오른쪽 테이블의 NULL데이터 출력*/
  ------------------------
  --문제)직원 중 부서가 배치되지 않은 사람이 있을 때
  --1.일반 조인을 걸면 조회가 되지 않는다.
  SELECT e.EMPNO
        ,e.ENAME
        ,d.DEPTNO
        ,d.DNAME
    FROM emp e
        ,dept d
 WHERE e.DEPTNO = d.DEPTNO
 ;
 --2.OUTER JOIN으로 해결
SELECT    e.EMPNO
         ,e.ENAME
         ,d.DEPTNO
         ,d.DNAME
    FROM emp e
        ,dept d
 WHERE e.DEPTNO = d.DEPTNO(+)
 ;
 --(+)연산자는 오른쪽에 붙이고 이는 null상태로 출력될 테이블을 결정
 --LEFT OUTER JOIN 발생, 전체 데이터를 기준삼는 테이블이 왼쪽이기 때문에 
 
 --3)LEFT OUTER JOIN _ON으로 해결
 SELECT   e.EMPNO
         ,e.ENAME
         ,d.DEPTNO
         ,d.DNAME
    FROM emp e LEFT OUTER JOIN dept d
 ON e.DEPTNO = d.DEPTNO(+)
 ;
 --문제)아직 아무도 배치되지 않은 부서가 있어도
 --    부서를 다 조회하고 싶다면
 --1.(+) 연산자로 해결
 SELECT e.EMPNO
       ,e.ENAME
       ,e.DEPTNO
       ,'||'
       ,d.DEPTNO
       ,d.DNAME
   FROM emp e
       ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO
 ;
 --RIGHT OUTER JOIN ~ON으로 해결

 SELECT e.EMPNO
       ,e.ENAME
       ,e.DEPTNO
       ,'||'
       ,d.DEPTNO
       ,d.DNAME
   FROM emp e RIGHT OUTER JOIN dept d
 ON e.DEPTNO(+) = d.DEPTNO
 ;
 
 --문제)부서배치가 안된 직원도 보고 싶고 
 --    직원이 아직 아무도 없는 부서도 모두 보고 싶을때
 --    즉, 양쪽 모두에 존재하는 NULL 값들을 모두 한번에 조회하려면 어떻게 해야 하는가?
 SELECT e.EMPNO
       ,d.DNAME
   FROM emp e
       ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO(+)
; --ORA-01468: a predicate may reference only one outer-joined table

 SELECT e.EMPNO
       ,e.ENAME
       ,d.DNAME
   FROM emp e FULL OUTER JOIN dept d
 ON e.DEPTNO = d.DEPTNO
; 

--6)SELF JOIN : 한 테이블 내에서 자기 자신의 컬럼끼리 연결하여 새행을 만드는 기법
--문제) emp테이블에서mgr에 해당하는 상사의 이름을 같이 조회하려면
SELECT e1.EMPNO "직원번호"
      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1, emp e2
 WHERE e1.MGR = e2.EMPNO
;
--상사가 없는 사원들도 조회하고 싶다
--a) e1 테이블의 기준 =>SELF OUTER JOIN 
--b) (+)기호를 

SELECT e1.EMPNO "직원번호"

      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1 RIGHT OUTER JOIN emp e2
 ON e1.MGR = e2.EMPNO
;

--부하직원이 없는 직원을 조회
SELECT e1.EMPNO "직원번호"
      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1, emp e2
 WHERE e1.MGR(+) = e2.EMPNO
;

------------7.조인과 서브쿼리
--(2)서브쿼리 : SELECT FROM WHERE절에서 사용할 수 있다
--emp테이블에서 BLAKE와 직무가 동일한 직원의 정보를 조회하고 싶을 때
--a)BLAKE의 직무값을 조회
SELECT e.EMPNO
      ,e.JOB
  FROM emp e
  WHERE e.ENAME = 'BLAKE'
; -- MANAGER
--b)1에서 조회된 믹무값을 다시 WHERE절에서 수행
SELECT e.EMPNO
      ,e.ENAME
  FROM emp e
  WHERE e.JOB = (SELECT e.JOB
  FROM emp e
 WHERE e.ENAME = 'BLAKE')
;






-------------------------------------------------------
--서브쿼리 실습
--1.이 회사의 평균 급여보다 급여가 큰 직원들의 목록을 조회
--a)평균 급여 구하기
SELECT AVG(e.SAL)
  FROM emp e
;

--b)급여보다 큰 직원들 구하기
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL > (SELECT AVG(e.SAL)
  FROM emp e)
;

--2.급여가 평균 급여보다 크면서 사번이 7700보다 높은 직원 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL  > (SELECT AVG(e.SAL) 
  FROM emp e) AND e.EMPNO > 7700
;


--3.각 직무별로 최대 급여를 받는 직원 목록을 조회
--(사번,이름,직무,급여)
--a)직무별 최대급여 조회
SELECT e.JOB
      ,MAX(e.SAL)
  FROM emp e
  GROUP BY e.JOB
;
--b)a를 사용할 메인쿼리
--최대 급여가 자신의 급여가 같은지
--그 때의 직무가 나의 직무와 같은지 비교 필요
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
WHERE (e.JOB,e.SAL) IN (SELECT e.JOB --ORA-00913: too many values
               ,MAX(e.SAL)
  FROM emp e
  GROUP BY e.JOB)
; 
-->WHERE절에서 = 비교는 e.SAL 은 컬럼 1행당 비교
-- 그런데 서브쿼리에서 돌아오는 값은 6행
--1행과 6행은 비교자체가 불가능
-->IN연산자 사용해서 해결 / 데이터가 다양해지면 잘못 작동할 수 있기 때문에 IN의 컬럼을 정확히 명시해주는것이 좋음


--4.각 월별 입사인원을 세로로 출력
--a)입사일 데이터에서 월을 추출
SELECT TO_CHAR(e.HIREDATE,'FMMM')
  FROM emp e
;
--b)입사 월별 인원 => 그룹화 기준 월
--  인원을 구하는 함수 =>COUNT(*)사용
SELECT TO_CHAR(e.HIREDATE,'FMMM') "월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "월" ASC
;
SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,'FMMM'))||'월' "월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "월" ASC
;
-->월을 붙이면 다시문자화 돠어 정렬이 망가짐

--서브쿼리로 감싸서 정렬시도
SELECT a."입사월" || '월' as "입사월"
      ,a."인원(명)"
  FROM (SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,'FMMM'))||'월' "입사월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "입사월" ASC) a
;



CREATE TABLE member
( member_id    VARCHAR2(3) PRIMARY KEY
 ,member_name  VARCHAR2(15) NOT NULL
 ,phone        VARCHAR2(4)
 ,reg_date     DATE
 ,address      VARCHAR2(12)
 ,like_number  NUMBER(1) 
);

DROP TABLE member;
/* ----------
   수정의 종류
   ----------
1.컬럼을 추가 : ADD
2.컬럼을 삭제 : DROP COLUMN
3.컬럼을 수정 : MODIFY
*/
ALTER TABLE 테이브이름{ADD|DROP COLUMN|MODIFY}....;
--예) 생성한 MEMBER 테이블에 컬럼 2개 추가
--    출생 월 : birth_month  : NUMBER
--    성별 : gender     :VARCHAR2(1)
ALTER TABLE member ADD
( birth_month NUMBER
 ,gender      VARCHAR2(1) CHECK(gender IN('M','F'))
);

ALTER TABLE member ADD
(birth_month NUMBER
,gender      VARCHAR2(1) CHEC)
;
--예)출생월 컬럼을 숫자2 자리까지만으로 제한하도록 수정
--3)MODIFY
ALTER TABLE member MODIFY birth_month NUMBER(2);

-----------------------------------
--예로 사용할 member 테이블의 최종 형태 작성 구문
CREATE TABLE member
( member_id    VARCHAR2(3)  PRIMARY KEY
 ,member_name  VARCHAR2(15) NOT NULL
 ,phone        VARCHAR2(4)
 ,reg_date     DATE         DEFAULT sysdate
 ,address      VARCHAR2(30)
 ,like_number  NUMBER(1) 
 ,birth_month  NUMBER(2)
 ,gender       VARCHAR2(1)  CHECK(gender IN('M','F'))
);
drop table member;
--가장 단순화된 테이블 정의 구문
--제약 조건 

--테이블 생성시 정의한 제약조건이 저장되는 형태
--DDL로 정의된 제약조건은 시스템 카탈로그에 저장됨
--user_constraint 라는 테이블에 저장
SELECT u.CONSTRAINT_NAME
      ,u.CONSTRAINT_TYPE
      ,u.TABLE_NAME
FROM user_constraints u
WHERE u.TABLE_NAME = 'MEMBER';

CREATE TABLE member
( member_id    VARCHAR2(3)  
 ,member_name  VARCHAR2(15) NOT NULL
 ,phone        VARCHAR2(4)
 ,reg_date     DATE         DEFAULT sysdate
 ,address      VARCHAR2(30)
 ,like_number  NUMBER(1) 
 ,birth_month  NUMBER(2)
 ,gender       VARCHAR2(1)  
 ,CONSTRAINT pk_member PRIMARY KEY(member_id)
 ,CONSTRAINT ch_member_gender CHECK(gender IN('M','F'))
);
DROP TABLE MEMBER;

--테이블 생성 기법중 이미 존재하는 테이블로부터 복사생성
--예)앞서 생성한 member 테이블을 복사 생성 : new_member
DROP TABLE new_member;


DESC MEMBER;

--테이블 스키마(구조)만 복사
CREATE TABLE new_member
 AS
 SELECT *
 FROM member
 WHERE 1=2;
 
 DESC NEW_MEMBER;
 
DROP TABLE ojung_member;
CREATE TABLE ojung_member
AS
SELECT *
  FROM member
  WHERE ADDRESS = '오정동'
;/*
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M01', '유재성', '0238', '용운동', '3', 'M')
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M02', '윤홍식', '4091', '오정동', '12', 'M')
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M2', '윤한수', '9034', '오정동', '29', 'M')
*/


--복사할 조건에 항상 참여되는 조건을 주면 
--모든 데이터를 복사하여 새 테이블 생성
DROP TABLE full_member;
CREATE TABLE full_member
AS
SELECT *
  FROM MEMBER
  WHERE 1 = 1 -- 항상 참이되는 조건
  ;
  
 --테이블 수정할 때 주의사항
 
 --1) 컬럼에 데이터가 없을 때는 타입변경,크기변경 모두 자유로움
 --2) 컬럼에 데이터가 있을 때 데이터 크기가 동일 혹은 커지는 방향으로만 가능
 --   숫자는 정밀도 증가로만 허용
 --3) 기본값(DEFAULT) 설정은 수정 이후 입력 값부터 적용
 
 --오정동에 사는 멤버만 복사한 OJUNG-MEMBER 테이블을 생각해보자
 --주소가 '오정동'으로 고정되어도 될 것 같다.
  
  --홍길동 정보 입력 후 기본 값 설정
  ALTER TABLE ojung_member MODIFY(address DEFAULT '오정동');
  
  INSERT INTO "SCOTT"."OJUNG_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, BIRTH_MONTH, GENDER) VALUES
  ('M98', '허균', '9999', '8', 'M');
  
  
  --이미 데이터가 들어있는 컬럼의 크기변경
  --예)OJUNG_MEMBER 테이블의 출생월 birth_month 컬럼을 1칸으로 줄이면
  ALTER TABLE ojung_member MODIFY birth_month NUMBER(1);
  --ORA-01440: column to be modified must be empty to decrease precision or scale
  ALTER TABLE ojung_member MODIFY birth_month NUMBER(10,2);
  --숫자 데이터를 확장하는 방식으로 변경 성공
  -- 예)출생월 birth_month를 문자 2자리로 변경
  ALTER TABLE ojung_member MODIFY birth_month VARCHAR(2);
  --데이터 타입변경을 위해서는 컬럼에 데이터가 없어야 함


-------------------------------------------
--(3)데이터 무결정 제약 조건 처리방법 4가지
--1.컬럼 정의할때 제약조건 이름없이 바로선언
CREATE TABLE main_table
( id       VARCHAR2(10)   PRIMARY KEY
 ,nickname VARCHAR2(30)   UNIQUE     
 ,reg_date DATE           DEFAULT sysdate
 ,gender   VARCHAR2(1)    CHECK (GENDER IN('M','F'))
 ,message  VARCHAR2(300)
);

DROP TABLE sub_table;
CREATE TABLE sub_table
( id       VARCHAR2(10)   REFERENCES main_table(id)
 ,sub_code NUMBER(4)      NOT NULL
 ,sub_name VARCHAR2(30)   
  );

SELECT u.
  FROM ser_constraints u
  WHERE u.constraint
;
--2.컬럼 정의할 때 제약 조건 이름 주며 선언

--3.컬럼 정의 후 제약 조건 따로 선언
drop table main_table;
CREATE TABLE main_table
( id       VARCHAR2(10)   
 ,nickname VARCHAR2(30)        
 ,reg_date DATE           DEFAULT sysdate
 ,gender   VARCHAR2(1)    
 ,message  VARCHAR2(300)
 ,CONSTRAINT pk_main_table      PRIMARY KEY(id)
 ,CONSTRAINT uq_main_table_nick UNIQUE(nickname)
 ,CONSTRAINT ck_main_table_gender check(GENDER IN('M','F'))
);

DROP TABLE sub_table;
CREATE TABLE sub_table
( id       VARCHAR2(10)   
 ,sub_code NUMBER(4)      NOT NULL
 ,sub_name VARCHAR2(30)   
  ,CONSTRAINT fk_sub_table FOREIGN KEY(ID) REFERENCES main_table(id)
  ,CONSTRAINT pk_sub_table PRIMARY KEY(ID,sub_code) 
  );




--4.테이블 정의 후 테이블 수정으로 제약조건 추가

CREATE TABLE main_table
( id       VARCHAR2(10)   
 ,nickname VARCHAR2(30)        
 ,reg_date DATE           DEFAULT sysdate
 ,gender   VARCHAR2(1)    
 ,message  VARCHAR2(300)
); --제약조건 사후추가
ALTER TABLE main_table add 
( CONSTRAINT pk_main_table      PRIMARY KEY(id)
 ,CONSTRAINT uq_main_table_nick UNIQUE(nickname)
 ,CONSTRAINT ck_main_table_gender check(GENDER IN('M','F'))
);

--------------------------------------------------------------
--테이블 이름의 변경 : RENAME
--OJUNG_MEMBER ==>MEMBER_OF_OJUNG
RENAME MEMBER_OF_OJUNG TO OJUNG_MEMBER;

DESC OJUNG_MEMBER;
--테이블 삭제 : DROP
DROP TABLE MAIN_TABLE;
--ORA-02449: unique/primary keys in table referenced by foreign keys 
--SUN_TABLE의 ID컬럼이 MAIN_TABLE의 ID컬럼을 참조 하기 때문
--테이블 삭제에 순서가 필요

DROP TABLE main_table CASCADE CONSTRAINT;
--참조 관계에 상관없이 테이블 바로 삭제
DROP TABLE 

