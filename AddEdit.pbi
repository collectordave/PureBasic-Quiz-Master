UsePNGImageDecoder()

DeclareModule AddEdit
  
  Declare Open()
  
EndDeclareModule

Module AddEdit
  
IncludeFile "DCTool.pbi"
   
Enumeration 100
  #WinAddEdit
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
  #txtCat
  #cmb01
  #spn1
  #cmb02
  #spn2
  #cmb03
  #spn3  
  #imgExit
  #imgHelp
  #imgAdd
  #imgEdit
  #imgDelete
  #imgOk
  #imgCancel
  #btnFirst
  #btnPrevious
  #btnNext
  #btnLast
  #Add
  #Edit
  #Idle
EndEnumeration

Global QuestionDB.i,QuestionID.i,CurrentRow.i,IconBarMain.i,IconBarEdit.i,TotalRows.i
Global Img_First.i,Img_Previous.i,Img_Next.i,Img_Last.i

CatchImage(#imgAdd,?ToolBarAdd)
CatchImage(#imgEdit,?ToolBarEdit)
CatchImage(#imgOk,?ToolBarOk)
CatchImage(#imgCancel,?ToolBarCancel)
CatchImage(#imgExit,?ToolBarExit)
CatchImage(#imgHelp,?ToolBarHelp)

Procedure AddQuestion()
  
  Define AddQuestion.s,AddAns0.s,AddAns1.s,AddAns2.s,AddAns3.s,Criteria.s
  Define AddCorrect.i
  
  If Len(Trim(GetGadgetText(#strQuestion))) > 0
    AddQuestion = GetGadgetText(#strQuestion)
  Else
    MessageRequester("Add Question","Must have a question to add",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  If Len(Trim(GetGadgetText(#strAnswer0))) > 0
    AddAns0 = GetGadgetText(#strAnswer0)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer1))) > 0
    AddAns1 = GetGadgetText(#strAnswer1)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer2))) > 0
    AddAns2 = GetGadgetText(#strAnswer2)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer3))) > 0
    AddAns3 = GetGadgetText(#strAnswer3)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf   
  If GetGadgetState(#optCA0) = #True
    Correct = 0
  EndIf
   If GetGadgetState(#optCA1) = #True
    Correct = 1
  EndIf 
    If GetGadgetState(#optCA2) = #True
    Correct = 2
  EndIf
    If GetGadgetState(#optCA3) = #True
    Correct = 3
  EndIf
  
  ;Add record To database
  Criteria = "INSERT INTO Questions (Question,Ans_0,Ans_1,Ans_2,Ans_3,Correct) VALUES ('" + AddQuestion + "','" + AddAns0 + "','" + AddAns1 + "','" + AddAns2 + "','" + AddAns3 + "'," + Str(Correct) + ");"
  DatabaseUpdate(QuestionDB, Criteria)     
  
  Criteria = "SELECT MAX(QU_ID) FROM Questions;"
  DatabaseQuery(QuestionDB, Criteria)
  FirstDatabaseRow(QuestionDB)
  QuestionID = GetDatabaseLong(QuestionDB,0)
  FinishDatabaseQuery(QuestionDB)
  
EndProcedure

Procedure SaveQuestion()
  
  Define AddQuestion.s,AddAns0.s,AddAns1.s,AddAns2.s,AddAns3.s,Criteria.s
  Define AddCorrect.i
  
  If Len(Trim(GetGadgetText(#strQuestion))) > 0
    AddQuestion = GetGadgetText(#strQuestion)
  Else
    MessageRequester("Add Question","Must have a question to add",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  If Len(Trim(GetGadgetText(#strAnswer0))) > 0
    AddAns0 = GetGadgetText(#strAnswer0)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer1))) > 0
    AddAns1 = GetGadgetText(#strAnswer1)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer2))) > 0
    AddAns2 = GetGadgetText(#strAnswer2)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  If Len(Trim(GetGadgetText(#strAnswer3))) > 0
    AddAns3 = GetGadgetText(#strAnswer3)
  Else
    MessageRequester("Add Question","Answer Missing",#PB_MessageRequester_Ok |#PB_MessageRequester_Error)
    ProcedureReturn
  EndIf   
  If GetGadgetState(#optCA0) = #True
    Correct = 0
  EndIf
   If GetGadgetState(#optCA1) = #True
    Correct = 1
  EndIf 
    If GetGadgetState(#optCA2) = #True
    Correct = 2
  EndIf
    If GetGadgetState(#optCA3) = #True
    Correct = 3
  EndIf
  
 Criteria = "UPDATE Questions SET " + 
             "Question = '" + ReplaceString(AddQuestion,"'","''") + 
             "',Ans_0='" + ReplaceString(AddAns0,"'","''") +  
             "',Ans_1='" + ReplaceString(AddAns1,"'","''") +             
             "',Ans_2='" + ReplaceString(AddAns2,"'","''") + 
             "',Ans_3='" + ReplaceString(AddAns3,"'","''") + 
             "',Correct=" + Str(Correct) + 
             " WHERE QU_ID=" +Str(QuestionID) + ";"

   DatabaseUpdate(QuestionDB,Criteria)
    
   ;Categories etc 
   Criteria = "DELETE FROM CatQD WHERE QU_ID = " + Str(QuestionID)
   DatabaseUpdate(QuestionDB,Criteria)
   
   If GetGadgetItemData(#cmb01,GetGadgetState(#cmb01)) > 0
     Criteria = "Insert INTO CatQD (QU_ID,Cat_ID,Diff) VALUES (" + Str(QuestionID) + "," + Str(GetGadgetItemData(#cmb01,GetGadgetState(#cmb01))) + "," + Str(GetGadgetState(#spn1)) + ")"
     DatabaseUpdate(QuestionDB,Criteria)
   EndIf
   If GetGadgetItemData(#cmb01,GetGadgetState(#cmb02)) > 0
     Criteria = "Insert INTO CatQD (QU_ID,Cat_ID,Diff) VALUES (" + Str(QuestionID) + "," + Str(GetGadgetItemData(#cmb02,GetGadgetState(#cmb02))) + "," + Str(GetGadgetState(#spn2)) + ")"
     DatabaseUpdate(QuestionDB,Criteria)
   EndIf  
   If GetGadgetItemData(#cmb01,GetGadgetState(#cmb03)) > 0     
     Criteria = "Insert INTO CatQD (QU_ID,Cat_ID,Diff) VALUES (" + Str(QuestionID) + "," + Str(GetGadgetItemData(#cmb03,GetGadgetState(#cmb03))) + "," + Str(GetGadgetState(#spn3)) + ")"
     DatabaseUpdate(QuestionDB,Criteria)
   EndIf
       
EndProcedure

Procedure OpenQuestionDB()
  
  QuestionDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Questions.s3db","","")   
  
EndProcedure

Procedure ShowQuestion()
  
  Define iLoop.i
  Define Criteria.s
  
  Criteria = "Select * FROM Questions ORDER BY Question ASC Limit 1 OFFSET " + Str(CurrentRow) + ";"

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
    SetGadgetText(#cmb01,"")
    SetGadgetState(#spn1,1)  
    SetGadgetText(#cmb02,"")
    SetGadgetState(#spn2,1)     
    SetGadgetText(#cmb03,"")
    SetGadgetState(#spn3,1)      
    
    Criteria = "Select *, Categories.Title FROM CatQD LEFT JOIN CATEGORIES ON Categories.Cat_ID = CatQD.Cat_ID  WHERE CatQD.QU_ID = " + Str(QuestionID) + ";"
    If DatabaseQuery(QuestionDB, Criteria)
      While NextDatabaseRow(QuestionDB)
        Select iLoop
          Case 0
            SetGadgetText(#cmb01,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title")))
            SetGadgetState(#spn1,GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff")))
          Case 1
            SetGadgetText(#cmb02,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title"))) 
            SetGadgetState(#spn2,GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff")))           
          Case 2
            SetGadgetText(#cmb03,GetDatabaseString(QuestionDB,DatabaseColumnIndex(QuestionDB,"Title")))          
            SetGadgetState(#spn3,GetDatabaseLong(QuestionDB,DatabaseColumnIndex(QuestionDB,"Diff")))           
        EndSelect
              
        iLoop = iLoop + 1 
      Wend
      FinishDatabaseQuery(QuestionDB) 
    EndIf

    
EndProcedure

Procedure LoadCategories()
  
  Define Criteria.s
  Define iLoop.i = 0

  Criteria = "Select * FROM Categories ORDER BY Title ASC;"
  
          AddGadgetItem(#cmb01,iLoop,"None")
          SetGadgetItemData(#cmb01, iLoop,0)
          AddGadgetItem(#cmb02,iLoop,"None")
          SetGadgetItemData(#cmb02, iLoop,0)
          AddGadgetItem(#cmb03,iLoop,"None")
          SetGadgetItemData(#cmb03, iLoop,0)
          iLoop = iLoop + 1         
    If DatabaseQuery(QuestionDB, Criteria)
    
      While NextDatabaseRow(QuestionDB) ; Loop for each records

          AddGadgetItem(#cmb01,iLoop,GetDatabaseString(QuestionDB, 1))
          SetGadgetItemData(#cmb01, iLoop,GetDatabaseLong(QuestionDB, 0))
          AddGadgetItem(#cmb02,iLoop,GetDatabaseString(QuestionDB, 1))
          SetGadgetItemData(#cmb02, iLoop,GetDatabaseLong(QuestionDB, 0))
          AddGadgetItem(#cmb03,iLoop,GetDatabaseString(QuestionDB, 1))
          SetGadgetItemData(#cmb03, iLoop,GetDatabaseLong(QuestionDB, 0))           
          iLoop = iLoop + 1
                  
      Wend
  
      FinishDatabaseQuery(QuestionDB)

    EndIf
  
EndProcedure

Procedure GetTotalRecords()
  
  Define iLoop.i
  Define SearchString.s
  
  ;Find out how many records will be returned
  TotalRows = 0
  SearchString = "SELECT * From Questions;"
  
  If DatabaseQuery(QuestionDB, SearchString)
    
    While NextDatabaseRow(QuestionDB)

      TotalRows = TotalRows + 1
      
    Wend
    
    FinishDatabaseQuery(QuestionDB)  

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

  SetGadgetText(#cmb01, "")
  SetGadgetState(#spn1,1)
  SetGadgetText(#cmb02, "")
  SetGadgetState(#spn2,1)
  SetGadgetText(#cmb03, "")
  SetGadgetState(#spn3,1)
  
  
  
EndProcedure

Procedure Open()
  
  Img_First = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_first.png")
  Img_Previous = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_previous.png")
  Img_Next = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_next.png")
  Img_Last = LoadImage(#PB_Any,GetCurrentDirectory() + "Resources\resultset_last.png")
  
  OpenWindow(#WinAddEdit, 0, 0, 600, 360, "Add\Edit Questions", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  
  IconBarMain = IconBarGadget(0, 0, WindowWidth(#WinAddEdit),32,#IconBar_Default,#WinAddEdit) 
  AddIconBarGadgetItem(IconBarMain, "Add", #imgAdd)
  AddIconBarGadgetItem(IconBarMain, "Edit", #imgEdit)
  AddIconBarGadgetItem(IconBarMain, "Exit", #imgExit) 
  IconBarGadgetSpacer(IconBarMain)
  AddIconBarGadgetItem(IconBarMain, "Help", #imgHelp)
  ResizeIconBarGadget(IconBarMain, #PB_Ignore, #IconBar_Auto)  
  SetIconBarGadgetColor(IconBarMain, 1, RGB(176,224,230))
  
  IconBarEdit = IconBarGadget(0, 0, WindowWidth(#WinAddEdit),32,#IconBar_Default,#WinAddEdit) 
  AddIconBarGadgetItem(IconBarEdit, "Ok", #imgOk)
  AddIconBarGadgetItem(IconBarEdit, "Cancel", #imgCancel)
  ResizeIconBarGadget(IconBarEdit, #PB_Ignore, #IconBar_Auto)  
  SetIconBarGadgetColor(IconBarEdit, 1, RGB(176,224,230))
  HideIconBarGadget(IconBarEdit, #True)
  
  TextGadget(#txtQuestion, 10, 45, 130, 20, "Question")
  StringGadget(#strQuestion, 10, 70, 560, 20, "")
  TextGadget(#txtAnswers, 10, 100, 130, 20, "Answers")
  TextGadget(#txtCorrect, 510, 100, 50, 20, "Correct") 
  StringGadget(#strAnswer0, 30, 130, 480, 20, "")
  TextGadget(#txtA0, 10, 130, 20, 20, "1")
  StringGadget(#strAnswer1, 30, 160, 480, 20, "")
  TextGadget(#txtA1, 10, 160, 20, 20, "2")
  StringGadget(#strAnswer2, 30, 190, 480, 20, "")
  TextGadget(#txtA2, 10, 190, 20, 20, "3")
  StringGadget(#strAnswer3, 30, 220, 480, 20, "")
  TextGadget(#txtA3, 10, 220, 20, 20, "4")
  ContainerGadget(#cntAnswer, 520, 120, 30, 160)
  OptionGadget(#optCA0, 10, 10, 20, 20, "") 
  OptionGadget(#optCA1, 10, 40, 20, 20, "")  
  OptionGadget(#optCA2, 10, 70, 20, 20, "") 
  OptionGadget(#optCA3, 10, 100, 20, 20, "")
  CloseGadgetList()
  TextGadget(#txtCat, 20, 260, 150, 20, "Category And Difficulty")
  ComboBoxGadget(#cmb01, 20, 290, 130, 20)
  SpinGadget(#spn1, 160, 290, 40, 20, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
  SetGadgetState(#spn1,1)
  ComboBoxGadget(#cmb02, 210, 290, 130, 20)
  SpinGadget(#spn2, 350, 290, 40, 20, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
  SetGadgetState(#spn2,1)
  ComboBoxGadget(#cmb03, 400, 290, 130, 20)
  SpinGadget(#spn3, 540, 290, 40, 20, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
  SetGadgetState(#spn3,1)
  ButtonImageGadget(#btnFirst, 0, 328, 32, 32, ImageID(Img_First))
  ButtonImageGadget(#btnPrevious, 32, 328, 32, 32, ImageID(Img_Previous))
  ButtonImageGadget(#btnNext, 536, 328, 32, 32, ImageID(Img_Next))
  ButtonImageGadget(#btnLast, 568, 328, 32, 32, ImageID(Img_Last))
  
  OpenQuestionDB()
  LoadCategories()
  CurrentRow = 0
  GetTotalRecords()
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
           
       Case IconBarMain ;Toolbar event
             
          Select EventData() ;For each button on toolbar
              
            Case 0

              ;Add New Question
              Mode = #Add
              ClearGadgets()
              HideIconBarGadget(IconBarEdit, #False)
              HideIconBarGadget(IconBarMain, #True)
              
            Case 1
              
              ;Edit Current Question
              Mode = #Edit
              HideIconBarGadget(IconBarEdit, #False)
              HideIconBarGadget(IconBarMain, #True)
              
            Case 2
              
              CloseWindow(#WinAddEdit)
              Quit = #True
              
            Case 3
              
              ;Help"
              
          EndSelect          
          
        Case IconBarEdit ;Toolbar event
             
          Select EventData() ;For each button on toolbar         
              
            Case 0
              
              If Mode = #Add
                AddQuestion()
              Else
                SaveQuestion()
              EndIf
              
              HideIconBarGadget(IconBarEdit, #True)
              HideIconBarGadget(IconBarMain, #False)             
              Mode = #Idle
              
            Case 1

              Mode = #Idle
              HideIconBarGadget(IconBarEdit, #True)
              HideIconBarGadget(IconBarMain, #False) 
              
          EndSelect
          
      EndSelect
      
  EndSelect
  
Until Quit = #True

EndProcedure

DataSection
  ToolBarAdd:
    IncludeBinary "Resources\textfield_add.png"
  ToolBarEdit:
    IncludeBinary "Resources\textfield_Edit.png" 
  ToolBarDelete:
    IncludeBinary "Resources\textfield_delete.png"   
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
; CursorPosition = 522
; FirstLine = 213
; Folding = Dw
; EnableXP