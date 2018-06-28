--실습1)
SELECT INITCAP(e.ENAME) 
  FROM emp e
;
--실습2)
SELECT LOWER(e.ENAME) 
  FROM emp e
;
--실습3)
SELECT UPPER(e.ENAME) 
  FROM emp e
;

--실습4)
SELECT LENGTH('korea')
 FROM dual;
SELECT LENGTHB('korea')
 FROM dual;
--실습5)
SELECT LENGTH('유재성')
 FROM dual;
SELECT LENGTHB('유재성')
 FROM dual;
--실습6)
SELECT CONCAT('SQL','배우기')
  FROM dual;
--실습7)
SELECT SUBSTR('SQL배우기',5,2)
  FROM dual;
--실습8)
SELECT LPAD('SQL',7,'$')
  FROM dual;
--실습9)
SELECT RPAD('SQL',7,'$')
  FROM dual;
--실습10)
SELECT LTRIM(' SQL배우기   ')
  FROM dual;
--실습11)
SELECT RTRIM(' SQL배우기   ')
  FROM dual;
--실습12)
SELECT TRIM(' SQL배우기   ')
  FROM dual;
--실습13)
SELECT NVL(e.COMM,0)
 FROM emp e;
--실습14)
SELECT NVL2(e.COMM,e.SAL+e.COMM,0)
 FROM emp e;
--실습15)
SELECT e.EMPNO "사원번호"
      ,e.ENAME "이름"
      ,e.SAL   "급여"
      ,DECODE(e.JOB
              ,'CLERK',    '$300'
              ,'SALESMAN', '$450'
              ,'MANAGER',  '$600'
              ,'ANALYST',  '$500'
              ,'PRESIDENT','$1000'
              ) AS "자기계발비"
  FROM emp e
;
--실습16)
SELECT e.EMPNO "사번"
      ,e.ENAME "이름"
      ,e.SAL   "급여"
      ,CASE e.JOB WHEN 'CLERK' THEN '$300'
                  WHEN 'SALESMAN' THEN  '$450'
                  WHEN 'MANAGER' THEN   '$600'
                  WHEN 'ANALYST' THEN   '$800'
                  WHEN 'PRESIDENT' THEN '$1000'
                END AS "자기계발비"
  FROM emp e
;
--실습 17)
SELECT e.EMPNO "사번"
      ,e.ENAME "이름"
      ,e.SAL   "급여"
      ,CASE       WHEN e.JOB = 'CLERK'     THEN '$300'
                  WHEN e.JOB = 'SALESMAN'  THEN  '$450'
                  WHEN e.JOB ='MANAGER'    THEN   '$600'
                  WHEN e.JOB = 'ANALYST'   THEN   '$800'
                  WHEN  e.JOB ='PRESIDENT' THEN '$1000'
                END AS "자기계발비"
  FROM emp e
;
--실습 18)
SELECT COUNT(*)
  FROM emp e
;
--실습 19)
SELECT COUNT(DISTINCT e.JOB)
  FROM emp e;
--실습 20) null은 카운터 안함
SELECT COUNT(e.COMM)
  FROM emp e
;
--실습 21)
SELECT TO_CHAR(SUM(e.SAL),'$99,999') "급여의 총합"
  FROM emp e
;
--실습22)
SELECT TO_CHAR(AVG(e.SAL),'$9,999.00') "급여평균"
  FROM emp e
;
--실습23)
SELECT  e.DEPTNO "부서번호"
       ,TO_CHAR(SUM(e.SAL),'$99,999') "급여의 총합"
       ,TO_CHAR(AVG(e.SAL),'$99,999') "급여의 평균"
       ,TO_CHAR(MAX(e.SAL),'$99,999') "최대급여"
       ,TO_CHAR(MIN(e.SAL),'$99,999') "최소급여"
  FROM emp e
  WHERE e.DEPTNO = 20
  GROUP BY e.DEPTNO
;
--실습24,25 SKIP 표준편차와 분산조회

--실습26)
SELECT NVL(e.DEPTNO||'','미지정') "부서번호"
       ,SUM(DECODE(e.JOB
              ,'CLERK',    300
              ,'SALESMAN', 450
              ,'MANAGER',  600
              ,'ANALYST',  500
              ,'PRESIDENT',1000
              )) AS "부서별 자기계발비 합"
  FROM emp e
  GROUP BY e.DEPTNO
 ORDER BY e.DEPTNO asc 
;
--실습27)
SELECT NVL(e.DEPTNO||'','미지정') "부서번호"
       ,SUM(DECODE(e.JOB
              ,'CLERK',    300
              ,'SALESMAN', 450
              ,'MANAGER',  600
              ,'ANALYST',  500
              ,'PRESIDENT',1000
              )) AS "부서별 자기계발비 합"
       ,e.JOB
  FROM emp e
  GROUP BY e.DEPTNO,e.JOB
  ORDER BY e.DEPTNO asc,e.JOB desc 
;

