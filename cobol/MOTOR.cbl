      ******************************************************************
      * Created: Tue, 7 May 2024 07:17:41 GMT
      * Generated by: IBM watsonx Code Assistant for Z Refactoring
      * Assistant
      * Workbook name: UPDMTR
      * Workbook id: 8b528529-0031-46cd-ac5f-1a56f3d9ec47
      * Project: $GenApp_dbd8ae2b-9f75-494c-bdea-2934819822e5
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. RAEXPORT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  DFHCOMMAREA-1.
           COPY LGCMAREA.
       01 DB2-IN-INTEGERS-1.
          03 DB2-M-ACCIDENTS-INT-1       PIC S9(9) COMP.
          03 DB2-POLICYNUM-INT-1         PIC S9(9) COMP.
          03 DB2-M-VALUE-INT-2           PIC S9(9) COMP.
          03 DB2-M-CC-SINT-2             PIC S9(4) COMP.
          03 DB2-M-PREMIUM-INT-2         PIC S9(9) COMP.
       01  WS-ABSTIME                  PIC S9(8) COMP VALUE +0.
       01  CA-ERROR-MSG-1.
           03 FILLER                   PIC X(9)  VALUE 'COMMAREA='.
           03 CA-DATA-2                  PIC X(90) VALUE SPACES.
       01  WS-TIME                     PIC X(8)  VALUE SPACES.
       01  WS-DATE                     PIC X(10) VALUE SPACES.
       01  ERROR-MSG-2.
           03 FILLER                   PIC X     VALUE SPACES.
           03 EM-TIME-1                  PIC X(6)  VALUE SPACES.
           03 FILLER                   PIC X(9)  VALUE ' LGUPDB01'.
           03 EM-VARIABLE-1.
             05 FILLER                 PIC X(6)  VALUE ' CNUM='.
             05 EM-CUSNUM-1              PIC X(10)  VALUE SPACES.
             05 FILLER                 PIC X(6)  VALUE ' PNUM='.
             05 EM-POLNUM-1              PIC X(10)  VALUE SPACES.
             05 EM-SQLREQ-1              PIC X(16) VALUE SPACES.
             05 FILLER                 PIC X(9)  VALUE ' SQLCODE='.
             05 EM-SQLRC-1               PIC +9(5) USAGE DISPLAY.
           03 EM-DATE-2                  PIC X(8)  VALUE SPACES.
       01  DATE1                       PIC X(10) VALUE SPACES.
       01  ERROR-MSG-1.
           03 EM-DATE-1                  PIC X(8)  VALUE SPACES.
           03 FILLER                   PIC X     VALUE SPACES.
           03 EM-TIME-2                  PIC X(6)  VALUE SPACES.
           03 FILLER                   PIC X(9)  VALUE ' LGIPOL01'.
           03 EM-VARIABLE-2.
             05 FILLER                 PIC X(6)  VALUE ' CNUM='.
             05 EM-CUSNUM-2              PIC X(10)  VALUE SPACES.
             05 FILLER                 PIC X(6)  VALUE ' PNUM='.
             05 EM-POLNUM-2              PIC X(10)  VALUE SPACES.
             05 EM-SQLREQ-2              PIC X(16) VALUE SPACES.
             05 FILLER                 PIC X(9)  VALUE ' SQLCODE='.
             05 EM-SQLRC-2               PIC +9(5) USAGE DISPLAY.
       77  IND-BROKERID                PIC S9(4) COMP.
       77  IND-BROKERSREF              PIC S9(4) COMP.
       77  IND-PAYMENT                 PIC S9(4) COMP.
       01  CA-ERROR-MSG-2.
           03 CA-DATA-1                  PIC X(90) VALUE SPACES.
           03 FILLER                   PIC X(9)  VALUE 'COMMAREA='.
       01 MINUS-ONE                    PIC S9(4) COMP VALUE -1.
       01  WS-COMMAREA-LENGTHS.
           03 WS-CA-HEADERTRAILER-LEN  PIC S9(4) COMP VALUE +33.
           03 WS-REQUIRED-CA-LEN       PIC S9(4)      VALUE +0.
       01 DB2-IN-INTEGERS-2.
           03 DB2-CUSTOMERNUM-INT      PIC S9(9) COMP VALUE +0.
           03 DB2-POLICYNUM-INT-2        PIC S9(9) COMP VALUE +0.
       01 DB2-OUT-INTEGERS.
           03 DB2-M-VALUE-INT-1          PIC S9(9) COMP.
           03 DB2-M-CC-SINT-1            PIC S9(4) COMP.
           03 DB2-M-PREMIUM-INT-1        PIC S9(9) COMP.
           03 DB2-M-ACCIDENTS-INT-2      PIC S9(9) COMP.
           03 DB2-BROKERID-INT         PIC S9(9) COMP.
           03 DB2-PAYMENT-INT          PIC S9(9) COMP.
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.
       01  TIME1                       PIC X(8)  VALUE SPACES.
       COPY LGPOLICY.

           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
             INCLUDE DGENAPP
           END-EXEC.

       LINKAGE SECTION.

       PROCEDURE DIVISION.
      * WRITE-ERROR-MESSAGE-2 RENAMED FROM WRITE-ERROR-MESSAGE
       UPDATE-MOTOR-DB2-INFO.

      *    Move numeric commarea fields to DB2 Integer formats
           MOVE CA-M-CC IN DFHCOMMAREA-1          TO DB2-M-CC-SINT-2
           MOVE CA-M-VALUE IN DFHCOMMAREA-1       TO DB2-M-VALUE-INT-2

              IF CA-M-ACCIDENTS IN DFHCOMMAREA-1 <= 2
              COMPUTE CA-M-PREMIUM IN DFHCOMMAREA-1 = CA-M-PREMIUM IN
               DFHCOMMAREA-1 * 1.
              IF CA-M-ACCIDENTS IN DFHCOMMAREA-1 > 2 AND <= 5
              COMPUTE CA-M-PREMIUM IN DFHCOMMAREA-1 = CA-M-PREMIUM IN
               DFHCOMMAREA-1 * 1.20.
              IF CA-M-ACCIDENTS IN DFHCOMMAREA-1 > 5 AND <= 8
              COMPUTE CA-M-PREMIUM IN DFHCOMMAREA-1 = CA-M-PREMIUM IN
               DFHCOMMAREA-1 * 1.50.
              IF CA-M-ACCIDENTS IN DFHCOMMAREA-1 > 8
              COMPUTE CA-M-PREMIUM IN DFHCOMMAREA-1 = CA-M-PREMIUM IN
               DFHCOMMAREA-1 * 2.
    
           MOVE CA-M-PREMIUM IN DFHCOMMAREA-1     TO DB2-M-PREMIUM-INT-2
           MOVE CA-M-ACCIDENTS IN DFHCOMMAREA-1   TO
           DB2-M-ACCIDENTS-INT-1

           MOVE ' UPDATE MOTOR ' TO EM-SQLREQ-1
           EXEC SQL
             UPDATE MOTOR
               SET
                    MAKE              = :CA-M-MAKE ,
                    MODEL             = :CA-M-MODEL  ,
                    VALUE             = :DB2-M-VALUE-INT-2,
                    REGNUMBER         = :CA-M-REGNUMBER ,
                    COLOUR            = :CA-M-COLOUR ,
                    CC                = :DB2-M-CC-SINT-2,
                    YEAROFMANUFACTURE = :CA-M-MANUFACTURED,
                    PREMIUM           = :DB2-M-PREMIUM-INT-2,
                    ACCIDENTS         = :DB2-M-ACCIDENTS-INT-1
               WHERE
                    POLICYNUMBER      = :DB2-POLICYNUM-INT-1
           END-EXEC

           IF SQLCODE IN SQLCA NOT EQUAL 0
      *      Non-zero SQLCODE IN SQLCA from UPDATE statement
             IF SQLCODE IN SQLCA EQUAL 100
               MOVE '01' TO CA-RETURN-CODE IN DFHCOMMAREA-1
             ELSE
               MOVE '90' TO CA-RETURN-CODE IN DFHCOMMAREA-1
      *        Write error message to TD QUEUE(CSMT)
               PERFORM WRITE-ERROR-MESSAGE-2
             END-IF
           END-IF.
           EXIT.

      * WRITE-ERROR-MESSAGE-2 RENAMED FROM WRITE-ERROR-MESSAGE
       WRITE-ERROR-MESSAGE-2.
      * Save SQLCODE IN SQLCA in message
           MOVE SQLCODE IN SQLCA TO EM-SQLRC-1
      * Obtain and format current time and date
           EXEC CICS ASKTIME ABSTIME(WS-ABSTIME)
           END-EXEC
           EXEC CICS FORMATTIME ABSTIME(WS-ABSTIME)
                     MMDDYYYY(WS-DATE)
                     TIME(WS-TIME)
           END-EXEC
           MOVE WS-DATE TO EM-DATE-2
           MOVE WS-TIME TO EM-TIME-1
      * Write output message to TDQ
           EXEC CICS LINK PROGRAM('LGSTSQ')
                     COMMAREA(ERROR-MSG-2)
                     LENGTH(LENGTH OF ERROR-MSG-2)
           END-EXEC.
      * Write 90 bytes or as much as we have of commarea to TDQ
           IF EIBCALEN > 0 THEN
             IF EIBCALEN < 91 THEN
               MOVE DFHCOMMAREA-1(1:EIBCALEN) TO CA-DATA-2
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG-1)
                         LENGTH(LENGTH OF CA-ERROR-MSG-1)
               END-EXEC
             ELSE
               MOVE DFHCOMMAREA-1(1:90) TO CA-DATA-2
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG-1)
                         LENGTH(LENGTH OF CA-ERROR-MSG-1)
               END-EXEC
             END-IF
           END-IF.
           EXIT.

      * WRITE-ERROR-MESSAGE-1 RENAMED FROM WRITE-ERROR-MESSAGE
       GET-MOTOR-DB2-INFO.

           MOVE ' SELECT MOTOR ' TO EM-SQLREQ-2
           EXEC SQL
             SELECT  ISSUEDATE,
                     EXPIRYDATE,
                     LASTCHANGED,
                     BROKERID,
                     BROKERSREFERENCE,
                     PAYMENT,
                     MAKE,
                     MODEL,
                     VALUE,
                     REGNUMBER,
                     COLOUR,
                     CC,
                     YEAROFMANUFACTURE,
                     PREMIUM,
                     ACCIDENTS
             INTO  :DB2-ISSUEDATE,
                   :DB2-EXPIRYDATE,
                   :DB2-LASTCHANGED,
                   :DB2-BROKERID-INT INDICATOR :IND-BROKERID,
                   :DB2-BROKERSREF INDICATOR :IND-BROKERSREF,
                   :DB2-PAYMENT-INT INDICATOR :IND-PAYMENT,
                   :DB2-M-MAKE,
                   :DB2-M-MODEL,
                   :DB2-M-VALUE-INT-1,
                   :DB2-M-REGNUMBER,
                   :DB2-M-COLOUR,
                   :DB2-M-CC-SINT-1,
                   :DB2-M-MANUFACTURED,
                   :DB2-M-PREMIUM-INT-1,
                   :DB2-M-ACCIDENTS-INT-2
             FROM  POLICY,MOTOR
             WHERE ( POLICY.POLICYNUMBER =
                        MOTOR.POLICYNUMBER   AND
                     POLICY.CUSTOMERNUMBER =
                        :DB2-CUSTOMERNUM-INT             AND
                     POLICY.POLICYNUMBER =
                        :DB2-POLICYNUM-INT-2               )
           END-EXEC

           IF SQLCODE IN SQLCA = 0
      *      Select was successful

      *      Calculate size of commarea required to return all data
             ADD WS-CA-HEADERTRAILER-LEN TO WS-REQUIRED-CA-LEN
             ADD WS-FULL-MOTOR-LEN       TO WS-REQUIRED-CA-LEN

      *      if commarea received is not large enough ...
      *        set error return code and return to caller
             IF EIBCALEN IS LESS THAN WS-REQUIRED-CA-LEN
               MOVE '98' TO CA-RETURN-CODE IN DFHCOMMAREA-1
               EXEC CICS RETURN END-EXEC
             ELSE
      *        Length is sufficent so move data to commarea
      *        Move Integer fields to required length numerics
      *        Don't move null fields
               IF IND-BROKERID NOT EQUAL MINUS-ONE
                 MOVE DB2-BROKERID-INT TO DB2-BROKERID
               END-IF
               IF IND-PAYMENT NOT EQUAL MINUS-ONE
                 MOVE DB2-PAYMENT-INT    TO DB2-PAYMENT
               END-IF
               MOVE DB2-M-CC-SINT-1      TO DB2-M-CC
               MOVE DB2-M-VALUE-INT-1    TO DB2-M-VALUE
               MOVE DB2-M-PREMIUM-INT-1  TO DB2-M-PREMIUM
               MOVE DB2-M-ACCIDENTS-INT-2 TO DB2-M-ACCIDENTS
               MOVE DB2-M-PREMIUM-INT-1  TO CA-M-PREMIUM
               MOVE DB2-M-ACCIDENTS-INT-2 TO CA-M-ACCIDENTS
               MOVE DB2-POLICY-COMMON  TO CA-POLICY-COMMON
               MOVE DB2-MOTOR  TO CA-MOTOR(1:WS-MOTOR-LEN)
             END-IF

      *      Mark the end of the policy data
             MOVE 'FINAL' TO CA-M-FILLER(1:5)

           ELSE
      *      Non-zero SQLCODE IN SQLCA from first SQL FETCH statement
             IF SQLCODE IN SQLCA EQUAL 100
      *        No rows found - invalid customer / policy number
               MOVE '01' TO CA-RETURN-CODE IN DFHCOMMAREA-1
             ELSE
      *        something has gone wrong
               MOVE '90' TO CA-RETURN-CODE IN DFHCOMMAREA-1
      *        Write error message to TD QUEUE(CSMT)
               PERFORM WRITE-ERROR-MESSAGE-1
             END-IF

           END-IF.
           EXIT.

      * WRITE-ERROR-MESSAGE-1 RENAMED FROM WRITE-ERROR-MESSAGE
       WRITE-ERROR-MESSAGE-1.
      * Save SQLCODE IN SQLCA in message
           MOVE SQLCODE IN SQLCA TO EM-SQLRC-2
      * Obtain and format current time and date
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)
           END-EXEC
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)
                     MMDDYYYY(DATE1)
                     TIME(TIME1)
           END-EXEC
           MOVE DATE1 TO EM-DATE-1
           MOVE TIME1 TO EM-TIME-2
      * Write output message to TDQ
           EXEC CICS LINK PROGRAM('LGSTSQ')
                     COMMAREA(ERROR-MSG-1)
                     LENGTH(LENGTH OF ERROR-MSG-1)
           END-EXEC.
      * Write 90 bytes or as much as we have of commarea to TDQ
           IF EIBCALEN > 0 THEN
             IF EIBCALEN < 91 THEN
               MOVE DFHCOMMAREA-1(1:EIBCALEN) TO CA-DATA-1
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG-2)
                         LENGTH(LENGTH OF CA-ERROR-MSG-2)
               END-EXEC
             ELSE
               MOVE DFHCOMMAREA-1(1:90) TO CA-DATA-1
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG-2)
                         LENGTH(LENGTH OF CA-ERROR-MSG-2)
               END-EXEC
             END-IF
           END-IF.
           EXIT.

           EXIT PROGRAM.
