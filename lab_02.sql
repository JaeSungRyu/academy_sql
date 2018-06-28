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
SELECT SUBSTR('SQL 배우기',5,2) 
  FROM dual;
--실습8)
SELECT LPAD('SQL',7,'$') 
  FROM dual;
--실습9)
SELECT RPAD('SQL',7,'$') 
  FROM dual;
--실습10)
SELECT LTRIM('   SQL배우기  ') 
  FROM dual;
--실습11)
SELECT RTRIM('   SQL배우기  ') 
  FROM dual;
--실습12)
SELECT '>'|| TRIM('   SQL배우기 ') || '<' 
  FROM dual;
--실습13)
SELECT nvl(e.COMM,0) 
  FROM emp e
;
--실습14)
SELECT nvl2(e.COMM,e.SAL+e.COMM,0) 
  FROM emp e
;
--실습15)
SELECT DECODE
  FROM emp e
;
