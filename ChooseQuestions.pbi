UsePNGImageDecoder()

DeclareModule ChooseQuestions
  
  Declare Open(QuizID.i,CatID.i,Diff.i)
  
EndDeclareModule

Module ChooseQuestions
  
 IncludeFile "DCTool.pbi" 
  
Enumeration 200
  #WinAddEdit
  #cntAnswer
  #txtQuestion
  #chkSelected
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
  #txtCat
  #strCat01
  #strDiff01
  #strCat02
  #strDiff02
  #strCat03
  #strDiff03
  #btnFirst
  #btnPrevious
  #btnNext
  #btnLast 
  #imgHelp
  #imgOk
  #imgCancel 
  #imgExit 
EndEnumeration

Structure Question
  QU_ID.i
  Selected.i
EndStructure

Global Dim SelectedQuestions.Question(0)

Global QuestionDB.i,CurrentRow.i,TotalRows.i,IconBarMain.i

CatchImage(#imgOk,?ToolBarOk)
CatchImage(#imgCancel,?ToolBarCancel)
CatchImage(#imgExit,?ToolBarExit)
CatchImage(#imgHelp,?ToolBarHelp)

Procedure OpenQuestionDB()
  
  QuestionDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Questions.s3db","","")   
  
EndProcedure

Procedure ShowQuestion()
  
  Define iLoop.i
  Define Criteria.s
  
  Criteria = "Select * FROM Questions WHERE QU_ID = " + Str(SelectedQuestions(CurrentRow)\QU_ID) + ";"

    If DatabaseQuery(QuestionDB, Criteria)
      FirstDatabaseRow(QuestionDB)
      QuestionID = GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"QU_ID"))
      SetGadgetText(#strQuestion,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Question")))
      SetGadgetText(#strAnswer0,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_0")))
      SetGadgetText(#strAnswer1,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_1")))      
      SetGadgetText(#strAnswer2,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_2")))      
      SetGadgetText(#strAnswer3,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Ans_3")))     
      Select GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Correct"))
        Case 0
          SetGadgetState(#optCA0,#True)
        Case 1
          SetGadgetState(#optCA1,#True)
        Case 2
          SetGadgetState(#optCA2,#True)
        Case 3
          SetGadgetState(#optCA3,#True)
      EndSelect
      
      FinishDatabaseQuery(QuestionDB) 

    EndIf
      
    ;Categories and difficulty
    iLoop = 0
    SetGadgetText(#strCat01,"")
    SetGadgetText(#strDiff01,"")  
    SetGadgetText(#strCat02,"")
    SetGadgetText(#strDiff02,"")      
    SetGadgetText(#strCat03,"")
    SetGadgetText(#strDiff03,"")     
    
    Criteria = "Select *, Categories.Title FROM CatQD LEFT JOIN CATEGORIES ON Categories.Cat_ID = CatQD.Cat_ID  WHERE CatQD.QU_ID = " + Str(QuestionID) + ";"
    If DatabaseQuery(QuestionDB, Criteria)
      While NextDatabaseRow(QuestionDB)
        Select iLoop
          Case 0
            SetGadgetText(#strCat01,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title")))
            SetGadgetText(#strDiff01,Str(GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff"))))
          Case 1
            SetGadgetText(#strCat02,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title")))           
            SetGadgetText(#strDiff02,Str(GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff"))))           
          Case 2
            SetGadgetText(#strCat03,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title")))          
            SetGadgetText(#strDiff03,Str(GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff"))))          
        EndSelect
        iLoop = iLoop + 1 
      Wend
      FinishDatabaseQuery(QuestionDB) 
    EndIf
    
    ;Selected?
    If SelectedQuestions(CurrentRow)\Selected = #True
      SetGadgetState(#chkSelected,#True)
    Else
      SetGadgetState(#chkSelected,#False)     
    EndIf
    
EndProcedure

Procedure SaveQuestions(QuizID.i)
  
  Define iLoop.i
  Define Criteria.s
  
  QuizDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Quizes.s3db","","")   
  Criteria = "DELETE FROM Questions WHERE Quiz_ID = " + Str(QuizID)
  DatabaseUpdate(QuizDB,Criteria)
  
  For iLoop = 0 To ArraySize(SelectedQuestions())
    If SelectedQuestions(iLoop)\Selected = #True
      Criteria = "INSERT INTO Questions (Quiz_ID,Question_ID) VALUES (" + Str(QuizID) + "," + Str(SelectedQuestions(iLoop)\QU_ID) + ")"
      DatabaseUpdate(QuizDB,Criteria)
    EndIf
  Next iLoop
  
  CloseDatabase(QuizDB)
  
EndProcedure

Procedure GetTotalRecords(QuizID.i,CatID.i,Diff.i)
  
  Define iLoop.i,QuizDB.i,ThisQuestion.i
  Define Criteria.s
  
  ;Find all possible questions
  iLoop = 0
  Criteria = "Select * FROM CatQD WHERE Cat_ID = " + Str(CatID) + " And Diff = " + Str(Diff)
  
  If DatabaseQuery(QuestionDB, Criteria)
    
    While NextDatabaseRow(QuestionDB)
      SelectedQuestions(iLoop)\QU_ID = GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"QU_ID"))
      iLoop = iLoop + 1
      ReDim SelectedQuestions(iLoop)
    Wend
    
    FinishDatabaseQuery(QuestionDB)  

  EndIf
  TotalRows = iLoop - 1
  
  ;Match to questions allready selected
  QuizDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Quizes.s3db","","")   
  Criteria = "SELECT * FROM Questions WHERE Quiz_ID = " + Str(QuizID)
   If DatabaseQuery(QuizDB, Criteria)
    
    While NextDatabaseRow(QuizDB)
      
      ThisQuestion = GetDatabaseLong(QuizDB,DatabaseColumnIndex(QuizDB,"Question_ID"))
      For iLoop = 0 To ArraySize(SelectedQuestions())
        If ThisQuestion = SelectedQuestions(iLoop)\QU_ID
          SelectedQuestions(iLoop)\Selected = #True
          Break
        EndIf
        Next iLoop
    Wend
    
    FinishDatabaseQuery(QuizDB)  

  EndIf 
   
EndProcedure

Procedure CheckRecords()
  
  ;Sort out the navigation buttons
  If TotalRows < 2
    
    ;Only one record so it is the first and the last
    DisableGadget(#btnLast, #True)     ;No move last as allready there
    DisableGadget(#btnNext, #True)     ;No next record as this is the last record
    DisableGadget(#btnFirst, #True)    ;No first record as this is the first record
    DisableGadget(#btnPrevious, #True) ;No previous record as this is the first record
    
  ElseIf CurrentRow = 0
    ;On the first row with more than one selected
    DisableGadget(#btnLast, #False)     ;Can move to last record
    DisableGadget(#btnNext, #False)     ;Can move to next record
    DisableGadget(#btnFirst, #True)    ;No first record as this is the first record
    DisableGadget(#btnPrevious, #True) ;No previous record as this is the first record
    
  ElseIf  CurrentRow = TotalRows - 1
    
    ;If on the last record
    DisableGadget(#btnLast, #True)     ;No move last as allready there
    DisableGadget(#btnNext, #True)     ;No next record as this is the last record
    DisableGadget(#btnFirst, #False)    ;Can still move to first record
    DisableGadget(#btnPrevious, #False) ;Can still move to previous record
    
  Else
    
    ;Somewhere in the middle of the selected records
    DisableGadget(#btnLast, #False)     ;Can move to last record
    DisableGadget(#btnNext, #False)     ;Can move to next record
    DisableGadget(#btnFirst, #False)    ;Can move to first record
    DisableGadget(#btnPrevious, #False) ;Can move to previous record
    
  EndIf

EndProcedure

Procedure Open(QuizID.i,CatID.i,Diff.i)
  
  Img_First = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_first.png")
  Img_Previous = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_previous.png")
  Img_Next = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_next.png")
  Img_Last = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_last.png")
  
  OpenWindow(#WinAddEdit, 0, 0, 600, 370, "Select Questions", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  IconBarMain = IconBarGadget(0, 0, WindowWidth(#WinAddEdit),32,#IconBar_Default,#WinAddEdit) 
  AddIconBarGadgetItem(IconBarMain, "Save Changes", #imgOk)
  AddIconBarGadgetItem(IconBarMain, "Cancel", #imgCancel)
  AddIconBarGadgetItem(IconBarMain, "Exit", #imgExit)
  IconBarGadgetSpacer(IconBarMain)
  AddIconBarGadgetItem(IconBarMain, "Help", #imgHelp)
  ResizeIconBarGadget(IconBarMain, #PB_Ignore, #IconBar_Auto)  
  SetIconBarGadgetColor(IconBarMain, 1, RGB(176,224,230)) 
  
  TextGadget(#txtQuestion, 10, 45, 130, 20, "Question")
  CheckBoxGadget(#chkSelected, 390, 45, 230, 20, "Selected")
  StringGadget(#strQuestion, 10, 70, 560, 20, "")
  TextGadget(#txtAnswers, 10, 100, 130, 20, "Answers")
  StringGadget(#strAnswer0, 30, 130, 480, 20, "")
  TextGadget(#txtA0, 10, 130, 20, 20, "1")
  TextGadget(#txtCorrect, 510, 100, 50, 20, "Correct")
  StringGadget(#strAnswer1, 30, 160, 480, 20, "")
  TextGadget(#txtA1, 10, 160, 20, 20, "2")
  StringGadget(#strAnswer2, 30, 190, 480, 20, "")
  TextGadget(#txtA2, 10, 190, 20, 20, "3")
  StringGadget(#strAnswer3, 30, 220, 480, 20, "")
  TextGadget(#txtA3, 10, 220, 20, 20, "4")
  ContainerGadget(#cntAnswer, 520, 120, 30, 200)
    OptionGadget(#optCA0, 10, 10, 20, 20, "") 
    OptionGadget(#optCA1, 10, 40, 20, 20, "")  
    OptionGadget(#optCA2, 10, 70, 20, 20, "") 
    OptionGadget(#optCA3, 10, 100, 20, 20, "")
  CloseGadgetList()
  TextGadget(#txtCat, 20, 270, 150, 20, "Category And Difficulty")
  StringGadget(#strCat01, 20, 300, 130, 20,"")
  StringGadget(#strDiff01, 160, 300, 40, 20,"")
  StringGadget(#strCat02, 210, 300, 130, 20,"")
  StringGadget(#strDiff02, 350, 300, 40, 20,"")
  StringGadget(#strCat03, 400, 300, 130, 20,"")
  StringGadget(#strDiff03, 540, 300, 40, 20,"")
  ButtonImageGadget(#btnFirst, 0, 338, 32, 32, ImageID(Img_First))
  ButtonImageGadget(#btnPrevious, 32, 338, 32, 32, ImageID(Img_Previous))
  ButtonImageGadget(#btnNext, 536, 338, 32, 32, ImageID(Img_Next))
  ButtonImageGadget(#btnLast, 568, 338, 32, 32, ImageID(Img_Last))

  OpenQuestionDB()
  CurrentRow = 0
  GetTotalRecords(QuizID,CatID,Diff)
  CheckRecords()
  ShowQuestion()

Quit = #False
Repeat
  Event = WaitWindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      CloseWindow(#WinAddEdit)
      Quit = #True
      
    Case #PB_Event_Menu
      Select EventMenu()

      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #btnFirst
          
          CurrentRow = 0
          CheckRecords()
          ShowQuestion()
           
        Case #btnNext
           
          CurrentRow = CurrentRow + 1
          CheckRecords()
          ShowQuestion()  
           
        Case #btnPrevious
           
          If CurrentRow > 0
            CurrentRow = CurrentRow - 1  
            CheckRecords()        
            ShowQuestion() 
          EndIf
           
        Case #btnLast
           
          CurrentRow = TotalRows - 1
          CheckRecords()
          ShowQuestion() 
          
        Case #chkSelected
          
          If GetGadgetState(#chkSelected) = #True
            SelectedQuestions(CurrentRow)\Selected = #True
          Else
            SelectedQuestions(CurrentRow)\Selected = #False            
          EndIf
          
        Case IconBarMain ;Toolbar event
             
          Select EventData() ;For each button on toolbar
              
            Case 0

              SaveQuestions(QuizID)
               CloseWindow(#WinAddEdit)
               Quit = #True
               
            Case 1

              CloseWindow(#WinAddEdit)
              Quit = #True
               
            Case 2
              
              ;Same as cancel
              CloseWindow(#WinAddEdit)
              Quit = #True
              
            Case 3
              
              ;Help"
              
          EndSelect        
   
      EndSelect
      
  EndSelect
  
Until Quit = #True

EndProcedure

DataSection
  ToolBarOk:
    IncludeBinary "Resources\Ok.png"
  ToolBarCancel:
    IncludeBinary "Resources\Cancel.png" 
  ToolBarExit:
    IncludeBinary "Resources\Exit.png"  
  ToolBarHelp:
    IncludeBinary "Resources\Help.png"    
 EndDataSection

EndModule
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 365
; FirstLine = 197
; Folding = D+
; EnableXP