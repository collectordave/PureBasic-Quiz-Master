UsePNGImageDecoder()
UseSQLiteDatabase()

IncludeFile "DCTool.pbi"
IncludeFile "ChooseQuestions.pbi" 
IncludeFile "AddEdit.pbi"

Enumeration 
  #WinMain
  #txtTitle
  #cmbTitle
  #strTitle
  #txtCategory
  #txtDifficulty
  #spnDifficulty
  #btnQuestions
  #cmbCategory
  #Show
  #Edit
  #Add
  #imgAdd
  #imgEdit
  #imgDelete
  #imgEditQuestions
  #imgExit
  #imgHelp
  #imgOk
  #imgCancel
  #imgSet
EndEnumeration

Global QuizDB.i,QuestionDB.i,QuizID.i,Mode.i,IconBarMain.i,IconBarEdit.i
Global TotalRecords.i,CurrentCategory.i,CurrentDifficulty.i

CatchImage(#imgAdd,?ToolBarAdd)
CatchImage(#imgEdit,?ToolBarEdit)
CatchImage(#imgDelete,?ToolBarDelete)
CatchImage(#imgEditQuestions,?ToolBareditQ)
CatchImage(#imgOk,?ToolBarOk)
CatchImage(#imgCancel,?ToolBarCancel)
CatchImage(#imgExit,?ToolBarExit)
CatchImage(#imgHelp,?ToolBarHelp)
CatchImage(#imgSet,?ToolBarSet)

Mode = #Show

Procedure ShowFormtexts()
  
  SetWindowTitle(#WinMain,"Quiz Master")
  SetIconBarGadgetItemText(IconBarMain,"New Quiz",0,#IconBarText_ToolTip)
  SetIconBarGadgetItemText(IconBarMain,"Edit Quiz",1,#IconBarText_ToolTip) 
  SetIconBarGadgetItemText(IconBarMain,"Delete Quiz",2,#IconBarText_ToolTip) 
  SetIconBarGadgetItemText(IconBarMain,"Edit Questions",3,#IconBarText_ToolTip)  
  SetIconBarGadgetItemText(IconBarMain,"Set Quiz",4,#IconBarText_ToolTip)  
  SetIconBarGadgetItemText(IconBarMain,"Exit",5,#IconBarText_ToolTip)  
  SetIconBarGadgetItemText(IconBarMain,"Help",6,#IconBarText_ToolTip)   
  SetIconBarGadgetItemText(IconBarEdit,"Ok",0,#IconBarText_ToolTip)  
  SetIconBarGadgetItemText(IconBarEdit,"Cancel",1,#IconBarText_ToolTip) 
  SetGadgetText(#txtTitle,"Title")
  SetGadgetText(#txtCategory,"Category")
  SetGadgetText(#txtDifficulty,"Difficulty")
  SetGadgetText(#btnQuestions,"Questions")
  
EndProcedure

Procedure OpenQuizDB()

  QuizDB =  OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Quizes.s3db","","")    
  
EndProcedure

Procedure OpenQuestionDB()
  
  QuestionDB = OpenDatabase(#PB_Any, GetCurrentDirectory() + "Quizes\Questions.s3db","","")   
  
EndProcedure

Procedure LoadQuizes()
  
  Define Criteria.s
  Define iLoop.i = 0
  
  Criteria = "Select * FROM Quizes ORDER BY Title ASC;"
  
  If DatabaseQuery(QuizDB, Criteria)
      
    ClearGadgetItems(#cmbTitle)
    While NextDatabaseRow(QuizDB) ; Loop for each records
      
      If GetDatabaseString(QuizDB, 1) <> "Default"
          
        AddGadgetItem(#cmbTitle,iLoop,GetDatabaseString(QuizDB, 1))
        SetGadgetItemData(#cmbTitle, iLoop,GetDatabaseLong(QuizDB, 0))
        iLoop = iLoop + 1
          
      EndIf
        
    Wend
  
    FinishDatabaseQuery(QuizDB)
    
  EndIf
    
EndProcedure

Procedure ShowQuiz()
  
  Define Criteria.s
  
  Criteria = "SELECT * FROM Quizes WHERE Quiz_ID = " + Str(QuizID) + ";"
  
  If DatabaseQuery(QuizDB, Criteria)
    
    If FirstDatabaseRow(QuizDB)
      
      CurrentCategory = GetDatabaseLong(QuizDB,3)    
      CurrentDifficulty = GetDatabaseLong(QuizDB,2)
      SetGadgetState(#spnDifficulty,CurrentDifficulty)
      
    EndIf
    
    FinishDatabaseQuery(QuizDB)
    
  EndIf
  
  OpenQuestionDB()
  
  Criteria = "SELECT * FROM Categories WHERE Cat_ID = " + Str(CurrentCategory) + ";"
  
  If DatabaseQuery(QuestionDB, Criteria)
    
    If FirstDatabaseRow(QuestionDB)
      
      SetGadgetText(#cmbCategory,GetDatabaseString(QuestionDB,1))

    EndIf
    
    FinishDatabaseQuery(QuestionDB)
    
  EndIf 
  
EndProcedure

Procedure SaveQuiz()
  
  Define CatID.i,Difficulty.i
  Define Criteria.s,QuizTitle.s
  QuizTitle = GetGadgetText(#strTitle)
  CatID = GetGadgetItemData(#cmbCategory,GetGadgetState(#cmbCategory))
  Difficulty = GetGadgetState(#spnDifficulty)
  If Mode = #Edit
    Criteria = "UPDATE Quizes SET Title = '" + QuizTitle + "', Cat_ID = " + Str(CatID) + ", Difficulty = " + Str(Difficulty) + " WHERE Quiz_ID = " + Str(QuizID)
  Else
    Criteria = "INSERT INTO Quizes (Title,Cat_ID,Difficulty) Values ('" + QuizTitle + "'," + Str(CatID) + "," + Str(Difficulty) + ")"
  EndIf
  DatabaseUpdate(QuizDB,Criteria) 
  LoadQuizes()
  SetGadgetState(#cmbTitle,0)
  QuizID = GetGadgetItemData(#cmbTitle,GetGadgetState(#cmbTitle))
  
EndProcedure

Procedure LoadCategories()
  
  Define Criteria.s
  Define iLoop.i = 0

  OpenQuestionDB()
  Criteria = "Select * FROM Categories ORDER BY Title ASC;"

    If DatabaseQuery(QuestionDB, Criteria)
    
      While NextDatabaseRow(QuestionDB) ; Loop for each records

          AddGadgetItem(#cmbCategory,iLoop,GetDatabaseString(QuestionDB, 1))
          SetGadgetItemData(#cmbCategory, iLoop,GetDatabaseLong(QuestionDB, 0))
          iLoop = iLoop + 1
                  
      Wend
  
      FinishDatabaseQuery(QuestionDB)

    EndIf
  
EndProcedure

Procedure SetQuiz()
  
  Define QuizTitle.s
  
  QuizTitle = GetGadgetText(#cmbTitle)

  CreatePreferences(GetCurrentDirectory() + "TakeQuiz.quz")

  PreferenceGroup("Quiz")
  WritePreferenceString("Title", QuizTitle)
  WritePreferenceLong ("ID", QuizID) 
  ClosePreferences()
    
  EndProcedure
  
OpenWindow(#WinMain, 0, 0, 320, 160, "Quiz Master", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
IconBarMain = IconBarGadget(0, 0, WindowWidth(#WinMain),32,#IconBar_Default,#WinMain) 
AddIconBarGadgetItem(IconBarMain, "New Quiz", #imgAdd)
AddIconBarGadgetItem(IconBarMain, "Edit Quiz", #imgEdit)
AddIconBarGadgetItem(IconBarMain, "Delete Quiz", #imgDelete)
AddIconBarGadgetItem(IconBarMain, "Edit Questions", #imgEditQuestions)
AddIconBarGadgetItem(IconBarMain, "Set Quiz", #imgSet)
AddIconBarGadgetItem(IconBarMain, "Exit", #imgExit)
IconBarGadgetSpacer(IconBarMain)
AddIconBarGadgetItem(IconBarMain, "Help", #imgHelp)
ResizeIconBarGadget(IconBarMain, #PB_Ignore, #IconBar_Auto)  
SetIconBarGadgetColor(IconBarMain, 1, RGB(176,224,230))
IconBarEdit = IconBarGadget(0, 0, WindowWidth(#WinMain),32,#IconBar_Default,#WinMain) 
AddIconBarGadgetItem(IconBarEdit, "Ok", #imgOk)
AddIconBarGadgetItem(IconBarEdit, "Cancel", #imgCancel)
ResizeIconBarGadget(IconBarEdit, #PB_Ignore, #IconBar_Auto)  
SetIconBarGadgetColor(IconBarEdit, 1, RGB(176,224,230))
HideIconBarGadget(IconBarEdit, #True)
TextGadget(#txtTitle, 10, 50, 70, 20, "Title")
ComboBoxGadget(#cmbTitle, 10, 70, 300, 20)
StringGadget(#strTitle, 10, 70, 300, 20,"")
HideGadget(#strTitle,#True)
TextGadget(#txtCategory, 10, 100, 60, 20, "Category")
ComboBoxGadget(#cmbCategory, 10, 130, 150, 20)
TextGadget(#txtDifficulty, 170, 100, 50, 20, "Difficulty")
SpinGadget(#spnDifficulty, 170, 130, 40, 20, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
ButtonGadget(#btnQuestions, 220, 130, 90, 20, "Questions")

ShowFormtexts()
SetGadgetState(#spnDifficulty,1)
DisableGadget(#cmbCategory,#True)
DisableGadget(#spnDifficulty,#True)
DisableGadget(#btnQuestions,#True)
OpenQuizDB()
LoadQuizes()
LoadCategories()
SetGadgetState(#cmbTitle,0)
QuizID = GetGadgetItemData(#cmbTitle,GetGadgetState(#cmbTitle))
ShowQuiz()

Repeat
  
  Event = WaitWindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      End

    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      
      Select EventGadget()
          
        Case #cmbTitle
          
          ;Current Quiz Changed Show New Quiz
          QuizID = GetGadgetItemData(#cmbTitle,GetGadgetState(#cmbTitle))  
          ShowQuiz()
          
        Case #cmbCategory
          
          CurrentCategory = GetGadgetItemData(#cmbCategory,GetGadgetState(#cmbCategory))
          
        Case #btnQuestions 
          
          ChooseQuestions::Open(QuizID,CurrentCategory,CurrentDifficulty)
          
        Case #spnDifficulty
          
          CurrentDifficulty = GetGadgetState(#spnDifficulty)
          
        Case IconBarMain ;Toolbar event
             
          Select EventData() ;For each button on toolbar
              
            Case 0

              ;Add New Quiz
              Mode = #Add
              HideIconBarGadget(IconBarEdit, #False)
              HideIconBarGadget(IconBarMain, #True)
              HideGadget(#cmbTitle,#True)
              SetGadgetText(#strTitle,"")
              HideGadget(#strTitle,#False)             
              DisableGadget(#cmbCategory,#False)
              DisableGadget(#spnDifficulty,#False)
              DisableGadget(#btnQuestions,#True) 
              
            Case 1

              ;Edit Current Quiz
              Mode = #Edit
              HideIconBarGadget(IconBarEdit, #False)
              HideIconBarGadget(IconBarMain, #True)
              HideGadget(#cmbTitle,#True)
              SetGadgetText(#strTitle,GetGadgetText(#cmbTitle))
              HideGadget(#strTitle,#False)             
              DisableGadget(#cmbCategory,#False)
              DisableGadget(#spnDifficulty,#False)
              DisableGadget(#btnQuestions,#False)
              
            Case 2
              
              ;Delete Current Quiz
              
            Case 3
              
              ;Edit Questions
              AddEdit::Open()
              
            Case 4 

              SetQuiz()
             
            Case 5

              End
              
            Case 6

              ;Show Help             
              
          EndSelect            
          
        Case IconBarEdit ;Toolbar event
             
          Select EventData() ;For each button on toolbar
              
            Case 0

              ;Ok clicked
              SaveQuiz()
              Mode = #Show
              HideIconBarGadget(IconBarEdit, #True)
              HideIconBarGadget(IconBarMain, #False)
              HideGadget(#cmbTitle,#False)
              HideGadget(#strTitle,#True)             
              DisableGadget(#cmbTitle,#False)
              DisableGadget(#cmbCategory,#True)
              DisableGadget(#spnDifficulty,#True)
              DisableGadget(#btnQuestions,#True)        
              ShowQuiz()
              
            Case 1
              
              ;Cancel Clicked
              Mode = #Show
              HideIconBarGadget(IconBarEdit, #True)
              HideIconBarGadget(IconBarMain, #False)
              HideGadget(#cmbTitle,#False)
              HideGadget(#strTitle,#True)             
              DisableGadget(#cmbTitle,#False)
              DisableGadget(#cmbCategory,#True)
              DisableGadget(#spnDifficulty,#True)
              DisableGadget(#btnQuestions,#True)        
              ShowQuiz()
              
          EndSelect           
          
      EndSelect
      
  EndSelect
  
ForEver

DataSection
  ToolBarAdd:
    IncludeBinary "Resources\note_add.png" 
  ToolBarEdit:
    IncludeBinary "Resources\note_edit.png"
  ToolBarDelete:
    IncludeBinary "Resources\note_delete.png"  
  ToolBarOk:
    IncludeBinary "Resources\Ok.png"
  ToolBarCancel:
    IncludeBinary "Resources\Cancel.png" 
  ToolBareditQ:
    IncludeBinary "Resources\table_edit.png"  
  ToolBarExit:
    IncludeBinary "Resources\Exit.png"  
  ToolBarHelp:
    IncludeBinary "Resources\Help.png" 
  ToolBarSet:
    IncludeBinary "Resources\note_go.png"  
 EndDataSection
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 3
; Folding = A+
; EnableXP