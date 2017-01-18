UsePNGImageDecoder()
UseSQLiteDatabase()
   
Enumeration 100
  #WinQuiz
  #cntAnswer
  #txtQuestion
  #strQuestion
  #txtAnswers
  #strAnswer0
  #txtA0
  #optCA0
  #txtCorrect
  #strAnswer1
  #txtA1
  #optCA1
  #strAnswer2
  #txtA2
  #optCA2
  #strAnswer3
  #txtA3
  #optCA3
  #btnPrevious
  #btnNext
EndEnumeration

Global QuizDB.i,QuizTitle.s,QuizID.i,CurrentQuestion.i
Global Dim QuestionIDs.i(0)

Global QuestionDB.i,QuestionID.i,CurrentRow.i,IconBarMain.i,IconBarEdit.i,TotalRows.i
Global Img_Previous.i,Img_Next.i

Procedure OpenQuizDB()

  QuizDB =  OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Quizes.s3db","","")    
  
EndProcedure

Procedure OpenQuestionDB()
  
  QuestionDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Questions.s3db","","")   
  
EndProcedure

Procedure ShowQuestion()
  
  Define iLoop.i
  Define Criteria.s

  Criteria = "Select * FROM Questions WHERE QU_ID =  " + Str(QuestionIDs(CurrentQuestion)) + ";"

    If DatabaseQuery(QuestionDB, Criteria)
      FirstDatabaseRow(QuestionDB)
      QuestionID = GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"QU_ID"))
      SetGadgetText(#strQuestion,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Question")))
      SetGadgetText(#strAnswer0,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_0")))
      SetGadgetText(#strAnswer1,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_1")))      
      SetGadgetText(#strAnswer2,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_2")))      
      SetGadgetText(#strAnswer3,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_3")))     
      
      FinishDatabaseQuery(QuestionDB) 

    EndIf
       
EndProcedure

Procedure GetTotalRecords()
  
  Define iLoop.i
  Define SearchString.s
  
  ;Find out how many records will be returned
  TotalRows = 0
  SearchString = "SELECT * From Questions WHERE Quiz_ID = " + Str(QuizID) + ";"
  
  If DatabaseQuery(QuizDB, SearchString)
    
    While NextDatabaseRow(QuizDB)
      QuestionIDs(TotalRows) = GetDatabaseLong(QuizDB,1)
      TotalRows = TotalRows + 1
      ReDim QuestionIDs(TotalRows)
    Wend
    
    FinishDatabaseQuery(QuizDB)  

  EndIf

EndProcedure

Procedure Cleargadgets()

  SetGadgetText(#strQuestion,"")

  SetGadgetText(#strAnswer0,"")
  SetGadgetText(#strAnswer1,"")
  SetGadgetText(#strAnswer2,"")
  SetGadgetText(#strAnswer3,"")
  SetGadgetState(#optCA0, #False) 
  SetGadgetState(#optCA1,#False)  
  SetGadgetState(#optCA2,#False) 
  SetGadgetState(#optCA3,#False)

EndProcedure

OpenPreferences(GetCurrentDirectory() + "TakeQuiz.quz")

  PreferenceGroup("Quiz")
    QuizID = ReadPreferenceLong ("ID", 0) 
    QuizTitle = ReadPreferenceString("Title", "None")
ClosePreferences()

  Img_Previous = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_previous.png")
  Img_Next = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_next.png")
  
  OpenWindow(#WinQuiz, 0, 0, 600, 252, QuizTitle, #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  
  TextGadget(#txtQuestion, 10, 15, 130, 20, "Question")
  StringGadget(#strQuestion, 10, 40, 560, 20, "")
  TextGadget(#txtAnswers, 10, 70, 130, 20, "Answers")
  TextGadget(#txtCorrect, 510, 70, 50, 20, "Correct") 
  StringGadget(#strAnswer0, 30, 100, 480, 20, "")
  TextGadget(#txtA0, 10, 100, 20, 20, "1")
  StringGadget(#strAnswer1, 30, 130, 480, 20, "")
  TextGadget(#txtA1, 10, 130, 20, 20, "2")
  StringGadget(#strAnswer2, 30, 160, 480, 20, "")
  TextGadget(#txtA2, 10, 160, 20, 20, "3")
  StringGadget(#strAnswer3, 30, 190, 480, 20, "")
  TextGadget(#txtA3, 10, 190, 20, 20, "4")
  ContainerGadget(#cntAnswer, 520, 90, 30, 160)
  OptionGadget(#optCA0, 10, 10, 20, 20, "") 
  OptionGadget(#optCA1, 10, 40, 20, 20, "")  
  OptionGadget(#optCA2, 10, 70, 20, 20, "") 
  OptionGadget(#optCA3, 10, 100, 20, 20, "")
  CloseGadgetList()
  ButtonImageGadget(#btnPrevious, 0, 220, 32, 32, ImageID(Img_Previous))
  GadgetToolTip(#btnPrevious, "Previous Question")
  ButtonImageGadget(#btnNext, 568, 220, 32, 32, ImageID(Img_Next))
  GadgetToolTip(#btnNext, "Next Question")  
  
  OpenQuizDB()
  GetTotalRecords()  
  
  OpenQuestionDB()
  CurrentQuestion = 0
  Cleargadgets()
  ShowQuestion()
  
Quit = #False
Repeat
  Event = WaitWindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      CloseWindow(#WinQuiz)
      Quit = #True

    Case #PB_Event_Gadget
      Select EventGadget()
           
        Case #btnNext
          
          If CurrentQuestion < TotalRows - 1
            CurrentQuestion = CurrentQuestion + 1
            Cleargadgets()
            ShowQuestion()  
          EndIf
        
        Case #btnPrevious
          
          If CurrentQuestion > 0
            CurrentQuestion = CurrentQuestion - 1  
            Cleargadgets()
            ShowQuestion() 
          EndIf
          
      EndSelect
      
  EndSelect
  
Until Quit = #True
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 152
; FirstLine = 75
; Folding = g
; EnableXP