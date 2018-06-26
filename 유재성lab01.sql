--------실습1---------
SELECT DISTINCT 
     e.empno
    ,e.ename
    ,e.job
    ,e.sal
FROM EMP e
ORDER BY sal desc;
--------실습2---------
SELECT DISTINCT
     e.empno
    ,e.ename
    ,e.hiredate
from emp e
ORDER BY hiredate desc;
--------실습3---------
SELECT 
    e.empno
   ,e.ename
   ,e.comm
FROM emp e
ORDER BY e.comm asc;
--------실습4---------
SELECT 
    e.empno
   ,e.ename
   ,e.comm
FROM emp e
ORDER BY e.comm desc;
--------실습5---------
SELECT empno as 사번
      ,ename as 이름
      ,sal  as 급여
      ,hiredate as 입사일
from emp
;
--------실습6---------
SELECT *
FROM emp
;
--------실습7---------
SELECT *
FROM emp
WHERE ename = 'ALLEN'
;
--------실습8---------
SELECT empno
      ,ename
      ,deptno
 FROM emp
WHERE deptno = 20
;